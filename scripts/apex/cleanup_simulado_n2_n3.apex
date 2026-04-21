// Limpeza de Simulados N2 e N3 (PT e EN)

List<Certificacao__c> certs = [
    SELECT Id
    FROM Certificacao__c
    WHERE Name = 'Salesforce Data 360 Consultant'
    LIMIT 1
];

if (certs.isEmpty()) {
    System.debug('CLEANUP N2/N3 | Certificação não encontrada.');
    return;
}

Id certId = certs[0].Id;

// Buscar questões com prefixos S2P, S2E, S3P, S3E pelo campo Name (que contém o código)
List<Questao__c> questoesParaDeletar = [
    SELECT Id, Name
    FROM Questao__c
    WHERE Certificacao__c = :certId
    AND (
        Name LIKE '%S2P%' OR Name LIKE '%S2E%' 
        OR Name LIKE '%S3P%' OR Name LIKE '%S3E%'
    )
];

if (questoesParaDeletar.isEmpty()) {
    System.debug('CLEANUP N2/N3 | Nenhuma questão encontrada para deletar.');
    return;
}

// Deletar alternativas associadas (cascata automática)
List<AlternativaQuestao__c> alternativasParaDeletar = [
    SELECT Id
    FROM AlternativaQuestao__c
    WHERE Questao__c IN :questoesParaDeletar
];

if (!alternativasParaDeletar.isEmpty()) {
    delete alternativasParaDeletar;
}

// Deletar as questões
delete questoesParaDeletar;

System.debug('CLEANUP N2/N3 OK | Questões deletadas: ' + questoesParaDeletar.size() + ' | Alternativas: ' + alternativasParaDeletar.size());
