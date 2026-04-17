Id targetId = [SELECT Id FROM Topico__c WHERE Name = 'Identity Resolution - VISIVEL' ORDER BY CreatedDate DESC LIMIT 1].Id;
List<Topico__c> outros = [SELECT Id, Name FROM Topico__c WHERE Id != :targetId ORDER BY Name];
Database.DeleteResult[] dr = Database.delete(outros, false);
Integer ok = 0;
Integer fail = 0;
for (Integer i = 0; i < dr.size(); i++) {
    if (dr[i].isSuccess()) {
        ok++;
    } else {
        fail++;
        for (Database.Error e : dr[i].getErrors()) {
            System.debug('DEL_TOPICO_ERRO|ID=' + outros[i].Id + '|NAME=' + outros[i].Name + '|STATUS=' + e.getStatusCode() + '|MSG=' + e.getMessage());
        }
    }
}
System.debug('DEL_TOPICO_OK=' + ok);
System.debug('DEL_TOPICO_FAIL=' + fail);
System.debug('TOPICOS_RESTANTES=' + [SELECT COUNT() FROM Topico__c]);
