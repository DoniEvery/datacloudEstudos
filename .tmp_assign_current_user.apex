Id userId = '005fj00000E7NB7AAN';
Id psId = [SELECT Id FROM PermissionSet WHERE Name = 'Doni_APP_Access' LIMIT 1].Id;
Integer existing = [SELECT Count() FROM PermissionSetAssignment WHERE AssigneeId = :userId AND PermissionSetId = :psId];
if (existing == 0) {
    insert new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = psId);
    System.debug('ASSIGNMENT_CREATED');
} else {
    System.debug('ASSIGNMENT_ALREADY_EXISTS');
}
