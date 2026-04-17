String fieldJson = '{"FullName":"AlternativaQuestao__c.Correta__c","Metadata":{"defaultValue":false,"externalId":false,"label":"Correta","type":"Checkbox","trackTrending":false}}';
HttpRequest req = new HttpRequest();
req.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v62.0/tooling/sobjects/CustomField');
req.setMethod('POST');
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
req.setHeader('Content-Type', 'application/json');
req.setBody(fieldJson);
HttpResponse res = new Http().send(req);
System.debug('STATUS=' + res.getStatusCode() + ' BODY=' + res.getBody());
