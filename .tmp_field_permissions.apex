List<String> fieldApis = new List<String>{
    'ExplicacaoAlternativa__c',
    'Ativa__c',
    'AlternativaCorreta__c'
};

List<PermissionSet> targets = [
    SELECT Id, Name, IsOwnedByProfile, Profile.Name
    FROM PermissionSet
    WHERE (IsOwnedByProfile = true AND Profile.Name = 'System Administrator')
       OR Name = 'Doni_APP_Access'
];

Set<Id> targetIds = new Set<Id>();
for (PermissionSet ps : targets) targetIds.add(ps.Id);

Set<String> fullFields = new Set<String>();
for (String f : fieldApis) fullFields.add('AlternativaQuestao__c.' + f);

Map<String, FieldPermissions> existingByKey = new Map<String, FieldPermissions>();
if (!targetIds.isEmpty()) {
    for (FieldPermissions fp : [
        SELECT Id, ParentId, Field, PermissionsRead, PermissionsEdit
        FROM FieldPermissions
        WHERE SObjectType = 'AlternativaQuestao__c'
          AND ParentId IN :targetIds
          AND Field IN :fullFields
    ]) {
        existingByKey.put(String.valueOf(fp.ParentId) + '|' + fp.Field, fp);
    }
}

List<FieldPermissions> toInsert = new List<FieldPermissions>();
List<FieldPermissions> toUpdate = new List<FieldPermissions>();

for (PermissionSet ps : targets) {
    for (String f : fieldApis) {
        String full = 'AlternativaQuestao__c.' + f;
        String key = String.valueOf(ps.Id) + '|' + full;
        if (existingByKey.containsKey(key)) {
            FieldPermissions fp = existingByKey.get(key);
            fp.PermissionsRead = true;
            fp.PermissionsEdit = true;
            toUpdate.add(fp);
        } else {
            toInsert.add(new FieldPermissions(
                ParentId = ps.Id,
                SObjectType = 'AlternativaQuestao__c',
                Field = full,
                PermissionsRead = true,
                PermissionsEdit = true
            ));
        }
    }
}

if (!toInsert.isEmpty()) insert toInsert;
if (!toUpdate.isEmpty()) update toUpdate;

List<String> targetNames = new List<String>();
for (PermissionSet ps : targets) {
    targetNames.add(ps.Name + (ps.IsOwnedByProfile ? ' (Profile=' + ps.Profile.Name + ')' : ''));
}

System.debug('FIELD_PERMISSIONS_SUMMARY targets=' + targetNames + ' inserted=' + toInsert.size() + ' updated=' + toUpdate.size());
