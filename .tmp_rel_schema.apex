Map<String,Schema.SObjectField> tf = Schema.SObjectType.Topico__c.fields.getMap();
List<String> t = new List<String>(tf.keySet()); t.sort();
System.debug('TOPICO=' + JSON.serialize(t));

Map<String,Schema.SObjectField> df = Schema.SObjectType.DominioCertificacao__c.fields.getMap();
List<String> d = new List<String>(df.keySet()); d.sort();
System.debug('DOMINIO=' + JSON.serialize(d));

Map<String,Schema.SObjectField> cf = Schema.SObjectType.Certificacao__c.fields.getMap();
List<String> c = new List<String>(cf.keySet()); c.sort();
System.debug('CERT=' + JSON.serialize(c));
