Id targetId = [SELECT Id FROM Topico__c WHERE Name = 'Identity Resolution - VISIVEL' ORDER BY CreatedDate DESC LIMIT 1].Id;
List<Topico__c> outros = [SELECT Id, Name FROM Topico__c WHERE Id != :targetId ORDER BY Name];
System.debug('TOPICOS_RESTANTES_EXCETO_ALVO=' + outros.size());
for (Topico__c t : outros) {
    System.debug('TOPICO_RESTANTE|ID=' + t.Id + '|NAME=' + t.Name);
}

Schema.DescribeSObjectResult d = Topico__c.SObjectType.getDescribe();
for (Schema.ChildRelationship cr : d.getChildRelationships()) {
    if (cr.getField() != null) {
        System.debug('CHILD_REL|' + cr.getChildSObject() + '|FIELD=' + cr.getField() + '|CASCADE=' + cr.isCascadeDelete());
    }
}
