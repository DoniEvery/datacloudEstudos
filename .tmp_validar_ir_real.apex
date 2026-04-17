List<SObject> qs = Database.query('SELECT FIELDS(ALL) FROM Questao__c WHERE Name LIKE \'IR REAL %\' ORDER BY CreatedDate DESC LIMIT 8');
System.debug('QTD_Q=' + qs.size());
for (SObject q : qs) {
    System.debug('Q_ROW|ID=' + q.get('Id') + '|NAME=' + q.get('Name'));
}
Set<Id> qIds = new Set<Id>();
for (SObject q : qs) qIds.add((Id)q.get('Id'));
if (!qIds.isEmpty()) {
    List<AggregateResult> ag = [SELECT Questao__c qid, COUNT(Id) c FROM AlternativaQuestao__c WHERE Questao__c IN :qIds GROUP BY Questao__c];
    for (AggregateResult a : ag) {
        System.debug('ALT_COUNT|Q=' + (Id)a.get('qid') + '|C=' + (Decimal)a.get('c'));
    }
}
