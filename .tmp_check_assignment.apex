Id uid = UserInfo.getUserId();
Integer c = [SELECT COUNT() FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Doni_APP_Access' AND AssigneeId = :uid];
System.debug('CURRENT_USER=' + uid);
System.debug('DONI_APP_ACCESS_ASSIGNMENTS=' + c);
