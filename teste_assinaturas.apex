Boolean houveExcecao = false;
Integer topicosSize = 0;
Integer subtopicosSize = 0;
Integer questoesSize = 0;

try {
    List<Certificacao__c> certs = [SELECT Id FROM Certificacao__c LIMIT 1];
    Id certId = certs.isEmpty() ? null : certs[0].Id;

    List<DominioCertificacao__c> doms = certId == null
        ? new List<DominioCertificacao__c>()
        : [SELECT Id FROM DominioCertificacao__c WHERE Certificacao__c = :certId LIMIT 1];
    Id dominioId = doms.isEmpty() ? null : doms[0].Id;

    topicosSize = QuestaoEstudoController.getTopicos(certId).size();
    subtopicosSize = QuestaoEstudoController.getSubtopicos(null, dominioId).size();
    questoesSize = QuestaoEstudoController.getQuestoes(null, dominioId, certId, false).size();
} catch (Exception e) {
    houveExcecao = true;
}

System.debug('TOPICOS_SIZE=' + topicosSize);
System.debug('SUBTOPICOS_SIZE=' + subtopicosSize);
System.debug('QUESTOES_SIZE=' + questoesSize);
System.debug('HOUVE_EXCECAO=' + houveExcecao);
