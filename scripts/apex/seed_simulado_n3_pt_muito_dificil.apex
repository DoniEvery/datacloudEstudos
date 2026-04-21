// Simulado Nível 3 (Muito Difícil) - Português
// Coleção: Arquitetura Avançada - PT
// Origem: Oficial (Cenários Complexos)

List<Certificacao__c> certs = [
    SELECT Id, Name
    FROM Certificacao__c
    WHERE Name = 'Salesforce Data 360 Consultant'
    LIMIT 1
];
if (certs.isEmpty()) {
    System.debug('SIM N3 PT | Certificação não encontrada.');
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
    System.debug('SIM N3 PT | Nenhum tópico encontrado.');
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

String colecao = 'Arquitetura Avançada - PT';
Integer nivel = 3;
String origem = 'Oficial (Cenários Complexos)';

List<String> cenarios = new List<String>{
    'migração em ondas com múltiplas fontes e janela restrita de cutover',
    'ativação em tempo quase real com consentimento multicanal variável',
    'reconciliação de identidades com regras conflitantes entre regiões',
    'modelo de dados global com exigências locais de privacidade',
    'go-live com baixa tolerância a latência e alta auditabilidade',
    'fusão de negócios com sobreposição de catálogos e canais',
    'programa de fidelidade omnicanal com forte dependência de segmentação',
    'governança federada entre times de marketing, service e dados'
};

List<String> focos = new List<String>{
    'priorização de decisões arquiteturais sob risco regulatório',
    'desenho de qualidade de dados com critérios mensuráveis de aprovação',
    'sequenciamento entre ingestão, harmonização, unificação e ativação',
    'trade-off entre custo operacional e robustez de governança',
    'estratégia de rollback sem perda de rastreabilidade',
    'observabilidade ponta a ponta para troubleshooting preditivo',
    'isolamento de impacto em mudanças de schema e mapeamento',
    'consistência semântica entre DLO, DMO e consumidores downstream'
};

List<String> errosEstruturais = new List<String>{
    'Concentrar todas as validações no final para acelerar cronograma',
    'Priorizar apenas throughput de ingestão e adiar decisões de identidade',
    'Executar mudanças simultâneas sem feature flags e sem isolamento de impacto',
    'Padronizar regras globais sem considerar exigências locais de privacidade',
    'Aprovar ativação sem critérios de qualidade por fase',
    'Ignorar contratos semânticos entre origem, modelo e destino',
    'Operar sem telemetria para detecção precoce de regressões',
    'Conduzir cutover sem plano testado de rollback por cenário'
};

List<String> simplificacoesPerigosas = new List<String>{
    'Transferir governança para pós-go-live em nome de velocidade',
    'Assumir que reconciliação de identidade corrige defeitos de harmonização',
    'Definir sucesso apenas por prazo, sem indicadores de confiabilidade',
    'Otimizar custo imediato e aceitar dívida técnica sem mitigação',
    'Alterar schema sem estratégia de compatibilidade regressiva',
    'Escalar integração sem matriz de risco por domínio',
    'Executar ativação sem validação de consentimento multicanal',
    'Desacoplar squads sem governança federada de decisão'
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
    if (!String.isBlank(c1) && c1.startsWith('S3P')) qByCode.put(c1, q);
    if (!String.isBlank(c2) && c2.startsWith('S3P')) qByCode.put(c2, q);
}

List<Questao__c> qIns = new List<Questao__c>();
List<Questao__c> qUpd = new List<Questao__c>();
List<Map<String, Object>> plano = new List<Map<String, Object>>();

for (Integer i = 0; i < 60; i++) {
    Integer n = i + 1;
    String code = 'S3P' + String.valueOf(n).leftPad(3, '0');

    String cenario = cenarios[Math.mod(i, cenarios.size())];
    String foco = focos[Math.mod(i, focos.size())];

    Integer variacao = Math.mod(i, 3);
    String enunciado;
    if (variacao == 0) {
        enunciado = 'Em um cenário de ' + cenario + ', qual abordagem de consultoria melhor atende ao foco de ' + foco + ' sem sacrificar governança e performance operacional?';
    } else if (variacao == 1) {
        enunciado = 'Qual decisão técnica, em um contexto de ' + cenario + ', reduz risco sistêmico e preserva capacidade de evolução contínua da arquitetura Data 360?';
    } else {
        enunciado = 'Diante de ' + cenario + ', qual alternativa representa o melhor equilíbrio entre entrega incremental, qualidade de dados e conformidade?';
    }

    String correta = 'Aplicar uma estratégia em camadas com critérios de qualidade e conformidade por fase, contratos semânticos explícitos, observabilidade ativa e plano de reversão testado por cenário.';
    String errada1 = errosEstruturais[Math.mod(i, errosEstruturais.size())] + '.';
    String errada2 = simplificacoesPerigosas[Math.mod(i + 2, simplificacoesPerigosas.size())] + '.';
    String errada3 = 'Aplicar essa decisão no cenário de ' + cenarios[Math.mod(i + 3, cenarios.size())] + ' sem reforçar ' + focos[Math.mod(i + 5, focos.size())] + '.';

    String expC = 'A resposta correta reflete maturidade de consultoria em ambientes enterprise: você reduz risco acumulado ao dividir decisões críticas em fases verificáveis, com métricas objetivas e rastreabilidade. Em Data 360, a qualidade da ativação depende da consistência de todo o pipeline — ingestão, harmonização, unificação e governança. Sem esse desenho em camadas, o custo de correção cresce rapidamente e compromete confiabilidade operacional.';
    String expE = 'Esta alternativa ignora dependências estruturais do ciclo de dados e tende a gerar dívida técnica ou regulatória. O exame em nível avançado cobra decisões que preservem governança, auditabilidade e capacidade de evolução contínua, não atalhos de execução. Em cenários complexos, simplificações excessivas normalmente transferem risco para produção e degradam confiança em análises e ativações.';

    Integer corretaPos = Math.mod(i, 4) + 1;
    List<String> distratores = new List<String>{ errada1, errada2, errada3 };

    List<String> op = new List<String>();
    List<Boolean> ok = new List<Boolean>();
    List<String> ex = new List<String>();

    Integer idx = 0;
    for (Integer p = 1; p <= 4; p++) {
        if (p == corretaPos) {
            op.add(correta);
            ok.add(true);
            ex.add(expC);
        } else {
            op.add(distratores[idx]);
            ok.add(false);
            ex.add(expE);
            idx++;
        }
    }

    Topico__c top = topicos[Math.mod(i, topicos.size())];
    String nomeQuestao = ('Simulado PT N3 - ' + code).left(80);

    Questao__c existing = qByCode.get(code);
    if (existing == null) {
        Questao__c q = new Questao__c(
            Name = nomeQuestao,
            Certificacao__c = certId,
            DominioPrincipal__c = top.DominioCertificacao__c,
            TopicoPrincipal__c = top.Id,
            TipoQuestao__c = 'Simulado',
            NivelDificuldade__c = 'MuitoDificil'
        );
        if (hasEnunciado) q.put('Enunciado__c', enunciado);
        if (hasSubtopico) q.put('Subtopico__c', 'Simulado Muito Difícil');
        if (hasCodigoInterno) q.put('CodigoInterno__c', code);
        if (hasCodigoQuestao) q.put('CodigoQuestao__c', code);
        if (hasColecao) q.put('ColecaoSimulado__c', colecao);
        if (hasNivel) q.put('NivelSimulado__c', nivel);
        if (hasOrigem) q.put('OrigemSimulado__c', origem);
        qIns.add(q);
    } else {
        existing.Name = nomeQuestao;
        existing.TipoQuestao__c = 'Simulado';
        existing.NivelDificuldade__c = 'MuitoDificil';
        if (hasEnunciado) existing.put('Enunciado__c', enunciado);
        if (hasSubtopico) existing.put('Subtopico__c', 'Simulado Muito Difícil');
        if (hasCodigoInterno) existing.put('CodigoInterno__c', code);
        if (hasCodigoQuestao) existing.put('CodigoQuestao__c', code);
        if (hasColecao) existing.put('ColecaoSimulado__c', colecao);
        if (hasNivel) existing.put('NivelSimulado__c', nivel);
        if (hasOrigem) existing.put('OrigemSimulado__c', origem);
        qUpd.add(existing);
    }

    plano.add(new Map<String, Object>{
        'code' => code,
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
    if (!String.isBlank(c1) && c1.startsWith('S3P')) qByCode.put(c1, q);
    if (!String.isBlank(c2) && c2.startsWith('S3P')) qByCode.put(c2, q);
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

System.debug('SIM N3 PT OK | Inseridas: ' + qIns.size() + ' | Atualizadas: ' + qUpd.size() + ' | Alternativas: ' + altIns.size());
