Map<String,Schema.SObjectField> p = Schema.SObjectType.ProgressoQuestaoUsuario__c.fields.getMap();
List<String> pf = new List<String>(p.keySet()); pf.sort();
System.debug('PROGRESSO=' + JSON.serialize(pf));

try {
    Map<String,Schema.SObjectField> t = Schema.SObjectType.TentativaQuestao__c.fields.getMap();
    List<String> tf = new List<String>(t.keySet()); tf.sort();
    System.debug('TENTATIVA=' + JSON.serialize(tf));
} catch(Exception e) {
    System.debug('TENTATIVA_ERROR=' + e.getMessage());
}
