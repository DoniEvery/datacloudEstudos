Id targetId = [SELECT Id FROM Topico__c WHERE Name = 'Identity Resolution - VISIVEL' ORDER BY CreatedDate DESC LIMIT 1].Id;

List<Questao__c> foraAlvo = [SELECT Id, Name, TopicoPrincipal__c FROM Questao__c WHERE TopicoPrincipal__c != :targetId];
for (Questao__c q : foraAlvo) {
    q.TopicoPrincipal__c = targetId;
}
Integer moved = 0;
if (!foraAlvo.isEmpty()) {
    Database.SaveResult[] srMove = Database.update(foraAlvo, false);
    for (Database.SaveResult r : srMove) if (r.isSuccess()) moved++;
}

List<Topico__c> tops = [SELECT Id, Name FROM Topico__c WHERE Id != :targetId];
Integer delTop = 0;
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

Map<String, Schema.SObjectField> qFields = Schema.SObjectType.Questao__c.fields.getMap();
String enunciadoField = qFields.containsKey('Enunciado__c') ? 'Enunciado__c' : null;
List<String> qSel = new List<String>{'Id','Name'};
if (enunciadoField != null) qSel.add(enunciadoField);
List<SObject> qTarget = Database.query('SELECT ' + String.join(qSel, ', ') + ' FROM Questao__c WHERE TopicoPrincipal__c = :targetId');

String clean(String s) {
    if (s == null) return null;
    String r = s;
    r = r.replaceFirst('^\\s*\\[[A-Za-zÀ-ÿ]+\\]\\s*', '');
    r = r.replaceFirst('^\\s*IR\\s+REAL\\s+\\d+\\s*-\\s*', '');
    r = r.replaceFirst('^\\s*[A-Za-zÀ-ÿ]+\\s*-\\s*', '');
    r = r.replaceFirst('^\\s*[A-Za-zÀ-ÿ]+\\s+', '');
    r = r.trim();
    return r;
}

List<SObject> upd = new List<SObject>();
Integer cleaned = 0;
for (SObject q : qTarget) {
    Boolean changed = false;
    String n0 = (String) q.get('Name');
    String n1 = clean(n0);
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
    Database.SaveResult[] srUpd = Database.update(upd, false);
    for (Database.SaveResult r : srUpd) if (r.isSuccess()) cleaned++;
}

System.debug('MOVED_QUESTOES=' + moved);
System.debug('DEL_TOPICOS=' + delTop);
System.debug('CLEANED_QUESTOES=' + cleaned);
System.debug('TOPICOS_RESTANTES=' + [SELECT COUNT() FROM Topico__c]);
System.debug('TOPICO_ALVO_QUESTOES=' + [SELECT COUNT() FROM Questao__c WHERE TopicoPrincipal__c = :targetId]);
