// Seed de 60 questões exclusivas para modo SIMULADO
// Requisitos: TipoQuestao__c = 'Simulado', diferentes do estudo livre

List<Certificacao__c> certs = [
    SELECT Id, Name
    FROM Certificacao__c
    WHERE Name = 'Salesforce Data 360 Consultant'
    LIMIT 1
];
if (certs.isEmpty()) {
    System.debug('SIMULADO SEED | Certificação não encontrada.');
    return;
}
Id certId = certs[0].Id;

List<Topico__c> topicos = [
    SELECT Id, Name, DominioCertificacao__c, DominioCertificacao__r.Name
    FROM Topico__c
    WHERE DominioCertificacao__r.Certificacao__c = :certId
    ORDER BY CreatedDate ASC
];
if (topicos.isEmpty()) {
    System.debug('SIMULADO SEED | Nenhum tópico encontrado para a certificação.');
    return;
}

Map<String, Schema.SObjectField> qFields = Schema.SObjectType.Questao__c.fields.getMap();
Boolean hasEnunciado = qFields.containsKey('Enunciado__c');
Boolean hasSubtopico = qFields.containsKey('Subtopico__c');
Boolean hasCodigoInterno = qFields.containsKey('CodigoInterno__c');
Boolean hasCodigoQuestao = qFields.containsKey('CodigoQuestao__c');
Boolean hasColecaoSimulado = qFields.containsKey('ColecaoSimulado__c');
Boolean hasNivelSimulado = qFields.containsKey('NivelSimulado__c');
Boolean hasOrigemSimulado = qFields.containsKey('OrigemSimulado__c');

String colecaoSimulado = 'Fundamentos Data Cloud';
Integer nivelSimulado = 1;
String origemSimulado = 'Original';

List<String> qLoadFields = new List<String>{ 'Id', 'Name', 'TipoQuestao__c' };
if (hasCodigoInterno) qLoadFields.add('CodigoInterno__c');
if (hasCodigoQuestao) qLoadFields.add('CodigoQuestao__c');
if (hasEnunciado) qLoadFields.add('Enunciado__c');
if (hasColecaoSimulado) qLoadFields.add('ColecaoSimulado__c');
if (hasNivelSimulado) qLoadFields.add('NivelSimulado__c');
if (hasOrigemSimulado) qLoadFields.add('OrigemSimulado__c');

Map<String, Questao__c> qByCode = new Map<String, Questao__c>();
String qLoadSoql = 'SELECT ' + String.join(qLoadFields, ', ')
    + ' FROM Questao__c WHERE Certificacao__c = :certId';
for (SObject sob : Database.query(qLoadSoql)) {
    Questao__c q = (Questao__c) sob;
    String c1 = hasCodigoQuestao ? (String) q.get('CodigoQuestao__c') : null;
    String c2 = hasCodigoInterno ? (String) q.get('CodigoInterno__c') : null;
    if (!String.isBlank(c1) && c1.startsWith('SM')) qByCode.put(c1, q);
    if (!String.isBlank(c2) && c2.startsWith('SM')) qByCode.put(c2, q);
}

