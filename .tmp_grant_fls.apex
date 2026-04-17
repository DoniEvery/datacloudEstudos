List<FieldPermissions> existing = [SELECT Id FROM FieldPermissions WHERE SobjectType = 'AlternativaQuestao__c' AND Field = 'AlternativaQuestao__c.Correta__c' AND ParentId IN (SELECT Id FROM PermissionSet WHERE IsOwnedByProfile = true AND Profile.Name = 'System Administrator')];
System.debug('EXISTING_FLS=' + existing.size());
if (existing.isEmpty()) {
    PermissionSet ps = [SELECT Id FROM PermissionSet WHERE IsOwnedByProfile = true AND Profile.Name = 'System Administrator' LIMIT 1];
    FieldPermissions fp = new FieldPermissions(SobjectType = 'AlternativaQuestao__c', Field = 'AlternativaQuestao__c.Correta__c', ParentId = ps.Id, PermissionsRead = true, PermissionsEdit = true);
    insert fp;
    System.debug('FLS_GRANTED=OK');
} else {
    System.debug('FLS_ALREADY_GRANTED');
}
