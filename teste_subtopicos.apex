List<Topico__c> topicos = [SELECT Id, Name FROM Topico__c LIMIT 1];
if (!topicos.isEmpty()) {
    String topicoId = topicos[0].Id;
    System.debug('Topico testado: ' + topicos[0].Name + ' (ID: ' + topicoId + ')');
    try {
        List<Map<String, Object>> subtopicos = QuestaoEstudoController.getSubtopicos(topicoId);
        System.debug('Total de subtopicos retornados: ' + subtopicos.size());
        if (subtopicos.size() > 0) {
            System.debug('Subtopicos encontrados:');
            for (Map<String, Object> sub : subtopicos) {
                System.debug('  - ' + sub);
            }
        } else {
            System.debug('Nenhum subtopico encontrado para este topico');
        }
    } catch (Exception e) {
        System.debug('ERRO ao chamar getSubtopicos: ' + e.getMessage());
        System.debug('Stack: ' + e.getStackTraceString());
    }
}
