Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

void dumpFields(String objApi, String prefix) {
    if (!gd.containsKey(objApi)) {
        System.debug(prefix + '=OBJECT_NOT_FOUND');
        return;
    }
    Map<String, Schema.SObjectField> fmap = gd.get(objApi).getDescribe().fields.getMap();
    List<String> names = new List<String>(fmap.keySet());
    names.sort();
    System.debug(prefix + '=' + String.join(names, ','));
}

dumpFields('Questao__c', 'FIELDS_QUESTAO');
dumpFields('AlternativaQuestao__c', 'FIELDS_ALTERNATIVAQUESTAO');
dumpFields('Certificacao__c', 'FIELDS_CERTIFICACAO');
dumpFields('DominioCertificacao__c', 'FIELDS_DOMINIOCERTIFICACAO');
dumpFields('Topico__c', 'FIELDS_TOPICO');

if (gd.containsKey('Questao__c')) {
    Map<String, Schema.SObjectField> qf = gd.get('Questao__c').getDescribe().fields.getMap();
    List<String> pickInfo = new List<String>();
    List<String> fn = new List<String>(qf.keySet());
    fn.sort();
    for (String n : fn) {
        Schema.DescribeFieldResult d = qf.get(n).getDescribe();
        if (d.getType() == Schema.DisplayType.Picklist || d.getType() == Schema.DisplayType.MultiPicklist) {
            List<String> vals = new List<String>();
            for (Schema.PicklistEntry pe : d.getPicklistValues()) {
                vals.add(pe.getValue());
            }
            pickInfo.add(n + '->' + String.join(vals, '|'));
        }
    }
    System.debug('PICKLISTS_QUESTAO=' + (pickInfo.isEmpty() ? 'NONE' : String.join(pickInfo, ' ; ')));
} else {
    System.debug('PICKLISTS_QUESTAO=OBJECT_NOT_FOUND');
}
