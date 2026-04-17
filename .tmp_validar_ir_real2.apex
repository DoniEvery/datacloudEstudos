List<Questao__c> qs = [SELECT Id, Name, CreatedDate FROM Questao__c WHERE Name LIKE 'IR REAL %' ORDER BY CreatedDate DESC LIMIT 8];
System.debug('QTD_Q=' + qs.size());
Set<Id> qIds = new Set<Id>();
for (Questao__c q : qs) {
    qIds.add(q.Id);
    System.debug('Q_ROW|ID=' + q.Id + '|NAME=' + q.Name + '|CREATED=' + q.CreatedDate);
}
if (!qIds.isEmpty()) {
    for (AggregateResult a : [SELECT Questao__c qid, COUNT(Id) c FROM AlternativaQuestao__c WHERE Questao__c IN :qIds GROUP BY Questao__c]) {
        System.debug('ALT_COUNT|Q=' + (Id)a.get('qid') + '|C=' + (Decimal)a.get('c'));
    }
}
