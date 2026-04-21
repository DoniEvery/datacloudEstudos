// Simulado Nível 2 (Difícil) - Português
// Coleção: Trilha Oficial Atualizada - PT
// Origem: Oficial (Trilha Atualizada)

List<Certificacao__c> certs = [
    SELECT Id, Name
    FROM Certificacao__c
    WHERE Name = 'Salesforce Data 360 Consultant'
    LIMIT 1
];
if (certs.isEmpty()) {
    System.debug('SIM N2 PT | Certificação não encontrada.');
    return;
}
Id certId = certs[0].Id;

List<Topico__c> topicos = [
    SELECT Id, Name, DominioCertificacao__c
    FROM Topico__c
    WHERE DominioCertificacao__r.Certificacao__c = :certId
    ORDER BY CreatedDate ASC
];
if (topicos.isEmpty()) {
    System.debug('SIM N2 PT | Nenhum tópico encontrado.');
    return;
}

Map<String, Schema.SObjectField> qFields = Schema.SObjectType.Questao__c.fields.getMap();
Boolean hasEnunciado = qFields.containsKey('Enunciado__c');
Boolean hasSubtopico = qFields.containsKey('Subtopico__c');
Boolean hasCodigoInterno = qFields.containsKey('CodigoInterno__c');
Boolean hasCodigoQuestao = qFields.containsKey('CodigoQuestao__c');
Boolean hasColecao = qFields.containsKey('ColecaoSimulado__c');
Boolean hasNivel = qFields.containsKey('NivelSimulado__c');
Boolean hasOrigem = qFields.containsKey('OrigemSimulado__c');

String colecao = 'Trilha Oficial Atualizada - PT';
Integer nivel = 2;
String origem = 'Oficial (Trilha Atualizada)';

List<Map<String, String>> dominios = new List<Map<String, String>>{
    new Map<String, String>{'tema' => 'Exam Overview', 'conceito' => 'peso de domínio e estratégia de prova por cenário'},
    new Map<String, String>{'tema' => 'Solution Positioning', 'conceito' => 'alinhamento entre valor de negócio e arquitetura de dados'},
    new Map<String, String>{'tema' => 'Setup and Administration', 'conceito' => 'governança, permissões e operação contínua'},
    new Map<String, String>{'tema' => 'Source Connection and Ingestion', 'conceito' => 'orquestração de conectores e qualidade na ingestão'},
    new Map<String, String>{'tema' => 'Harmonization and Unification', 'conceito' => 'mapeamento semântico e reconciliação de identidades'},
    new Map<String, String>{'tema' => 'Enhancements, Sharing and Analysis', 'conceito' => 'insights calculados e compartilhamento seguro'},
    new Map<String, String>{'tema' => 'Activations and Utilization', 'conceito' => 'ativação orientada por consentimento e mensuração'},
    new Map<String, String>{'tema' => 'Hands On Data 360', 'conceito' => 'aplicação prática end-to-end com troubleshooting'}
};

List<String> armadilhas = new List<String>{
    'Confundir DLO com DMO ao definir o ponto de harmonização',
    'Ignorar impactos de consentimento antes da ativação',
    'Assumir que Identity Resolution substitui mapeamento de dados',
    'Tratar conectividade e governança como etapas independentes',
    'Desconsiderar rastreabilidade de mudanças em produção',
    'Aplicar métricas sem validar qualidade de fonte',
    'Publicar segmento sem validar critérios de inclusão e exclusão',
    'Superestimar automação sem plano de observabilidade'
};

List<String> errosOperacionais = new List<String>{
    'Executar mudanças diretas em produção sem validação por ambiente',
    'Aplicar rollback como estratégia principal em vez de contingência',
    'Medir sucesso apenas por throughput sem indicadores de qualidade',
    'Confiar em testes manuais para fluxos críticos de ativação',
    'Ignorar impacto em consumidores downstream ao ajustar mapeamentos',
    'Promover configuração sem trilha de auditoria de decisão',
    'Desacoplar squads sem contrato semântico entre domínios',
    'Tratar incidente de dado como exceção e não como falha sistêmica'
};

List<String> atalhosArquitetura = new List<String>{
    'Concentrar esforço apenas em performance de consulta e postergar governança',
    'Priorizar entrega imediata e adiar consentimento para uma fase futura',
    'Assumir unificação automática sem revisar qualidade de fonte',
    'Padronizar mapeamento por convenção sem validação por domínio',
    'Orquestrar ativação sem critérios de inclusão e exclusão testados',
    'Ajustar schema sem análise de compatibilidade regressiva',
    'Unificar regras de identidade sem exceções regionais de privacidade',
    'Escalar conectores sem observabilidade ponta a ponta'
};

