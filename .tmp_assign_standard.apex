Id psId = [SELECT Id FROM PermissionSet WHERE Name = 'Doni_APP_Access' LIMIT 1].Id;
Set<Id> assigned = new Set<Id>();
for (PermissionSetAssignment a : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :psId]) assigned.add(a.AssigneeId);
List<PermissionSetAssignment> ins = new List<PermissionSetAssignment>();
for (User u : [SELECT Id, UserType FROM User WHERE IsActive = true AND UserType = 'Standard']) {
  if (!assigned.contains(u.Id)) ins.add(new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = psId));
}
Integer ok = 0, fail = 0;
if (!ins.isEmpty()) {
  Database.SaveResult[] rs = Database.insert(ins, false);
  for (Database.SaveResult r : rs) { if (r.isSuccess()) ok++; else fail++; }
}
System.debug('PS_ASSIGN_STANDARD_OK=' + ok + ';FAIL=' + fail + ';TOTAL=' + ins.size());
