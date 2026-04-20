// Remove prefixos tipo Q005 - / WQ021 - dos enunciados legados
// e preenche Enunciado__c quando estiver vazio.

Certificacao__c cert = [
    SELECT Id
    FROM Certificacao__c
    WHERE Name = 'Salesforce Data 360 Consultant'
    LIMIT 1
];

Map<String, Schema.SObjectField> qFields = Schema.SObjectType.Questao__c.fields.getMap();
Boolean hasEnunciado = qFields.containsKey('Enunciado__c');
if (!hasEnunciado) {
    System.debug('CLEANUP PREFIX SKIPPED | Campo Enunciado__c não disponível.');
    return;
}

List<Questao__c> questoes = [
    SELECT Id, Name, Enunciado__c
    FROM Questao__c
    WHERE Certificacao__c = :cert.Id
];

List<Questao__c> toUpdate = new List<Questao__c>();
Integer changed = 0;

for (Questao__c q : questoes) {
    String fonte = String.isBlank(q.Enunciado__c) ? q.Name : q.Enunciado__c;
    if (String.isBlank(fonte)) {
        continue;
    }

    String limpo = fonte.replaceFirst('^[A-Za-z]{1,3}\\d{3}\\s*-\\s*', '');
    if (limpo != q.Enunciado__c) {
        q.Enunciado__c = limpo;
        toUpdate.add(q);
        changed++;
    }
}

if (!toUpdate.isEmpty()) {
    update toUpdate;
}

System.debug('CLEANUP PREFIX OK | Questões atualizadas: ' + changed);
