Id psId = [SELECT Id FROM PermissionSet WHERE Name = 'Doni_APP_Access' LIMIT 1].Id;
Set<Id> assigned = new Set<Id>();
for (PermissionSetAssignment a : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :psId]) assigned.add(a.AssigneeId);
List<PermissionSetAssignment> ins = new List<PermissionSetAssignment>();
for (User u : [SELECT Id FROM User WHERE IsActive = true]) if (!assigned.contains(u.Id)) ins.add(new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = psId));
if (!ins.isEmpty()) insert ins;
System.debug('ASSIGNED=' + ins.size());
