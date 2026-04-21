// Simulated Exam Level 2 (Hard) - English
// Collection: Updated Official Trail - EN
// Source: Official (Updated Trail)

List<Certificacao__c> certs = [
    SELECT Id, Name
    FROM Certificacao__c
    WHERE Name = 'Salesforce Data 360 Consultant'
    LIMIT 1
];
if (certs.isEmpty()) {
    System.debug('SIM N2 EN | Certification not found.');
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
    System.debug('SIM N2 EN | No topics found.');
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

String colecao = 'Updated Official Trail - EN';
Integer nivel = 2;
String origem = 'Official (Updated Trail)';

List<Map<String, String>> domains = new List<Map<String, String>>{
    new Map<String, String>{'theme' => 'Exam Overview', 'focus' => 'domain weighting and scenario-driven decision quality'},
    new Map<String, String>{'theme' => 'Solution Positioning', 'focus' => 'business-value alignment with target architecture'},
    new Map<String, String>{'theme' => 'Setup and Administration', 'focus' => 'governance controls and operational readiness'},
    new Map<String, String>{'theme' => 'Source Connection and Ingestion', 'focus' => 'connector orchestration and ingestion reliability'},
    new Map<String, String>{'theme' => 'Harmonization and Unification', 'focus' => 'semantic mapping and identity reconciliation'},
    new Map<String, String>{'theme' => 'Enhancements, Sharing and Analysis', 'focus' => 'calculated insights and secure data sharing'},
    new Map<String, String>{'theme' => 'Activations and Utilization', 'focus' => 'consent-aware activation with measurable outcomes'},
    new Map<String, String>{'theme' => 'Hands On Data 360', 'focus' => 'end-to-end implementation and troubleshooting depth'}
};

List<String> pitfalls = new List<String>{
    'Treating DLO and DMO as equivalent layers in deployment planning',
    'Ignoring consent and policy constraints before audience activation',
    'Assuming identity resolution can replace proper data mapping',
    'Separating governance from ingestion design decisions',
    'Skipping change traceability for production operations',
    'Using metrics before validating source quality thresholds',
    'Publishing audiences without strict inclusion and exclusion logic',
    'Over-automating without observability and control checkpoints'
};

List<String> operationalErrors = new List<String>{
    'Applying direct production changes without environment-level validation',
    'Using rollback as the main execution strategy rather than contingency',
    'Measuring success only by throughput with no quality indicators',
    'Relying on manual checks for critical activation paths',
    'Ignoring downstream consumer impact when adjusting mappings',
    'Promoting configuration without a traceable decision audit trail',
    'Decoupling delivery teams without semantic contracts across domains',
    'Treating data incidents as isolated exceptions rather than systemic failures'
};

List<String> architecturalShortcuts = new List<String>{
    'Optimizing query performance only and postponing governance controls',
    'Prioritizing immediate release while deferring consent design to later phases',
    'Assuming automatic unification without source quality verification',
    'Standardizing mappings by convention without domain-by-domain validation',
    'Running activation without tested inclusion and exclusion criteria',
    'Changing schema without backward compatibility analysis',
    'Normalizing identity rules without regional privacy exceptions',
    'Scaling connectors without end-to-end observability'
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
    if (!String.isBlank(c1) && c1.startsWith('S2E')) qByCode.put(c1, q);
    if (!String.isBlank(c2) && c2.startsWith('S2E')) qByCode.put(c2, q);
}

List<Questao__c> qIns = new List<Questao__c>();
List<Questao__c> qUpd = new List<Questao__c>();
List<Map<String, Object>> plan = new List<Map<String, Object>>();

for (Integer i = 0; i < 60; i++) {
    Integer n = i + 1;
    String code = 'S2E' + String.valueOf(n).leftPad(3, '0');

    Map<String, String> d = domains[Math.mod(i, domains.size())];
    String theme = d.get('theme');
    String focus = d.get('focus');
    String pitfall = pitfalls[Math.mod(i, pitfalls.size())];

    Integer variation = Math.mod(i, 3);
    String enunciado;
    if (variation == 0) {
        enunciado = 'In a certification-style scenario for ' + theme + ', which technical decision best demonstrates mastery of ' + focus + ' while preserving governance?';
    } else if (variation == 1) {
        enunciado = 'During an enterprise implementation, which approach minimizes operational risk in ' + theme + ' and remains aligned with the updated blueprint?';
    } else {
        enunciado = 'Which option reflects the strongest best practice for ' + theme + ' when delivery speed conflicts with data quality requirements?';
    }

    String correct = 'Adopt an architecture-first and governance-aware approach with incremental validation, quality gates, and impact-based business prioritization.';
    String w1 = pitfall + '.';
    String w2 = operationalErrors[Math.mod(i, operationalErrors.size())] + '.';
    String w3 = architecturalShortcuts[Math.mod(i + 3, architecturalShortcuts.size())] + '.';

    String expC = 'This is the strongest answer because it reflects how a Data 360 Consultant balances architecture, governance, and measurable business value under real constraints. In advanced scenarios, speed alone is insufficient; consistency, traceability, and policy compliance must be designed into the delivery model. This approach reduces rework and improves long-term trust in activations and analytics.';
    String expE = 'This choice may appear efficient in the short term, but it introduces structural risk that conflicts with consultant-level best practices. The exam expects decisions that integrate governance, quality, and architectural control, not tactical shortcuts. Ignoring these dimensions usually leads to unstable outcomes, compliance exposure, and low confidence in downstream activation.';

    Integer correctPos = Math.mod(i, 4) + 1;
    List<String> wrongTexts = new List<String>{ w1, w2, w3 };
    List<String> wrongExps = new List<String>{ expE, expE, expE };

    List<String> op = new List<String>();
    List<Boolean> ok = new List<Boolean>();
    List<String> ex = new List<String>();

    Integer idxWrong = 0;
    for (Integer p = 1; p <= 4; p++) {
        if (p == correctPos) {
            op.add(correct);
            ok.add(true);
            ex.add(expC);
        } else {
            op.add(wrongTexts[idxWrong]);
            ok.add(false);
            ex.add(wrongExps[idxWrong]);
            idxWrong++;
        }
    }

    Topico__c top = topicos[Math.mod(i, topicos.size())];
    String nomeQuestao = ('Sim Exam EN N2 - ' + code).left(80);

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
        if (hasSubtopico) q.put('Subtopico__c', 'Hard Simulation');
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
        if (hasSubtopico) existing.put('Subtopico__c', 'Hard Simulation');
        if (hasCodigoInterno) existing.put('CodigoInterno__c', code);
        if (hasCodigoQuestao) existing.put('CodigoQuestao__c', code);
        if (hasColecao) existing.put('ColecaoSimulado__c', colecao);
        if (hasNivel) existing.put('NivelSimulado__c', nivel);
        if (hasOrigem) existing.put('OrigemSimulado__c', origem);
        qUpd.add(existing);
    }

    plan.add(new Map<String, Object>{
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
    if (!String.isBlank(c1) && c1.startsWith('S2E')) qByCode.put(c1, q);
    if (!String.isBlank(c2) && c2.startsWith('S2E')) qByCode.put(c2, q);
}

Set<Id> qIds = new Set<Id>();
for (Map<String, Object> p : plan) {
    String code = (String) p.get('code');
    if (qByCode.containsKey(code)) qIds.add(qByCode.get(code).Id);
}

List<AlternativaQuestao__c> altOld = [SELECT Id FROM AlternativaQuestao__c WHERE Questao__c IN :qIds];
if (!altOld.isEmpty()) delete altOld;

List<AlternativaQuestao__c> altIns = new List<AlternativaQuestao__c>();
for (Map<String, Object> p : plan) {
    String code = (String) p.get('code');
    if (!qByCode.containsKey(code)) continue;
    Id qId = qByCode.get(code).Id;

    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 1, Name = String.valueOf(p.get('o1')).left(80), Correta__c = (Boolean) p.get('k1'), Ativa__c = true, ExplicacaoAlternativa__c = String.valueOf(p.get('e1'))));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 2, Name = String.valueOf(p.get('o2')).left(80), Correta__c = (Boolean) p.get('k2'), Ativa__c = true, ExplicacaoAlternativa__c = String.valueOf(p.get('e2'))));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 3, Name = String.valueOf(p.get('o3')).left(80), Correta__c = (Boolean) p.get('k3'), Ativa__c = true, ExplicacaoAlternativa__c = String.valueOf(p.get('e3'))));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 4, Name = String.valueOf(p.get('o4')).left(80), Correta__c = (Boolean) p.get('k4'), Ativa__c = true, ExplicacaoAlternativa__c = String.valueOf(p.get('e4'))));
}
if (!altIns.isEmpty()) insert altIns;

System.debug('SIM N2 EN OK | Inserted: ' + qIns.size() + ' | Updated: ' + qUpd.size() + ' | Alternatives: ' + altIns.size());
