List<AlternativaQuestao__c> alts = [SELECT Id, Name, Correta__c, OrdemExibicao__c FROM AlternativaQuestao__c LIMIT 5];
for (AlternativaQuestao__c a : alts) {
    System.debug('NAME=' + a.Name + ' CORRETA=' + a.Correta__c + ' ORDEM=' + a.OrdemExibicao__c);
}
System.debug('TOTAL=' + alts.size());
