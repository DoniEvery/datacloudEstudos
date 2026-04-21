// Limpeza de Certificação "Data Cloud"

List<Certificacao__c> certsParaDeletar = [
    SELECT Id, Name
    FROM Certificacao__c
    WHERE Name LIKE '%data%cloud%' OR Name LIKE '%Data%Cloud%'
];

if (certsParaDeletar.isEmpty()) {
    System.debug('CLEANUP CERT | Nenhuma certificação "Data Cloud" encontrada.');
    return;
}

Id certId = certsParaDeletar[0].Id;

// Buscar todas as questões da certificação
List<Questao__c> questoesParaDeletar = [
    SELECT Id
    FROM Questao__c
    WHERE Certificacao__c = :certId
];

System.debug('CLEANUP CERT | Questões encontradas: ' + questoesParaDeletar.size());

// Deletar registros de progresso do usuário associados
if (!questoesParaDeletar.isEmpty()) {
    // Deletar tentativas de questão primeiro
    List<TentativaQuestao__c> tentativasParaDeletar = [
        SELECT Id
        FROM TentativaQuestao__c
        WHERE Questao__c IN :questoesParaDeletar
    ];
    
    if (!tentativasParaDeletar.isEmpty()) {
        delete tentativasParaDeletar;
        System.debug('CLEANUP CERT | Tentativas deletadas: ' + tentativasParaDeletar.size());
    }
    
    // Depois deletar progressos
    List<ProgressoQuestaoUsuario__c> progressosParaDeletar = [
        SELECT Id
        FROM ProgressoQuestaoUsuario__c
        WHERE Questao__c IN :questoesParaDeletar
    ];
    
    if (!progressosParaDeletar.isEmpty()) {
        delete progressosParaDeletar;
        System.debug('CLEANUP CERT | Progressos deletados: ' + progressosParaDeletar.size());
    }
}

// Deletar alternativas
if (!questoesParaDeletar.isEmpty()) {
    List<AlternativaQuestao__c> alternativasParaDeletar = [
        SELECT Id
        FROM AlternativaQuestao__c
        WHERE Questao__c IN :questoesParaDeletar
    ];
    
    if (!alternativasParaDeletar.isEmpty()) {
        delete alternativasParaDeletar;
        System.debug('CLEANUP CERT | Alternativas deletadas: ' + alternativasParaDeletar.size());
    }
    
    // Deletar questões
    delete questoesParaDeletar;
}

// Buscar domínios da certificação para deletar
List<DominioCertificacao__c> dominiosParaDeletar = [
    SELECT Id
    FROM DominioCertificacao__c
    WHERE Certificacao__c = :certId
];

if (!dominiosParaDeletar.isEmpty()) {
    // Deletar tópicos dos domínios
    List<Topico__c> topicosParaDeletar = [
        SELECT Id
        FROM Topico__c
        WHERE DominioCertificacao__c IN :dominiosParaDeletar
    ];
    
    if (!topicosParaDeletar.isEmpty()) {
        delete topicosParaDeletar;
        System.debug('CLEANUP CERT | Tópicos deletados: ' + topicosParaDeletar.size());
    }
    
    // Deletar domínios
    delete dominiosParaDeletar;
    System.debug('CLEANUP CERT | Domínios deletados: ' + dominiosParaDeletar.size());
}

// Deletar a certificação
delete certsParaDeletar;

System.debug('CLEANUP CERT OK | Certificação "' + certsParaDeletar[0].Name + '" deletada com sucesso.');
