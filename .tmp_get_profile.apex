// Buscar ID do Profile System Administrator
String profileQuery = 'SELECT+Id,FullName+FROM+Profile+WHERE+Name=\'System+Administrator\'';
HttpRequest r1 = new HttpRequest();
r1.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v62.0/tooling/query?q=' + profileQuery);
r1.setMethod('GET');
r1.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
HttpResponse res1 = new Http().send(r1);
System.debug('PROFILE=' + res1.getBody());

// Buscar ID do EntityDefinition de AlternativaQuestao__c
String entityQuery = 'SELECT+Id,QualifiedApiName+FROM+EntityDefinition+WHERE+QualifiedApiName=\'AlternativaQuestao__c\'';
HttpRequest r2 = new HttpRequest();
r2.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v62.0/tooling/query?q=' + entityQuery);
r2.setMethod('GET');
r2.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
HttpResponse res2 = new Http().send(r2);
System.debug('ENTITY=' + res2.getBody());
