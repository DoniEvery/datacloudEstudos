PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Doni_Community_Access' LIMIT 1];

List<User> communityUsers = [
    SELECT Id
    FROM User
    WHERE UserType IN ('PowerPartner', 'PowerCustomerSuccess', 'CustomerSuccess', 'CspLitePortal')
    AND IsActive = true
];

Set<Id> alreadyAssigned = new Set<Id>();
for (PermissionSetAssignment psa : [
    SELECT AssigneeId
    FROM PermissionSetAssignment
    WHERE PermissionSetId = :ps.Id
]) {
    alreadyAssigned.add(psa.AssigneeId);
}

List<PermissionSetAssignment> toInsert = new List<PermissionSetAssignment>();
for (User u : communityUsers) {
    if (!alreadyAssigned.contains(u.Id)) {
        toInsert.add(new PermissionSetAssignment(
            AssigneeId = u.Id,
            PermissionSetId = ps.Id
        ));
    }
}

if (!toInsert.isEmpty()) {
    insert toInsert;
}

System.debug('Total community users: ' + communityUsers.size());
System.debug('Newly assigned: ' + toInsert.size());
System.debug('Already had PS: ' + alreadyAssigned.size());
