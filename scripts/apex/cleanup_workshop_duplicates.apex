// Remove duplicatas de questões do workshop sem alternativas
// Mantém versões que já têm alternativas vinculadas

Certificacao__c cert = [SELECT Id FROM Certificacao__c WHERE Name = 'Salesforce Data 360 Consultant' LIMIT 1];

Map<Id, Integer> altCountByQuestion = new Map<Id, Integer>();
for (AggregateResult ar : [
    SELECT Questao__c qId, COUNT(Id) total
    FROM AlternativaQuestao__c
    WHERE Questao__r.Certificacao__c = :cert.Id
    GROUP BY Questao__c
]) {
    altCountByQuestion.put((Id) ar.get('qId'), (Integer) ar.get('total'));
}

List<Questao__c> workshop = [
    SELECT Id, Name, Enunciado__c, CreatedDate
    FROM Questao__c
    WHERE Certificacao__c = :cert.Id
    AND Name LIKE 'Workshop - %'
    ORDER BY CreatedDate ASC
];

Map<String, List<Questao__c>> byEnunciado = new Map<String, List<Questao__c>>();
for (Questao__c q : workshop) {
    String key = String.isBlank(q.Enunciado__c) ? ('__NO_ENUNCIADO__' + q.Id) : q.Enunciado__c;
    if (!byEnunciado.containsKey(key)) byEnunciado.put(key, new List<Questao__c>());
    byEnunciado.get(key).add(q);
}

List<Questao__c> toDelete = new List<Questao__c>();
Integer groupsWithDup = 0;

for (String key : byEnunciado.keySet()) {
    List<Questao__c> grp = byEnunciado.get(key);
    if (grp.size() <= 1) continue;
    groupsWithDup++;

    // Mantém 1 registro com alternativas (preferencialmente); remove os demais
    Questao__c keep;
    for (Questao__c q : grp) {
        if ((altCountByQuestion.containsKey(q.Id) ? altCountByQuestion.get(q.Id) : 0) > 0) {
            keep = q;
            break;
        }
    }
    if (keep == null) keep = grp[0];

    for (Questao__c q : grp) {
        if (q.Id != keep.Id) toDelete.add(q);
    }
}

if (!toDelete.isEmpty()) delete toDelete;

System.debug('WORKSHOP CLEANUP OK | Grupos duplicados: ' + groupsWithDup + ' | Questões removidas: ' + toDelete.size());
