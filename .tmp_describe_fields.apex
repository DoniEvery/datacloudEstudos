Map<String,Schema.SObjectField> f = Schema.SObjectType.AlternativaQuestao__c.fields.getMap();
List<String> names = new List<String>(f.keySet());
names.sort();
System.debug(JSON.serialize(names));
