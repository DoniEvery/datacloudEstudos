// Melhora explicações das questões WK028..WK032 com parágrafos completos
Set<String> codigos = new Set<String>{ 'WK028', 'WK029', 'WK030', 'WK031', 'WK032' };

Map<Id, String> codigoPorQuestaoId = new Map<Id, String>();
for (Questao__c q : [
    SELECT Id, CodigoQuestao__c
    FROM Questao__c
    WHERE CodigoQuestao__c IN :codigos
]) {
    codigoPorQuestaoId.put(q.Id, q.CodigoQuestao__c);
}

if (codigoPorQuestaoId.isEmpty()) {
    System.debug('ENHANCE EXPLICAÇÕES | Nenhuma questão WK028..WK032 encontrada.');
    return;
}

Map<String, String> explicacaoCorretaPorCodigo = new Map<String, String>{
    'WK028' => 'No Salesforce CRM Connector, o fluxo correto é Data Stream → DLO → DMO. O Data Stream define de onde e como os dados serão ingeridos; em seguida, os registros chegam primeiro ao DLO (Data Lake Object), que é a camada bruta de armazenamento no Data Cloud; por fim, o mapeamento DLO → DMO harmoniza os campos para o Customer 360 Data Model, permitindo uso consistente em segmentação, insights e ativações.',
    'WK029' => 'Para Amazon S3, a ordem correta inclui uma etapa anterior: Conexão S3 → Data Stream → DLO → DMO. A conexão autentica e autoriza acesso ao bucket/arquivo; o Data Stream define o esquema e a ingestão; os dados entram no DLO em formato bruto; e só depois ocorre o mapeamento para DMO, que transforma os dados para entidades padronizadas do Customer 360, como Individual e Contact Point Email.',
    'WK030' => 'DLO (Data Lake Object) é a representação bruta dos dados ingeridos de uma fonte, preservando estrutura de origem antes da harmonização. Em termos práticos, ele é a "camada de aterrissagem" do pipeline: primeiro os dados chegam ao DLO, depois são mapeados para DMO. Portanto, DLO não é o modelo final de negócio, mas sim a base técnica para transformação e qualidade de dados no Data Cloud.',
    'WK031' => 'O mapeamento para o Customer 360 Data Model ocorre após a criação do Data Stream e após a geração do DLO. Isso acontece porque o DLO precisa existir com os campos de origem para que o administrador consiga mapear corretamente cada atributo para o DMO apropriado. Em resumo: ingestão primeiro (DLO), harmonização depois (DMO).',
    'WK032' => 'A diferença principal é de papel no pipeline: DLO armazena dados brutos da fonte (camada técnica de ingestão), enquanto DMO representa entidades harmonizadas e padronizadas do Customer 360 Data Model (camada de negócio). O DLO mantém proximidade com a origem; o DMO organiza os dados para análise, segmentação, unificação e ativação com semântica consistente entre fontes.'
};

Map<String, String> explicacaoIncorretaPorCodigo = new Map<String, String>{
    'WK028' => 'Esta alternativa está incorreta porque inverte a sequência operacional do Data Cloud. DMO não é criado antes da ingestão de dados; o primeiro passo é configurar o Data Stream, depois receber os dados no DLO e só então mapear para DMO. Sem essa ordem, você perde a etapa de aterrissagem dos dados brutos e compromete o mapeamento.',
    'WK029' => 'Esta alternativa está incorreta porque quebra a ordem de preparação da fonte externa. Em cenários S3, a conexão deve ser estabelecida antes do Data Stream para garantir acesso ao bucket e aos arquivos. Depois disso, os dados entram no DLO e apenas então são harmonizados no DMO. Trocar essa ordem gera configuração incompleta ou mapeamento inválido.',
    'WK030' => 'Esta alternativa está incorreta porque descreve outro componente do ecossistema, não o DLO. O Data Lake Object é a camada de dados brutos ingeridos; ele não é o modelo final (DMO), nem um conector, nem uma visualização de relatório. O papel do DLO é servir de base para o mapeamento e harmonização posteriores.',
    'WK031' => 'Esta alternativa está incorreta porque o mapeamento DLO → DMO depende da existência prévia dos dados/estrutura no DLO. O Data Stream vem antes para definir ingestão, e só depois você harmoniza no Customer 360 Data Model. Identity Resolution também não substitui esse mapeamento; ela atua depois, sobre dados já modelados.',
    'WK032' => 'Esta alternativa está incorreta porque confunde as camadas do Data Cloud. DLO e DMO não são sinônimos: DLO é ingestão bruta e DMO é modelagem harmonizada. Inverter esses papéis leva a decisões erradas de arquitetura, principalmente em governança, unificação e ativação de dados.'
};

List<AlternativaQuestao__c> updates = new List<AlternativaQuestao__c>();
for (AlternativaQuestao__c alt : [
    SELECT Id, Questao__c, Correta__c
    FROM AlternativaQuestao__c
    WHERE Questao__c IN :codigoPorQuestaoId.keySet()
    ORDER BY Questao__c, OrdemExibicao__c ASC
]) {
    String codigo = codigoPorQuestaoId.get(alt.Questao__c);
    if (String.isBlank(codigo)) continue;

    if (alt.Correta__c == true) {
        alt.ExplicacaoAlternativa__c = explicacaoCorretaPorCodigo.get(codigo);
    } else {
        alt.ExplicacaoAlternativa__c = explicacaoIncorretaPorCodigo.get(codigo);
    }
    updates.add(alt);
}

if (!updates.isEmpty()) {
    update updates;
}

System.debug('ENHANCE EXPLICAÇÕES OK | Alternativas atualizadas: ' + updates.size());
