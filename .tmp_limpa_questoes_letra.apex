List<Questao__c> candidatos = [SELECT Id, Name FROM Questao__c WHERE Name != null];
List<Questao__c> paraExcluir = new List<Questao__c>();
Pattern p = Pattern.compile('^[A-Za-z]$');
for (Questao__c q : candidatos) {
    String n = q.Name != null ? q.Name.trim() : null;
    if (n != null && p.matcher(n).matches()) {
        paraExcluir.add(new Questao__c(Id = q.Id));
    }
}
Integer excluidas = 0;
if (!paraExcluir.isEmpty()) {
    Database.DeleteResult[] dr = Database.delete(paraExcluir, false);
    for (Database.DeleteResult r : dr) {
        if (r.isSuccess()) excluidas++;
    }
}
System.debug('QUESTOES_LETRA_ENCONTRADAS=' + paraExcluir.size());
System.debug('QUESTOES_LETRA_EXCLUIDAS=' + excluidas);
