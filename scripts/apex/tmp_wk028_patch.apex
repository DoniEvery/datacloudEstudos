// Patch: seta CodigoQuestao__c nas questoes WK028-WK032 por conteudo do Enunciado
List<Questao__c> qs = [SELECT Id, Enunciado__c FROM Questao__c LIMIT 200];
List<Questao__c> upd = new List<Questao__c>();
for (Questao__c q : qs) {
    String e = (String) q.get('Enunciado__c');
    if (e == null) continue;
    if (e.contains('ordem correta') && e.contains('CRM Connector')) {
        q.put('CodigoQuestao__c', 'WK028'); upd.add(q);
    } else if (e.contains('ordem correta') && e.contains('Amazon S3')) {
        q.put('CodigoQuestao__c', 'WK029'); upd.add(q);
    } else if (e.contains('Data Lake Object') && e.contains('contexto do Data Cloud')) {
        q.put('CodigoQuestao__c', 'WK030'); upd.add(q);
    } else if (e.contains('etapa do pipeline') && e.contains('Customer 360 Data Model')) {
        q.put('CodigoQuestao__c', 'WK031'); upd.add(q);
    } else if (e.contains('principal diferen') && e.contains('Data Lake Object') && e.contains('Data Model Object')) {
        q.put('CodigoQuestao__c', 'WK032'); upd.add(q);
    }
}
if (!upd.isEmpty()) update upd;
System.debug('PATCH WK028-WK032 OK | Atualizadas: ' + upd.size());
