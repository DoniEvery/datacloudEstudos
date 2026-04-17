String targetName = 'Identity Resolution - VISIVEL';

List<Topico__c> targetList = [SELECT Id, Name FROM Topico__c WHERE Name = :targetName ORDER BY CreatedDate DESC LIMIT 1];
if (targetList.isEmpty()) {
    System.debug('ERRO: tópico alvo não encontrado: ' + targetName);
    return;
}
Id targetTopicoId = targetList[0].Id;
System.debug('TOPICO_ALVO=' + targetTopicoId);

List<Topico__c> topicosOutros = [SELECT Id, Name FROM Topico__c WHERE Id != :targetTopicoId];
Set<Id> topicosOutrosIds = new Set<Id>();
for (Topico__c t : topicosOutros) topicosOutrosIds.add(t.Id);
System.debug('TOPICOS_OUTROS=' + topicosOutros.size());

Integer delAlt = 0;
Integer delQ = 0;
Integer delTop = 0;

if (!topicosOutrosIds.isEmpty()) {
    List<Questao__c> questoesOutras = [SELECT Id FROM Questao__c WHERE TopicoPrincipal__c IN :topicosOutrosIds];
    Set<Id> questoesOutrasIds = new Set<Id>();
    for (Questao__c q : questoesOutras) questoesOutrasIds.add(q.Id);

    if (!questoesOutrasIds.isEmpty()) {
        List<AlternativaQuestao__c> altsOutras = [SELECT Id FROM AlternativaQuestao__c WHERE Questao__c IN :questoesOutrasIds];
        if (!altsOutras.isEmpty()) {
            Database.DeleteResult[] drAlt = Database.delete(altsOutras, false);
            for (Database.DeleteResult r : drAlt) if (r.isSuccess()) delAlt++;
        }

        Database.DeleteResult[] drQ = Database.delete(questoesOutras, false);
        for (Database.DeleteResult r : drQ) if (r.isSuccess()) delQ++;
    }

    Database.DeleteResult[] drTop = Database.delete(topicosOutros, false);
    for (Database.DeleteResult r : drTop) if (r.isSuccess()) delTop++;
}

Map<String, Schema.SObjectField> qFields = Schema.SObjectType.Questao__c.fields.getMap();
String enunciadoField = qFields.containsKey('Enunciado__c') ? 'Enunciado__c' : null;

List<String> selectFields = new List<String>{'Id','Name'};
if (enunciadoField != null) selectFields.add(enunciadoField);
String soql = 'SELECT ' + String.join(selectFields, ', ') + ' FROM Questao__c WHERE TopicoPrincipal__c = :targetTopicoId';
List<SObject> qsTarget = Database.query(soql);
List<SObject> upd = new List<SObject>();

String clean(String s) {
    if (s == null) return null;
    String r = s;
    r = r.replaceFirst('^\\s*\\[[A-Za-zÀ-ÿ]+\\]\\s*', '');
    r = r.replaceFirst('^\\s*[A-Za-z]{1,6}(?:\\s+[A-Za-z]{1,6})?\\s*-\\s*', '');
    r = r.replaceFirst('^\\s*[A-Za-z]{1,6}-\\d+\\s*[-:]?\\s*', '');
    r = r.replaceFirst('^\\s*\\d+\\s*[-:]\\s*', '');
    return r.trim();
}

Integer updCount = 0;
for (SObject q : qsTarget) {
    String n0 = (String) q.get('Name');
    String n1 = clean(n0);
    Boolean changed = false;

    if (n1 != null && n1 != '' && n1 != n0) {
        q.put('Name', n1.length() > 80 ? n1.substring(0, 80) : n1);
        changed = true;
    }

    if (enunciadoField != null) {
        String e0 = (String) q.get(enunciadoField);
        String e1 = clean(e0);
        if (e1 != null && e1 != '' && e1 != e0) {
            q.put(enunciadoField, e1);
            changed = true;
        }
    }

    if (changed) upd.add(q);
}

if (!upd.isEmpty()) {
    Database.SaveResult[] sr = Database.update(upd, false);
    for (Database.SaveResult r : sr) if (r.isSuccess()) updCount++;
}

Integer topicosRestantes = [SELECT COUNT() FROM Topico__c];
Integer questoesAlvo = [SELECT COUNT() FROM Questao__c WHERE TopicoPrincipal__c = :targetTopicoId];
System.debug('DEL_ALTERNATIVAS=' + delAlt);
System.debug('DEL_QUESTOES=' + delQ);
System.debug('DEL_TOPICOS=' + delTop);
System.debug('UPD_QUESTOES_ALVO=' + updCount);
System.debug('TOPICOS_RESTANTES=' + topicosRestantes);
System.debug('QUESTOES_NO_ALVO=' + questoesAlvo);