List<Map<String, String>> conceitos = new List<Map<String, String>>{
    new Map<String, String>{ 'termo' => 'Data Stream', 'def' => 'configuração que define origem, schema e frequência de ingestão', 'papel' => 'iniciar a entrada de dados no pipeline' },
    new Map<String, String>{ 'termo' => 'Data Lake Object (DLO)', 'def' => 'camada de dados brutos ingeridos da fonte', 'papel' => 'receber dados antes da harmonização' },
    new Map<String, String>{ 'termo' => 'Data Model Object (DMO)', 'def' => 'objeto harmonizado no Customer 360 Data Model', 'papel' => 'padronizar dados para uso analítico e ativação' },
    new Map<String, String>{ 'termo' => 'Identity Resolution', 'def' => 'processo que unifica perfis de múltiplas fontes', 'papel' => 'criar visão única de cliente' },
    new Map<String, String>{ 'termo' => 'Calculated Insight', 'def' => 'métrica agregada calculada sobre dados modelados', 'papel' => 'gerar indicadores de negócio reutilizáveis' },
    new Map<String, String>{ 'termo' => 'Segment', 'def' => 'grupo dinâmico de perfis com critérios definidos', 'papel' => 'ativar audiências para campanhas e jornadas' },
    new Map<String, String>{ 'termo' => 'Activation', 'def' => 'publicação de segmentos para destinos externos', 'papel' => 'levar audiência para canais de execução' },
    new Map<String, String>{ 'termo' => 'CRM Connector', 'def' => 'conector nativo para ingestão de dados do Salesforce CRM', 'papel' => 'extrair objetos CRM sem integração customizada' },
    new Map<String, String>{ 'termo' => 'Amazon S3 Connector', 'def' => 'conexão para ingestão de arquivos em buckets S3', 'papel' => 'trazer dados externos baseados em arquivo' },
    new Map<String, String>{ 'termo' => 'Data Cloud Related List', 'def' => 'componente para exibir dados do Data Cloud no CRM', 'papel' => 'dar contexto de dados unificados em tela operacional' },
    new Map<String, String>{ 'termo' => 'Data Cloud Object em Flow', 'def' => 'fonte de dados de DMOs em elementos de Flow', 'papel' => 'usar dados modelados em automação' },
    new Map<String, String>{ 'termo' => 'SOQL com __dlm', 'def' => 'sintaxe para consultar DMOs do Data Cloud', 'papel' => 'analisar dados harmonizados por query' },
    new Map<String, String>{ 'termo' => 'Harmonização', 'def' => 'mapeamento de campos da origem para modelo padronizado', 'papel' => 'alinhar semântica entre fontes distintas' },
    new Map<String, String>{ 'termo' => 'Governança de dados', 'def' => 'conjunto de regras de qualidade, acesso e conformidade', 'papel' => 'assegurar confiança e uso responsável dos dados' },
    new Map<String, String>{ 'termo' => 'Consentimento', 'def' => 'autorização explícita para uso de dados pessoais', 'papel' => 'garantir conformidade com privacidade' },
    new Map<String, String>{ 'termo' => 'Zero-Copy', 'def' => 'acesso aos dados sem duplicação física no Data Cloud', 'papel' => 'reduzir latência e custo de movimentação' },
    new Map<String, String>{ 'termo' => 'Unificação de perfis', 'def' => 'combinação de registros para formar perfil único', 'papel' => 'evitar visão fragmentada do cliente' },
    new Map<String, String>{ 'termo' => 'Contact Point Email', 'def' => 'representação padronizada de e-mail no modelo', 'papel' => 'consolidar canal de contato para ativação' },
    new Map<String, String>{ 'termo' => 'Contact Point Phone', 'def' => 'representação padronizada de telefone no modelo', 'papel' => 'habilitar comunicação consistente por voz/SMS' },
    new Map<String, String>{ 'termo' => 'Individual', 'def' => 'entidade central de pessoa no Customer 360 model', 'papel' => 'ser pivô de relacionamento entre dados de contato e comportamento' }
};

List<String> antiPadroes = new List<String>{
    'Executar ativação sem validar consentimento e governança previamente',
    'Trocar mapeamento sem revisão de impacto em DMO e consumidores downstream',
    'Priorizar velocidade e adiar qualidade de dados para depois do go-live',
    'Assumir que Identity Resolution substitui harmonização e modelagem',
    'Publicar segmento sem critérios de inclusão e exclusão testados',
    'Alterar schema em produção sem plano de rollback e observabilidade',
    'Projetar integração sem contrato semântico entre origem e destino',
    'Ignorar rastreabilidade de mudanças em ambiente enterprise'
};

List<Questao__c> qIns = new List<Questao__c>();
List<Questao__c> qUpd = new List<Questao__c>();
List<Map<String, Object>> planoQuestoes = new List<Map<String, Object>>();

