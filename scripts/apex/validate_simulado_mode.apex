Certificacao__c cert = [
    SELECT Id, Name
    FROM Certificacao__c
    WHERE Name = 'Salesforce Data 360 Consultant'
    LIMIT 1
];

DominioCertificacao__c dom = [
    SELECT Id, Name
    FROM DominioCertificacao__c
    WHERE Certificacao__c = :cert.Id
    ORDER BY CreatedDate ASC
    LIMIT 1
];

List<Map<String, Object>> simulado = QuestaoEstudoController.getQuestoes(null, null, cert.Id, true, 'SIMULADO');
List<Map<String, Object>> livre = QuestaoEstudoController.getQuestoes(null, dom.Id, cert.Id, false, 'LIVRE');

System.debug('VALIDACAO SIMULADO | qtd=' + simulado.size());
System.debug('VALIDACAO LIVRE | qtd=' + livre.size());
if (!simulado.isEmpty()) {
    System.debug('VALIDACAO SIMULADO | primeira=' + simulado[0].get('enunciado'));
}
if (!livre.isEmpty()) {
    System.debug('VALIDACAO LIVRE | primeira=' + livre[0].get('enunciado'));
}
