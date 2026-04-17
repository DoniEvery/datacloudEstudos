List<String> fields = new List<String>();
for (Schema.SObjectField f : Schema.SObjectType.AlternativaQuestao__c.fields.getMap().values()) fields.add(f.getDescribe().getName());
fields.sort();
System.debug('FIELDS=' + String.join(fields, ', '));
