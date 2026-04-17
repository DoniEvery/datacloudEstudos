String soql = 'SELECT+Id,DeveloperName,TableEnumOrId+FROM+CustomField+WHERE+DeveloperName=\'Correta\'';
HttpRequest req = new HttpRequest();
req.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v62.0/tooling/query?q=' + soql);
req.setMethod('GET');
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
HttpResponse res = new Http().send(req);
System.debug('STATUS=' + res.getStatusCode());
System.debug('BODY=' + res.getBody());
