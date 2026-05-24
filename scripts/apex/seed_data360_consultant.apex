String certName = 'Salesforce Certified Data 360 Consultant';

List<Certificacao__c> certs = [
    SELECT Id, Name, Codigo__c, Descricao__c, Ativa__c
    FROM Certificacao__c
    WHERE Name = :certName
    LIMIT 1
];

Certificacao__c cert;
if (certs.isEmpty()) {
    cert = new Certificacao__c(
        Name = certName,
        Codigo__c = 'SF-DATA360-CONSULTANT',
        Descricao__c = 'Certificação Salesforce Certified Data 360 Consultant',
        Ativa__c = true,
        OrdemExibicao__c = 1
    );
    insert cert;
    System.debug('Certificação criada: ' + cert.Id);
} else {
    cert = certs[0];
    cert.Codigo__c = 'SF-DATA360-CONSULTANT';
    cert.Descricao__c = 'Certificação Salesforce Certified Data 360 Consultant';
    cert.Ativa__c = true;
    if (cert.OrdemExibicao__c == null) cert.OrdemExibicao__c = 1;
    update cert;
    System.debug('Certificação atualizada: ' + cert.Id);
}

List<Map<String, Object>> domainDefs = new List<Map<String, Object>>{
    new Map<String, Object>{ 'name' => 'Solution Positioning', 'peso' => 14, 'ordem' => 1 },
    new Map<String, Object>{ 'name' => 'Data 360 Setup and Administration', 'peso' => 13, 'ordem' => 2 },
    new Map<String, Object>{ 'name' => 'Data Source Connection and Ingestion', 'peso' => 18, 'ordem' => 3 },
    new Map<String, Object>{ 'name' => 'Harmonization and Unification', 'peso' => 17, 'ordem' => 4 },
    new Map<String, Object>{ 'name' => 'Data Enhancements, Sharing, and Analysis', 'peso' => 18, 'ordem' => 5 },
    new Map<String, Object>{ 'name' => 'Data Activations and Utilization', 'peso' => 20, 'ordem' => 6 }
};

Set<String> domainNames = new Set<String>();
for (Map<String, Object> d : domainDefs) domainNames.add((String)d.get('name'));

Map<String, DominioCertificacao__c> existingDomainsByName = new Map<String, DominioCertificacao__c>();
for (DominioCertificacao__c d : [
    SELECT Id, Name, Certificacao__c, Codigo__c, Descricao__c, PesoProva__c, OrdemExibicao__c, Ativo__c
    FROM DominioCertificacao__c
    WHERE Certificacao__c = :cert.Id
    AND Name IN :domainNames
]) {
    existingDomainsByName.put(d.Name, d);
}

List<DominioCertificacao__c> domainsToInsert = new List<DominioCertificacao__c>();
List<DominioCertificacao__c> domainsToUpdate = new List<DominioCertificacao__c>();
Integer idx = 1;
for (Map<String, Object> d : domainDefs) {
    String name = (String)d.get('name');
    Decimal peso = Decimal.valueOf(String.valueOf(d.get('peso')));
    Integer ordem = Integer.valueOf(String.valueOf(d.get('ordem')));

    if (existingDomainsByName.containsKey(name)) {
        DominioCertificacao__c rec = existingDomainsByName.get(name);
        rec.Certificacao__c = cert.Id;
        rec.Codigo__c = 'D360-' + String.valueOf(ordem).leftPad(2, '0');
        rec.Descricao__c = name;
        rec.PesoProva__c = peso;
        rec.OrdemExibicao__c = ordem;
        rec.Ativo__c = true;
        domainsToUpdate.add(rec);
    } else {
        DominioCertificacao__c rec = new DominioCertificacao__c(
            Name = name,
            Certificacao__c = cert.Id,
            Codigo__c = 'D360-' + String.valueOf(ordem).leftPad(2, '0'),
            Descricao__c = name,
            PesoProva__c = peso,
            OrdemExibicao__c = ordem,
            Ativo__c = true
        );
        domainsToInsert.add(rec);
    }
    idx++;
}

