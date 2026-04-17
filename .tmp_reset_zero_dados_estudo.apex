Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

List<String> objs = new List<String>{
    'TentativaAlternativa__c',
    'TentativaQuestao__c',
    'ProgressoQuestaoUsuario__c',
    'AlternativaQuestao__c',
    'Questao__c',
    'Topico__c',
    'DominioCertificacao__c',
    'Certificacao__c',
    'SessaoEstudo__c'
};

for (String objName : objs) {
    if (!gd.containsKey(objName)) {
        System.debug('SKIP_OBJ_NOT_FOUND=' + objName);
        continue;
    }

    Integer totalDeleted = 0;
    Integer totalFailed = 0;
    Integer loops = 0;

    while (true) {
        loops++;
        List<SObject> rows = Database.query('SELECT Id FROM ' + objName + ' LIMIT 10000');
        if (rows.isEmpty()) break;

        Database.DeleteResult[] dr = Database.delete(rows, false);
        for (Database.DeleteResult r : dr) {
            if (r.isSuccess()) {
                totalDeleted++;
            } else {
                totalFailed++;
            }
        }

        if (loops > 20) {
            System.debug('BREAK_SAFETY=' + objName);
            break;
        }
    }

    Integer remain = (Integer) Database.countQuery('SELECT COUNT() FROM ' + objName);
    System.debug('OBJ=' + objName + '|DELETED=' + totalDeleted + '|FAILED=' + totalFailed + '|REMAIN=' + remain);
}
