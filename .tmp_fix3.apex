List<Integer> ordemCorretaPorIndice = new List<Integer>{1, 2, 3, 2, 2};
List<Questao__c> questoes = [SELECT Id FROM Questao__c WHERE TopicoPrincipal__c != null ORDER BY CreatedDate ASC];
System.debug('QUESTOES=' + questoes.size());
Map<Id, Integer> ordemCorretaPorQId = new Map<Id, Integer>();
for (Integer i = 0; i < questoes.size() && i < ordemCorretaPorIndice.size(); i++) {
    ordemCorretaPorQId.put(questoes[i].Id, ordemCorretaPorIndice[i]);
}
Set<Id> qIds = ordemCorretaPorQId.keySet();
List<AlternativaQuestao__c> alts = [SELECT Id, Questao__c, OrdemExibicao__c, Correta__c FROM AlternativaQuestao__c WHERE Questao__c IN :qIds];
List<AlternativaQuestao__c> toUpdate = new List<AlternativaQuestao__c>();
for (AlternativaQuestao__c a : alts) {
    Integer ordemCorreta = ordemCorretaPorQId.get(a.Questao__c);
    Boolean deveSerCorreta = (ordemCorreta != null && a.OrdemExibicao__c != null && a.OrdemExibicao__c.intValue() == ordemCorreta);
    if (a.Correta__c != deveSerCorreta) {
        a.Correta__c = deveSerCorreta;
        toUpdate.add(a);
    }
}
if (!toUpdate.isEmpty()) update toUpdate;
System.debug('UPDATED=' + toUpdate.size());