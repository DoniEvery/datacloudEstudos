Id targetId = [SELECT Id FROM Topico__c WHERE Name = 'Identity Resolution - VISIVEL' LIMIT 1].Id;
List<Questao__c> qs = [SELECT Id, Name FROM Questao__c WHERE TopicoPrincipal__c = :targetId];
List<Questao__c> upd = new List<Questao__c>();
for (Questao__c q : qs) {
    String n = q.Name;
    String fixed = n;
    if (n == 'limite de Match Rules por ruleset? #341940') fixed = 'Qual limite de Match Rules por ruleset? #341940';
    else if (n == 'limite de critérios por Match Rule? #341940') fixed = 'Qual limite de critérios por Match Rule? #341940';
    else if (n == 'de jobs do ruleset em 24h? #341940') fixed = 'Limite de jobs do ruleset em 24h? #341940';
    else if (n == 'do Unified Link Object? #341940') fixed = 'Papel do Unified Link Object? #341940';

    if (fixed != n) {
        q.Name = fixed;
        upd.add(q);
    }
}
Integer ok = 0;
if (!upd.isEmpty()) {
    Database.SaveResult[] sr = Database.update(upd, false);
    for (Database.SaveResult r : sr) if (r.isSuccess()) ok++;
}
System.debug('QUESTOES_CORRIGIDAS=' + ok);