for (Integer i = 0; i < 60; i++) {
    Integer numero = i + 1;
    String sufixo = String.valueOf(numero).leftPad(3, '0');
    String code = 'SM' + sufixo;

    Map<String, String> conceito = conceitos[Math.mod(i, conceitos.size())];
    String termo = conceito.get('termo');
    String definicao = conceito.get('def');
    String papel = conceito.get('papel');

    Integer variacao = Math.mod(i, 3);
    String enunciado;
    if (variacao == 0) {
        enunciado = 'No contexto do Data Cloud, qual alternativa define corretamente o termo ' + termo + '?';
    } else if (variacao == 1) {
        enunciado = 'Qual é o papel principal de ' + termo + ' em uma arquitetura de dados para Customer 360?';
    } else {
        enunciado = 'Em um cenário prático de implantação, quando ' + termo + ' é bem configurado, qual benefício direto é esperado?';
    }

    String altCorreta;
    if (variacao == 0) {
        altCorreta = definicao;
    } else if (variacao == 1) {
        altCorreta = papel;
    } else {
        altCorreta = 'Melhor consistência e uso confiável dos dados para decisão e ativação';
    }

    if (!String.isBlank(altCorreta) && altCorreta.length() > 0) {
        altCorreta = altCorreta.substring(0, 1).toUpperCase() + altCorreta.substring(1);
    }

    Map<String, String> conceitoA = conceitos[Math.mod(i + 5, conceitos.size())];
    Map<String, String> conceitoB = conceitos[Math.mod(i + 11, conceitos.size())];

    String alt2 = conceitoA.get('def');
    if (!String.isBlank(alt2) && alt2.length() > 0) {
        alt2 = alt2.substring(0, 1).toUpperCase() + alt2.substring(1);
    }

    String alt3 = 'Aplicar o papel de ' + conceitoB.get('termo') + ' para resolver este caso: ' + conceitoB.get('papel');
    if (!String.isBlank(alt3) && alt3.length() > 0) {
        alt3 = alt3.substring(0, 1).toUpperCase() + alt3.substring(1);
    }

    String alt4 = antiPadroes[Math.mod(i, antiPadroes.size())];
    if (!String.isBlank(alt4) && alt4.length() > 0) {
        alt4 = alt4.substring(0, 1).toUpperCase() + alt4.substring(1);
    }

    String explicacaoCorreta = termo + ' é um conceito fundamental do Data Cloud porque representa ' + definicao + '. Em termos operacionais, seu papel é ' + papel + ', conectando a camada técnica de dados com objetivos de negócio como segmentação, personalização e ativação. Por isso, quando esse elemento está corretamente configurado, o ecossistema passa a entregar decisões mais consistentes e experiências mais relevantes para o cliente.';

    String explicacaoIncorreta = 'Esta alternativa está incorreta porque contradiz o papel de ' + termo + ' dentro do Data Cloud. Esse termo não elimina etapas essenciais como governança, modelagem ou mapeamento; na prática, ele complementa o pipeline de dados para aumentar qualidade, consistência e capacidade de ativação. A compreensão correta do conceito é indispensável para projetar uma arquitetura escalável e confiável.';

    Topico__c top = topicos[Math.mod(i, topicos.size())];
    String nomeQuestao = 'Simulado - ' + code;

    Questao__c existing = qByCode.get(code);
    if (existing == null) {
        Questao__c q = new Questao__c(
            Name = nomeQuestao,
            Certificacao__c = certId,
            DominioPrincipal__c = top.DominioCertificacao__c,
            TopicoPrincipal__c = top.Id,
            TipoQuestao__c = 'Simulado',
            NivelDificuldade__c = 'Media'
        );
        if (hasEnunciado) q.put('Enunciado__c', enunciado);
        if (hasSubtopico) q.put('Subtopico__c', 'Simulado Oficial');
        if (hasCodigoInterno) q.put('CodigoInterno__c', code);
        if (hasCodigoQuestao) q.put('CodigoQuestao__c', code);
        if (hasColecaoSimulado) q.put('ColecaoSimulado__c', colecaoSimulado);
        if (hasNivelSimulado) q.put('NivelSimulado__c', nivelSimulado);
        if (hasOrigemSimulado) q.put('OrigemSimulado__c', origemSimulado);
        qIns.add(q);
    } else {
        Boolean changed = false;
        if (existing.Name != nomeQuestao) {
            existing.Name = nomeQuestao;
            changed = true;
        }
        if (existing.TipoQuestao__c != 'Simulado') {
            existing.TipoQuestao__c = 'Simulado';
            changed = true;
        }
        if (hasEnunciado) {
            existing.put('Enunciado__c', enunciado);
            changed = true;
        }
        if (hasSubtopico) {
            existing.put('Subtopico__c', 'Simulado Oficial');
            changed = true;
        }
        if (hasCodigoInterno && (String) existing.get('CodigoInterno__c') != code) {
            existing.put('CodigoInterno__c', code);
            changed = true;
        }
        if (hasCodigoQuestao && (String) existing.get('CodigoQuestao__c') != code) {
            existing.put('CodigoQuestao__c', code);
            changed = true;
        }
        if (hasColecaoSimulado && (String) existing.get('ColecaoSimulado__c') != colecaoSimulado) {
            existing.put('ColecaoSimulado__c', colecaoSimulado);
            changed = true;
        }
        if (hasNivelSimulado && existing.get('NivelSimulado__c') != nivelSimulado) {
            existing.put('NivelSimulado__c', nivelSimulado);
            changed = true;
        }
        if (hasOrigemSimulado && (String) existing.get('OrigemSimulado__c') != origemSimulado) {
            existing.put('OrigemSimulado__c', origemSimulado);
            changed = true;
        }
        if (changed) qUpd.add(existing);
    }

    Integer corretaPos = Math.mod(i, 4) + 1;
    List<String> distratores = new List<String>{ alt2, alt3, alt4 };

    List<String> op = new List<String>();
    List<Boolean> ok = new List<Boolean>();
    List<String> ex = new List<String>();
    Integer idxDistrator = 0;
    for (Integer p = 1; p <= 4; p++) {
        if (p == corretaPos) {
            op.add(altCorreta);
            ok.add(true);
            ex.add(explicacaoCorreta);
        } else {
            op.add(distratores[idxDistrator]);
            ok.add(false);
            ex.add(explicacaoIncorreta);
            idxDistrator++;
        }
    }

    planoQuestoes.add(new Map<String, Object>{
        'codigo' => code,
        'enunciado' => enunciado,
        'o1' => op[0],
        'o2' => op[1],
        'o3' => op[2],
        'o4' => op[3],
        'k1' => ok[0],
        'k2' => ok[1],
        'k3' => ok[2],
        'k4' => ok[3],
        'e1' => ex[0],
        'e2' => ex[1],
        'e3' => ex[2],
        'e4' => ex[3]
    });
}

