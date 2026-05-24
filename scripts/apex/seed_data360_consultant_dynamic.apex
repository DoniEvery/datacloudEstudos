public class SeedData360Helper {
    public static void putIfExists(SObject rec, Map<String, Schema.SObjectField> fieldsMap, String api, Object value) {
        if (fieldsMap.containsKey(api)) {
            rec.put(api, value);
        }
    }
}

String certName = 'Salesforce Certified Data 360 Consultant';

Schema.SObjectType certType = Schema.getGlobalDescribe().get('Certificacao__c');
Schema.SObjectType domType = Schema.getGlobalDescribe().get('DominioCertificacao__c');
Schema.SObjectType topType = Schema.getGlobalDescribe().get('Topico__c');

if (certType == null || domType == null || topType == null) {
    System.debug('Objetos não encontrados. Aborting.');
    return;
}

Map<String, Schema.SObjectField> certFields = certType.getDescribe().fields.getMap();
Map<String, Schema.SObjectField> domFields = domType.getDescribe().fields.getMap();
Map<String, Schema.SObjectField> topFields = topType.getDescribe().fields.getMap();

List<SObject> certFound = Database.query('SELECT Id, Name FROM Certificacao__c WHERE Name = :certName LIMIT 1');
SObject cert;
if (certFound.isEmpty()) {
    cert = certType.newSObject();
    cert.put('Name', certName);
    SeedData360Helper.putIfExists(cert, certFields, 'Codigo__c', 'SF-DATA360-CONSULTANT');
    SeedData360Helper.putIfExists(cert, certFields, 'Descricao__c', 'Certificação Salesforce Certified Data 360 Consultant');
    SeedData360Helper.putIfExists(cert, certFields, 'Ativa__c', true);
    SeedData360Helper.putIfExists(cert, certFields, 'OrdemExibicao__c', 1);
    insert cert;
} else {
    cert = certFound[0];
    SeedData360Helper.putIfExists(cert, certFields, 'Codigo__c', 'SF-DATA360-CONSULTANT');
    SeedData360Helper.putIfExists(cert, certFields, 'Descricao__c', 'Certificação Salesforce Certified Data 360 Consultant');
    SeedData360Helper.putIfExists(cert, certFields, 'Ativa__c', true);
    SeedData360Helper.putIfExists(cert, certFields, 'OrdemExibicao__c', 1);
    update cert;
}

Id certId = (Id) cert.get('Id');

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

Map<String, SObject> domainByName = new Map<String, SObject>();
for (SObject rec : Database.query('SELECT Id, Name FROM DominioCertificacao__c WHERE Certificacao__c = :certId AND Name IN :domainNames')) {
    domainByName.put((String)rec.get('Name'), rec);
}

List<SObject> domainsToInsert = new List<SObject>();
List<SObject> domainsToUpdate = new List<SObject>();
for (Map<String, Object> d : domainDefs) {
    String dName = (String)d.get('name');
    Integer ordem = Integer.valueOf(String.valueOf(d.get('ordem')));
    Decimal peso = Decimal.valueOf(String.valueOf(d.get('peso')));

    SObject rec = domainByName.containsKey(dName) ? domainByName.get(dName) : domType.newSObject();
    rec.put('Name', dName);
    SeedData360Helper.putIfExists(rec, domFields, 'Certificacao__c', certId);
    SeedData360Helper.putIfExists(rec, domFields, 'Codigo__c', 'D360-' + String.valueOf(ordem).leftPad(2, '0'));
    SeedData360Helper.putIfExists(rec, domFields, 'Descricao__c', dName);
    SeedData360Helper.putIfExists(rec, domFields, 'PesoProva__c', peso);
    SeedData360Helper.putIfExists(rec, domFields, 'OrdemExibicao__c', ordem);
    SeedData360Helper.putIfExists(rec, domFields, 'Ativo__c', true);

    if (domainByName.containsKey(dName)) domainsToUpdate.add(rec); else domainsToInsert.add(rec);
}
if (!domainsToInsert.isEmpty()) insert domainsToInsert;
if (!domainsToUpdate.isEmpty()) update domainsToUpdate;

Map<String, Id> domainIdByName = new Map<String, Id>();
for (SObject rec : Database.query('SELECT Id, Name FROM DominioCertificacao__c WHERE Certificacao__c = :certId AND Name IN :domainNames')) {
    domainIdByName.put((String)rec.get('Name'), (Id)rec.get('Id'));
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
for (String dName : topicDefs.keySet()) allTopicNames.addAll(topicDefs.get(dName));

Map<String, SObject> topicByNameDomain = new Map<String, SObject>();
for (SObject rec : Database.query('SELECT Id, Name, DominioCertificacao__c FROM Topico__c WHERE Name IN :allTopicNames AND DominioCertificacao__c IN :domainIdByName.values()')) {
    topicByNameDomain.put((String)rec.get('Name') + '||' + String.valueOf(rec.get('DominioCertificacao__c')), rec);
}

List<SObject> topicsToInsert = new List<SObject>();
List<SObject> topicsToUpdate = new List<SObject>();
for (String dName : topicDefs.keySet()) {
    Id dId = domainIdByName.get(dName);
    Integer ordemTopico = 1;
    for (String tName : topicDefs.get(dName)) {
        String key = tName + '||' + String.valueOf(dId);
        SObject rec = topicByNameDomain.containsKey(key) ? topicByNameDomain.get(key) : topType.newSObject();
        rec.put('Name', tName);
        SeedData360Helper.putIfExists(rec, topFields, 'DominioCertificacao__c', dId);
        SeedData360Helper.putIfExists(rec, topFields, 'Descricao__c', tName);
        SeedData360Helper.putIfExists(rec, topFields, 'OrdemExibicao__c', ordemTopico);
        SeedData360Helper.putIfExists(rec, topFields, 'Ativo__c', true);
        SeedData360Helper.putIfExists(rec, topFields, 'EhTopicoCritico__c', false);

        if (topicByNameDomain.containsKey(key)) topicsToUpdate.add(rec); else topicsToInsert.add(rec);
        ordemTopico++;
    }
}
if (!topicsToInsert.isEmpty()) insert topicsToInsert;
if (!topicsToUpdate.isEmpty()) update topicsToUpdate;

Integer domainCount = (Integer)Database.countQuery('SELECT count() FROM DominioCertificacao__c WHERE Certificacao__c = :certId');
Integer topicCount = (Integer)Database.countQuery('SELECT count() FROM Topico__c WHERE DominioCertificacao__c IN :domainIdByName.values()');
System.debug('Seed concluído. Certificação=' + certId + ', Domínios=' + domainCount + ', Tópicos=' + topicCount);