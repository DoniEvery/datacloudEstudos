// Mapear questao por Name e corrigir alternativas corretas
// Q1: correta = ordem 1 (Unificar perfis de origem)
// Q2: correta = ordem 2 (10)
// Q3: correta = ordem 3 (10)
// Q4: correta = ordem 2 (Uma vez por dia)
// Q5: correta = ordem 2 (Conectar source records)
Map<String, Integer> corretaPorQuestao = new Map<String, Integer>();
corretaPorQuestao.put('Qual é o objetivo principal do Identity Resolution?', 1);
corretaPorQuestao.put('Qual é o limite de Match Rules por ruleset?', 2);
corretaPorQuestao.put('Qual é o limite de critérios por Match Rule?', 3);
corretaPorQuestao.put('Qual é a frequência agendada máxima por ruleset?', 2);
corretaPorQuestao.put('Qual é o papel do Unified Link Object?', 2);

List<Questao__c> questoes = [SELECT Id, Name FROM Questao__c WHERE Name IN :corretaPorQuestao.keySet()];
System.debug('QUESTOES=' + questoes.size());
Set<Id> qIds = new Set<Id>();
Map<Id, Integer> ordemCorretaPorQId = new Map<Id, Integer>();
for (Questao__c q : questoes) {
    qIds.add(q.Id);
    ordemCorretaPorQId.put(q.Id, corretaPorQuestao.get(q.Name));
}

List<AlternativaQuestao__c> alts = [SELECT Id, Questao__c, OrdemExibicao__c, Correta__c FROM AlternativaQuestao__c WHERE Questao__c IN :qIds];
List<AlternativaQuestao__c> toUpdate = new List<AlternativaQuestao__c>();
for (AlternativaQuestao__c a : alts) {
    Integer ordemCorreta = ordemCorretaPorQId.get(a.Questao__c);
    Boolean deveSerCorreta = (a.OrdemExibicao__c != null && a.OrdemExibicao__c.intValue() == ordemCorreta);
    if (a.Correta__c != deveSerCorreta) {
        a.Correta__c = deveSerCorreta;
        toUpdate.add(a);
    }
}
if (!toUpdate.isEmpty()) update toUpdate;
System.debug('UPDATED=' + toUpdate.size());
