Id topicoId = 'a2ufj00000Cj7eLAAR';
List<Map<String, Object>> qs = QuestaoEstudoController.getQuestoes(topicoId);
System.debug('TOTAL_QUESTOES=' + qs.size());
if (!qs.isEmpty()) {
    Map<String, Object> q0 = qs[0];
    List<Object> alts = (List<Object>) q0.get('alternativas');
    System.debug('PRIMEIRA_QUESTAO=' + q0.get('enunciado'));
    System.debug('ALTERNATIVAS_QTD=' + (alts == null ? 0 : alts.size()));
    if (alts != null && !alts.isEmpty()) {
        System.debug('ALT_1=' + alts[0]);
    }
}
