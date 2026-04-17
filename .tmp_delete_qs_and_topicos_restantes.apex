Id targetId = [SELECT Id FROM Topico__c WHERE Name = 'Identity Resolution - VISIVEL' ORDER BY CreatedDate DESC LIMIT 1].Id;
Set<Id> topicoIds = new Set<Id>();
for (Topico__c t : [SELECT Id FROM Topico__c WHERE Id != :targetId]) topicoIds.add(t.Id);

List<Questao__c> qs = [SELECT Id, Name, TopicoPrincipal__c FROM Questao__c WHERE TopicoPrincipal__c IN :topicoIds];
Set<Id> qIds = new Set<Id>();
for (Questao__c q : qs) qIds.add(q.Id);
System.debug('Q_FORA_ALVO=' + qs.size());

Integer delAlt = 0;
if (!qIds.isEmpty()) {
    List<AlternativaQuestao__c> alts = [SELECT Id FROM AlternativaQuestao__c WHERE Questao__c IN :qIds];
    Database.DeleteResult[] drAlt = Database.delete(alts, false);
    for (Database.DeleteResult r : drAlt) if (r.isSuccess()) delAlt++;
}

Integer delQ = 0;
if (!qs.isEmpty()) {
    Database.DeleteResult[] drQ = Database.delete(qs, false);
    for (Integer i = 0; i < drQ.size(); i++) {
        if (drQ[i].isSuccess()) {
            delQ++;
        } else {
            for (Database.Error e : drQ[i].getErrors()) {
                System.debug('DEL_Q_ERRO|ID=' + qs[i].Id + '|NAME=' + qs[i].Name + '|STATUS=' + e.getStatusCode() + '|MSG=' + e.getMessage());
            }
        }
    }
}

Integer delTop = 0;
List<Topico__c> tops = [SELECT Id, Name FROM Topico__c WHERE Id != :targetId];
if (!tops.isEmpty()) {
    Database.DeleteResult[] drTop = Database.delete(tops, false);
    for (Integer i = 0; i < drTop.size(); i++) {
        if (drTop[i].isSuccess()) {
            delTop++;
        } else {
            for (Database.Error e : drTop[i].getErrors()) {
                System.debug('DEL_TOP_ERRO|ID=' + tops[i].Id + '|NAME=' + tops[i].Name + '|STATUS=' + e.getStatusCode() + '|MSG=' + e.getMessage());
            }
        }
    }
}

System.debug('DEL_ALT=' + delAlt);
System.debug('DEL_Q=' + delQ);
System.debug('DEL_TOP=' + delTop);
System.debug('TOPICOS_RESTANTES=' + [SELECT COUNT() FROM Topico__c]);
System.debug('QUESTOES_FORA_ALVO_RESTANTES=' + [SELECT COUNT() FROM Questao__c WHERE TopicoPrincipal__c != :targetId]);
