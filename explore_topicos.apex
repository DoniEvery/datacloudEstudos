List<Topico__c> topicos = [SELECT Id, Name FROM Topico__c LIMIT 1];
System.debug('Total de Topicos: ' + [SELECT COUNT() FROM Topico__c]);
for (Topico__c t : topicos) {
    System.debug('Topico: ' + t);
}
