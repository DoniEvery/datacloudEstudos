Id topicoId = [SELECT Id FROM Topico__c WHERE Name = 'Identity Resolution' ORDER BY CreatedDate DESC LIMIT 1].Id;
List<Map<String,Object>> qs = QuestaoEstudoController.getQuestoes(topicoId);
System.debug('TOPICO=' + topicoId + ' TOTAL=' + qs.size());
if (!qs.isEmpty()) {
    Map<String,Object> q = qs[0];
    List<Object> alts = (List<Object>) q.get('alternativas');
    System.debug('Q1=' + q.get('enunciado'));
    System.debug('ALTS=' + (alts == null ? 0 : alts.size()));
    if (alts != null && !alts.isEmpty()) {
        System.debug('ALT1=' + alts[0]);
    }
}
