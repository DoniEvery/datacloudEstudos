for (Questao__c q : [SELECT Id, Name, Enunciado__c, StatusPublicacao__c, Ativa__c, TopicoPrincipal__r.Name FROM Questao__c WHERE Name LIKE 'IR REAL %' ORDER BY CreatedDate DESC LIMIT 3]) {
    System.debug('Q_VIEW|ID=' + q.Id + '|NAME=' + q.Name + '|STATUS=' + q.StatusPublicacao__c + '|ATIVA=' + q.Ativa__c + '|TOPICO=' + q.TopicoPrincipal__r.Name + '|ENUN=' + q.Enunciado__c);
}