Map<String, Questao__c> qByCode = new Map<String, Questao__c>();
List<String> qLoadFields = new List<String>{ 'Id', 'Name' };
if (hasCodigoInterno) qLoadFields.add('CodigoInterno__c');
if (hasCodigoQuestao) qLoadFields.add('CodigoQuestao__c');
String qLoadSoql = 'SELECT ' + String.join(qLoadFields, ', ') + ' FROM Questao__c WHERE Certificacao__c = :certId';
for (SObject sob : Database.query(qLoadSoql)) {
    Questao__c q = (Questao__c) sob;
    String c1 = hasCodigoQuestao ? (String) q.get('CodigoQuestao__c') : null;
    String c2 = hasCodigoInterno ? (String) q.get('CodigoInterno__c') : null;
    if (!String.isBlank(c1) && c1.startsWith('S2P')) qByCode.put(c1, q);
    if (!String.isBlank(c2) && c2.startsWith('S2P')) qByCode.put(c2, q);
}

List<Questao__c> qIns = new List<Questao__c>();
List<Questao__c> qUpd = new List<Questao__c>();
List<Map<String, Object>> plano = new List<Map<String, Object>>();

for (Integer i = 0; i < 60; i++) {
    Integer n = i + 1;
    String code = 'S2P' + String.valueOf(n).leftPad(3, '0');

    Map<String, String> d = dominios[Math.mod(i, dominios.size())];
    String tema = d.get('tema');
    String conceito = d.get('conceito');
    String armadilha = armadilhas[Math.mod(i, armadilhas.size())];

    Integer variacao = Math.mod(i, 3);
    String enunciado;
    if (variacao == 0) {
        enunciado = 'Em um cenário de prova sobre ' + tema + ', qual decisão técnica melhor demonstra domínio de ' + conceito + ' sem comprometer governança?';
    } else if (variacao == 1) {
        enunciado = 'Durante uma implementação enterprise, qual abordagem minimiza risco operacional em ' + tema + ' e mantém aderência ao blueprint atualizado?';
    } else {
        enunciado = 'Qual alternativa descreve a melhor prática para ' + tema + ' quando há conflito entre velocidade de entrega e qualidade de dados?';
    }

    String correta = 'Priorizar desenho orientado a arquitetura e governança, com validação incremental, métricas de qualidade e decisão baseada em impacto de negócio.';
    String d1 = armadilha + '.';
    String d2 = errosOperacionais[Math.mod(i, errosOperacionais.size())] + '.';
    String d3 = atalhosArquitetura[Math.mod(i + 3, atalhosArquitetura.size())] + '.';

    String expC = 'A alternativa correta é a mais aderente ao perfil exigido de Data 360 Consultant porque equilibra estratégia, execução e controle. Em contextos complexos, não basta entregar rápido: é necessário preservar rastreabilidade, governança e qualidade ao longo do ciclo. Essa abordagem reduz retrabalho, melhora confiabilidade dos dados e sustenta decisões de ativação com segurança regulatória e técnica.';
    String expE = 'Esta alternativa parece prática no curto prazo, mas aumenta risco estrutural no médio e longo prazo. O exame valoriza decisões que conectam arquitetura, governança e valor de negócio, não atalhos operacionais. Ignorar esses pilares tende a gerar inconsistência de dados, baixa confiabilidade analítica e falhas de conformidade.';

    Integer corretaPos = Math.mod(i, 4) + 1;
    List<String> textos = new List<String>{ d1, d2, d3 };
    List<String> explics = new List<String>{ expE, expE, expE };

    List<String> op = new List<String>();
    List<Boolean> ok = new List<Boolean>();
    List<String> ex = new List<String>();

    Integer idxInc = 0;
    for (Integer p = 1; p <= 4; p++) {
        if (p == corretaPos) {
            op.add(correta);
            ok.add(true);
            ex.add(expC);
        } else {
            op.add(textos[idxInc]);
            ok.add(false);
            ex.add(explics[idxInc]);
            idxInc++;
        }
    }

    Topico__c top = topicos[Math.mod(i, topicos.size())];
    String nomeQuestao = ('Simulado PT N2 - ' + code).left(80);

    Questao__c existing = qByCode.get(code);
    if (existing == null) {
        Questao__c q = new Questao__c(
            Name = nomeQuestao,
            Certificacao__c = certId,
            DominioPrincipal__c = top.DominioCertificacao__c,
            TopicoPrincipal__c = top.Id,
            TipoQuestao__c = 'Simulado',
            NivelDificuldade__c = 'Dificil'
        );
        if (hasEnunciado) q.put('Enunciado__c', enunciado);
        if (hasSubtopico) q.put('Subtopico__c', 'Simulado Difícil');
        if (hasCodigoInterno) q.put('CodigoInterno__c', code);
        if (hasCodigoQuestao) q.put('CodigoQuestao__c', code);
        if (hasColecao) q.put('ColecaoSimulado__c', colecao);
        if (hasNivel) q.put('NivelSimulado__c', nivel);
        if (hasOrigem) q.put('OrigemSimulado__c', origem);
        qIns.add(q);
    } else {
        existing.Name = nomeQuestao;
        existing.TipoQuestao__c = 'Simulado';
        existing.NivelDificuldade__c = 'Dificil';
        if (hasEnunciado) existing.put('Enunciado__c', enunciado);
        if (hasSubtopico) existing.put('Subtopico__c', 'Simulado Difícil');
        if (hasCodigoInterno) existing.put('CodigoInterno__c', code);
        if (hasCodigoQuestao) existing.put('CodigoQuestao__c', code);
        if (hasColecao) existing.put('ColecaoSimulado__c', colecao);
        if (hasNivel) existing.put('NivelSimulado__c', nivel);
        if (hasOrigem) existing.put('OrigemSimulado__c', origem);
        qUpd.add(existing);
    }

    plano.add(new Map<String, Object>{
        'code' => code,
        'enunciado' => enunciado,
        'o1' => op[0], 'o2' => op[1], 'o3' => op[2], 'o4' => op[3],
        'k1' => ok[0], 'k2' => ok[1], 'k3' => ok[2], 'k4' => ok[3],
        'e1' => ex[0], 'e2' => ex[1], 'e3' => ex[2], 'e4' => ex[3]
    });
}

