HttpRequest req = new HttpRequest();
req.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/data/v62.0/tooling/sobjects/CustomField/00Nfj00003EQXtCEAX');
req.setMethod('GET');
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
HttpResponse res = new Http().send(req);
System.debug('STATUS=' + res.getStatusCode());
System.debug('BODY=' + res.getBody());