if (!domainsToInsert.isEmpty()) insert domainsToInsert;
if (!domainsToUpdate.isEmpty()) update domainsToUpdate;

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
    'Solution Positioning' => new List<String>{
        'Describe Data 360’s key terminology and business value.',
        'Articulate Data 360’s foundational role in generative and predictive AI.',
        'Identify initial use cases for Data 360.',
        'Describe the principles of data ethics and governance.'
    },
    'Data 360 Setup and Administration' => new List<String>{
        'Configure Data 360 permissions, permission sets, and organization-wide settings.',
        'Apply data governance requirements to platform configuration.',
        'Manage the development lifecycle with available tooling.',
        'Use tooling to diagnose and troubleshoot common issues.'
    },
    'Data Source Connection and Ingestion' => new List<String>{
        'Explain data transformation capabilities within Data 360.',
        'Describe processes and considerations for data ingestion from varied sources into Data 360.',
        'Describe Data 360’s data collaboration capabilities, including Zero-Copy.'
    },
    'Harmonization and Unification' => new List<String>{
        'Define the purpose, process, and supported use cases of unification.',
        'Model data in Data 360.'
    },
    'Data Enhancements, Sharing, and Analysis' => new List<String>{
        'Demonstrate how to enhance data and build insights on unified data.',
        'Explain how to reference Data 360 data from other systems.',
        'View and build reports and dashboards using Data 360.',
        'Apply predictive and generative AI tooling capabilities of Data 360 to customer scenarios.'
    },
    'Data Activations and Utilization' => new List<String>{
        'Define basic concepts of segmentation and use cases.',
        'Manage segments within Data 360.',
        'Publish Activations within Data 360.',
        'Act on data.',
        'Use Data 360 in Salesforce flows.'
    }
};

Set<String> allTopicNames = new Set<String>();
for (String dName : topicDefs.keySet()) {
    allTopicNames.addAll(topicDefs.get(dName));
}

Map<String, Topico__c> existingTopicsByNameAndDomain = new Map<String, Topico__c>();
for (Topico__c t : [
    SELECT Id, Name, DominioCertificacao__c, Descricao__c, OrdemExibicao__c, Ativo__c, EhTopicoCritico__c
    FROM Topico__c
    WHERE Name IN :allTopicNames
    AND DominioCertificacao__c IN :domainIdByName.values()
]) {
    existingTopicsByNameAndDomain.put(t.Name + '||' + t.DominioCertificacao__c, t);
}

List<Topico__c> topicsToInsert = new List<Topico__c>();
List<Topico__c> topicsToUpdate = new List<Topico__c>();
for (String dName : topicDefs.keySet()) {
    Id dId = domainIdByName.get(dName);
    Integer ordemTopico = 1;
    for (String topicName : topicDefs.get(dName)) {
        String k = topicName + '||' + dId;
        if (existingTopicsByNameAndDomain.containsKey(k)) {
            Topico__c rec = existingTopicsByNameAndDomain.get(k);
            rec.Descricao__c = topicName;
            rec.OrdemExibicao__c = ordemTopico;
            rec.Ativo__c = true;
            rec.EhTopicoCritico__c = false;
            topicsToUpdate.add(rec);
        } else {
            Topico__c rec = new Topico__c(
                Name = topicName,
                DominioCertificacao__c = dId,
                Descricao__c = topicName,
                OrdemExibicao__c = ordemTopico,
                Ativo__c = true,
                EhTopicoCritico__c = false
            );
            topicsToInsert.add(rec);
        }
        ordemTopico++;
    }
}

if (!topicsToInsert.isEmpty()) insert topicsToInsert;
if (!topicsToUpdate.isEmpty()) update topicsToUpdate;

Integer domainCount = [SELECT Count() FROM DominioCertificacao__c WHERE Certificacao__c = :cert.Id];
Integer topicCount = [
    SELECT Count()
    FROM Topico__c
    WHERE DominioCertificacao__r.Certificacao__c = :cert.Id
];

System.debug('Seed concluído. Certificação=' + cert.Id + ', Domínios=' + domainCount + ', Tópicos=' + topicCount);