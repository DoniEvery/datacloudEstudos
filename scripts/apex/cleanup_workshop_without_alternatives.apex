// Remove questões do workshop sem alternativas (sobras de execução anterior)

Certificacao__c cert = [SELECT Id FROM Certificacao__c WHERE Name = 'Salesforce Data 360 Consultant' LIMIT 1];

Set<Id> qComAlternativas = new Set<Id>();
for (AggregateResult ar : [
    SELECT Questao__c qId, COUNT(Id) total
    FROM AlternativaQuestao__c
    WHERE Questao__r.Certificacao__c = :cert.Id
    GROUP BY Questao__c
]) {
    qComAlternativas.add((Id) ar.get('qId'));
}

List<Questao__c> toDelete = [
    SELECT Id, Name
    FROM Questao__c
    WHERE Certificacao__c = :cert.Id
    AND Name LIKE 'Workshop - %'
    AND Id NOT IN :qComAlternativas
];

if (!toDelete.isEmpty()) delete toDelete;

System.debug('WORKSHOP ORPHAN CLEANUP OK | Removidas: ' + toDelete.size());
