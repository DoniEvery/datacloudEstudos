Certificacao__c cert = [
    SELECT Id, Name
    FROM Certificacao__c
    WHERE Name = 'Salesforce Data 360 Consultant'
    LIMIT 1
];

List<Map<String, Object>> simulados = QuestaoEstudoController.getSimuladosDisponiveis(cert.Id);
System.debug('SIMULADOS DISPONIVEIS | qtd=' + simulados.size());
for (Map<String, Object> simulado : simulados) {
    System.debug('SIMULADOS DISPONIVEIS | item=' + simulado);
}

List<Map<String, Object>> questoes = QuestaoEstudoController.getQuestoes(null, null, cert.Id, true, 'SIMULADO', 'Fundamentos Data Cloud');
System.debug('SIMULADOS DISPONIVEIS | questoesNivel1=' + questoes.size());