if (!qIns.isEmpty()) insert qIns;
if (!qUpd.isEmpty()) update qUpd;

qByCode.clear();
for (SObject sob : Database.query(qLoadSoql)) {
    Questao__c q = (Questao__c) sob;
    String c1 = hasCodigoQuestao ? (String) q.get('CodigoQuestao__c') : null;
    String c2 = hasCodigoInterno ? (String) q.get('CodigoInterno__c') : null;
    if (!String.isBlank(c1) && c1.startsWith('SM')) qByCode.put(c1, q);
    if (!String.isBlank(c2) && c2.startsWith('SM')) qByCode.put(c2, q);
}

Set<Id> simuladoIds = new Set<Id>();
for (Map<String, Object> p : planoQuestoes) {
    String code = (String) p.get('codigo');
    if (qByCode.containsKey(code)) {
        simuladoIds.add(qByCode.get(code).Id);
    }
}

List<AlternativaQuestao__c> altOld = [
    SELECT Id
    FROM AlternativaQuestao__c
    WHERE Questao__c IN :simuladoIds
];
if (!altOld.isEmpty()) delete altOld;

List<AlternativaQuestao__c> altIns = new List<AlternativaQuestao__c>();
for (Map<String, Object> p : planoQuestoes) {
    String code = (String) p.get('codigo');
    if (!qByCode.containsKey(code)) continue;

    Id qId = qByCode.get(code).Id;

    altIns.add(new AlternativaQuestao__c(
        Questao__c = qId,
        OrdemExibicao__c = 1,
        Name = String.valueOf(p.get('o1')).left(80),
        Correta__c = (Boolean) p.get('k1'),
        Ativa__c = true,
        ExplicacaoAlternativa__c = String.valueOf(p.get('e1'))
    ));
    altIns.add(new AlternativaQuestao__c(
        Questao__c = qId,
        OrdemExibicao__c = 2,
        Name = String.valueOf(p.get('o2')).left(80),
        Correta__c = (Boolean) p.get('k2'),
        Ativa__c = true,
        ExplicacaoAlternativa__c = String.valueOf(p.get('e2'))
    ));
    altIns.add(new AlternativaQuestao__c(
        Questao__c = qId,
        OrdemExibicao__c = 3,
        Name = String.valueOf(p.get('o3')).left(80),
        Correta__c = (Boolean) p.get('k3'),
        Ativa__c = true,
        ExplicacaoAlternativa__c = String.valueOf(p.get('e3'))
    ));
    altIns.add(new AlternativaQuestao__c(
        Questao__c = qId,
        OrdemExibicao__c = 4,
        Name = String.valueOf(p.get('o4')).left(80),
        Correta__c = (Boolean) p.get('k4'),
        Ativa__c = true,
        ExplicacaoAlternativa__c = String.valueOf(p.get('e4'))
    ));
}

if (!altIns.isEmpty()) insert altIns;

System.debug('SIMULADO SEED OK | Questões inseridas: ' + qIns.size() + ' | Questões atualizadas: ' + qUpd.size() + ' | Alternativas: ' + altIns.size());