if (!qIns.isEmpty()) insert qIns;
if (!qUpd.isEmpty()) update qUpd;

qByCode.clear();
for (SObject sob : Database.query(qLoadSoql)) {
    Questao__c q = (Questao__c) sob;
    String c1 = hasCodigoQuestao ? (String) q.get('CodigoQuestao__c') : null;
    String c2 = hasCodigoInterno ? (String) q.get('CodigoInterno__c') : null;
    if (!String.isBlank(c1) && c1.startsWith('S2P')) qByCode.put(c1, q);
    if (!String.isBlank(c2) && c2.startsWith('S2P')) qByCode.put(c2, q);
}

Set<Id> qIds = new Set<Id>();
for (Map<String, Object> p : plano) {
    String code = (String) p.get('code');
    if (qByCode.containsKey(code)) qIds.add(qByCode.get(code).Id);
}

List<AlternativaQuestao__c> altOld = [SELECT Id FROM AlternativaQuestao__c WHERE Questao__c IN :qIds];
if (!altOld.isEmpty()) delete altOld;

List<AlternativaQuestao__c> altIns = new List<AlternativaQuestao__c>();
for (Map<String, Object> p : plano) {
    String code = (String) p.get('code');
    if (!qByCode.containsKey(code)) continue;
    Id qId = qByCode.get(code).Id;

    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 1, Name = String.valueOf(p.get('o1')).left(80), Correta__c = (Boolean) p.get('k1'), Ativa__c = true, ExplicacaoAlternativa__c = String.valueOf(p.get('e1'))));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 2, Name = String.valueOf(p.get('o2')).left(80), Correta__c = (Boolean) p.get('k2'), Ativa__c = true, ExplicacaoAlternativa__c = String.valueOf(p.get('e2'))));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 3, Name = String.valueOf(p.get('o3')).left(80), Correta__c = (Boolean) p.get('k3'), Ativa__c = true, ExplicacaoAlternativa__c = String.valueOf(p.get('e3'))));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 4, Name = String.valueOf(p.get('o4')).left(80), Correta__c = (Boolean) p.get('k4'), Ativa__c = true, ExplicacaoAlternativa__c = String.valueOf(p.get('e4'))));
}
if (!altIns.isEmpty()) insert altIns;

System.debug('SIM N2 PT OK | Inseridas: ' + qIns.size() + ' | Atualizadas: ' + qUpd.size() + ' | Alternativas: ' + altIns.size());
