// Corrige capitalização das alternativas do simulado N1
// Objetivo: evitar padrão de resposta correta iniciando com letra minúscula

List<AlternativaQuestao__c> alts = [
    SELECT Id, Name, ExplicacaoAlternativa__c, Correta__c
    FROM AlternativaQuestao__c
    WHERE Questao__r.ColecaoSimulado__c = 'Fundamentos Data Cloud'
    ORDER BY Questao__c, OrdemExibicao__c
];

List<AlternativaQuestao__c> upd = new List<AlternativaQuestao__c>();
for (AlternativaQuestao__c a : alts) {
    Boolean changed = false;

    if (!String.isBlank(a.Name) && a.Name.length() > 0) {
        String first = a.Name.substring(0, 1);
        String upper = first.toUpperCase();
        if (first != upper) {
            a.Name = upper + a.Name.substring(1);
            changed = true;
        }
    }

    if (!String.isBlank(a.ExplicacaoAlternativa__c) && a.ExplicacaoAlternativa__c.length() > 0) {
        String f2 = a.ExplicacaoAlternativa__c.substring(0, 1);
        String u2 = f2.toUpperCase();
        if (f2 != u2) {
            a.ExplicacaoAlternativa__c = u2 + a.ExplicacaoAlternativa__c.substring(1);
            changed = true;
        }
    }

    if (changed) {
        upd.add(a);
    }
}

if (!upd.isEmpty()) {
    update upd;
}

System.debug('FIX N1 CAPITALIZACAO OK | Atualizadas: ' + upd.size());
