String certName = 'Salesforce Certified Data 360 Consultant';

Certificacao__c cert;
List<Certificacao__c> certList = [SELECT Id, Name FROM Certificacao__c WHERE Name = :certName LIMIT 1];
if (certList.isEmpty()) {
    cert = new Certificacao__c(Name = certName);
    insert cert;
} else {
    cert = certList[0];
}

List<String> domainNames = new List<String>{
    'Solution Positioning (14%)',
    'Data 360 Setup and Administration (13%)',
    'Data Source Connection and Ingestion (18%)',
    'Harmonization and Unification (17%)',
    'Data Enhancements, Sharing, and Analysis (18%)',
    'Data Activations and Utilization (20%)'
};

Map<String, DominioCertificacao__c> existingDomainsByName = new Map<String, DominioCertificacao__c>();
for (DominioCertificacao__c d : [
    SELECT Id, Name, Certificacao__c
    FROM DominioCertificacao__c
    WHERE Certificacao__c = :cert.Id
    AND Name IN :domainNames
]) {
    existingDomainsByName.put(d.Name, d);
}

List<DominioCertificacao__c> domainsToInsert = new List<DominioCertificacao__c>();
for (String dn : domainNames) {
    if (!existingDomainsByName.containsKey(dn)) {
        domainsToInsert.add(new DominioCertificacao__c(
            Name = dn,
            Certificacao__c = cert.Id
        ));
    }
}
if (!domainsToInsert.isEmpty()) insert domainsToInsert;

Map<String, Id> domainIdByName = new Map<String, Id>();
for (DominioCertificacao__c d : [
    SELECT Id, Name
    FROM DominioCertificacao__c
    WHERE Certificacao__c = :cert.Id
    AND Name IN :domainNames
]) {
    domainIdByName.put(d.Name, d.Id);
}

Map<String, List<String>> topicDefs = new Map<String, List<String>>{
    'Solution Positioning (14%)' => new List<String>{
        'Describe Data 360 terminology and business value.',
        'Explain Data 360 role in generative and predictive AI.',
        'Identify initial Data 360 use cases.',
        'Explain data ethics and governance principles.'
    },
    'Data 360 Setup and Administration (13%)' => new List<String>{
        'Configure permissions, perm sets, and org-wide settings in Data 360.',
        'Apply data governance requirements to platform configuration.',
        'Manage lifecycle with available tooling.',
        'Use tooling to diagnose and troubleshoot common issues.'
    },
    'Data Source Connection and Ingestion (18%)' => new List<String>{
        'Explain data transformation capabilities in Data 360.',
        'Describe ingestion processes from varied sources into Data 360.',
        'Describe data collaboration in Data 360, including Zero-Copy.'
    },
    'Harmonization and Unification (17%)' => new List<String>{
        'Define purpose, process, and use cases of unification.',
        'Model data in Data 360.'
    },
    'Data Enhancements, Sharing, and Analysis (18%)' => new List<String>{
        'Enhance data and build insights on unified data.',
        'Explain how to reference Data 360 data from other systems.',
        'Build reports and dashboards using Data 360.',
        'Apply predictive and generative AI tooling to customer scenarios.'
    },
    'Data Activations and Utilization (20%)' => new List<String>{
        'Define core segmentation concepts and use cases.',
        'Manage segments within Data 360.',
        'Publish Activations within Data 360.',
        'Act on data.',
        'Use Data 360 in Salesforce flows.'
    }
};

Set<String> allTopicNames = new Set<String>();
for (String k : topicDefs.keySet()) allTopicNames.addAll(topicDefs.get(k));

Map<String, Topico__c> existingTopicByKey = new Map<String, Topico__c>();
for (Topico__c t : [
    SELECT Id, Name, DominioCertificacao__c
    FROM Topico__c
    WHERE Name IN :allTopicNames
    AND DominioCertificacao__c IN :domainIdByName.values()
]) {
    existingTopicByKey.put(t.Name + '||' + t.DominioCertificacao__c, t);
}

List<Topico__c> topicsToInsert = new List<Topico__c>();
for (String domainName : topicDefs.keySet()) {
    Id domainId = domainIdByName.get(domainName);
    for (String topicName : topicDefs.get(domainName)) {
        String key = topicName + '||' + domainId;
        if (!existingTopicByKey.containsKey(key)) {
            topicsToInsert.add(new Topico__c(
                Name = topicName,
                DominioCertificacao__c = domainId
            ));
        }
    }
}
if (!topicsToInsert.isEmpty()) insert topicsToInsert;

Integer dCount = [SELECT Count() FROM DominioCertificacao__c WHERE Certificacao__c = :cert.Id];
Integer tCount = [SELECT Count() FROM Topico__c WHERE DominioCertificacao__c IN :domainIdByName.values()];
System.debug('OK - Cert=' + cert.Id + ', Domains=' + dCount + ', Topics=' + tCount);