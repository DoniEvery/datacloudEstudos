// Simulated Exam Level 3 (Very Hard) - English
// Collection: Advanced Architecture - EN
// Source: Official (Complex Scenarios)

List<Certificacao__c> certs = [
    SELECT Id, Name
    FROM Certificacao__c
    WHERE Name = 'Salesforce Data 360 Consultant'
    LIMIT 1
];
if (certs.isEmpty()) {
    System.debug('SIM N3 EN | Certification not found.');
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
    System.debug('SIM N3 EN | No topics found.');
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

String colecao = 'Advanced Architecture - EN';
Integer nivel = 3;
String origem = 'Official (Complex Scenarios)';

List<String> scenarios = new List<String>{
    'wave-based migration with multiple source systems and constrained cutover windows',
    'near real-time activation under dynamic multi-channel consent constraints',
    'identity reconciliation with conflicting matching rules across regions',
    'global data model with local privacy and retention obligations',
    'go-live with low latency tolerance and strict auditability requirements',
    'post-merger data landscape with overlapping taxonomies and channels',
    'omnichannel loyalty strategy dependent on high-fidelity segmentation',
    'federated governance across marketing, service, and data engineering teams'
};

List<String> focuses = new List<String>{
    'architecture-first decisions under regulatory pressure',
    'quality-gate design with measurable acceptance thresholds',
    'sequencing between ingestion, harmonization, unification, and activation',
    'trade-off management between operational cost and governance resilience',
    'rollback strategy without traceability loss',
    'end-to-end observability for predictive troubleshooting',
    'schema and mapping change isolation with controlled blast radius',
    'semantic consistency across DLO, DMO, and downstream consumers'
};

List<String> structuralErrors = new List<String>{
    'Consolidating all validation in a final checkpoint to accelerate delivery',
    'Prioritizing ingestion throughput only while deferring identity decisions',
    'Deploying simultaneous changes without feature flags or blast-radius isolation',
    'Applying global rules without local privacy and retention constraints',
    'Approving activation without phase-level quality gates',
    'Ignoring semantic contracts across source, model, and destination layers',
    'Operating without telemetry for early regression detection',
    'Executing cutover without scenario-tested rollback playbooks'
};

List<String> riskySimplifications = new List<String>{
    'Deferring governance design until after go-live to gain speed',
    'Assuming identity reconciliation can compensate for weak harmonization',
    'Defining success by deadline only, without reliability metrics',
    'Optimizing near-term cost while accepting unmanaged technical debt',
    'Changing schema without backward compatibility strategy',
    'Scaling integration without a domain-level risk matrix',
    'Activating audiences without multi-channel consent validation',
    'Decoupling teams without federated decision governance'
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
    if (!String.isBlank(c1) && c1.startsWith('S3E')) qByCode.put(c1, q);
    if (!String.isBlank(c2) && c2.startsWith('S3E')) qByCode.put(c2, q);
}

List<Questao__c> qIns = new List<Questao__c>();
List<Questao__c> qUpd = new List<Questao__c>();
List<Map<String, Object>> plan = new List<Map<String, Object>>();

for (Integer i = 0; i < 60; i++) {
    Integer n = i + 1;
    String code = 'S3E' + String.valueOf(n).leftPad(3, '0');

    String scenario = scenarios[Math.mod(i, scenarios.size())];
    String focus = focuses[Math.mod(i, focuses.size())];

    Integer variation = Math.mod(i, 3);
    String enunciado;
    if (variation == 0) {
        enunciado = 'In a scenario involving ' + scenario + ', which consulting approach best satisfies ' + focus + ' without compromising governance and operational performance?';
    } else if (variation == 1) {
        enunciado = 'Which technical decision, under ' + scenario + ', most effectively reduces systemic risk while preserving long-term Data 360 evolvability?';
    } else {
        enunciado = 'Given ' + scenario + ', which option provides the strongest balance between incremental delivery, data quality, and compliance outcomes?';
    }

    String correct = 'Use a layered delivery strategy with phase-level quality and compliance gates, explicit semantic contracts, active observability, and scenario-tested rollback plans.';
    String wrong1 = structuralErrors[Math.mod(i, structuralErrors.size())] + '.';
    String wrong2 = riskySimplifications[Math.mod(i + 2, riskySimplifications.size())] + '.';
    String wrong3 = 'Apply the decision in a ' + scenarios[Math.mod(i + 3, scenarios.size())] + ' context without reinforcing ' + focuses[Math.mod(i + 5, focuses.size())] + '.';

    String expC = 'This answer aligns with consultant-level decision quality because it protects reliability under complexity through staged controls, measurable gates, and traceable change management. In Data 360, downstream activation quality depends on upstream semantic and governance integrity. A layered approach prevents hidden risk accumulation and supports durable, auditable operations at scale.';
    String expE = 'This option underestimates structural dependencies in enterprise data programs and typically creates hidden technical or regulatory debt. Advanced exam scenarios reward decisions that integrate architecture, governance, and business accountability, not speed-only shortcuts. Ignoring that integration often leads to instability, low trust in outputs, and expensive remediation.';

    Integer correctPos = Math.mod(i, 4) + 1;
    List<String> distractors = new List<String>{ wrong1, wrong2, wrong3 };

    List<String> op = new List<String>();
    List<Boolean> ok = new List<Boolean>();
    List<String> ex = new List<String>();

    Integer idx = 0;
    for (Integer p = 1; p <= 4; p++) {
        if (p == correctPos) {
            op.add(correct);
            ok.add(true);
            ex.add(expC);
        } else {
            op.add(distractors[idx]);
            ok.add(false);
            ex.add(expE);
            idx++;
        }
    }

    Topico__c top = topicos[Math.mod(i, topicos.size())];
    String nomeQuestao = ('Sim Exam EN N3 - ' + code).left(80);

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
        if (hasSubtopico) q.put('Subtopico__c', 'Very Hard Simulation');
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
        if (hasSubtopico) existing.put('Subtopico__c', 'Very Hard Simulation');
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
    if (!String.isBlank(c1) && c1.startsWith('S3E')) qByCode.put(c1, q);
    if (!String.isBlank(c2) && c2.startsWith('S3E')) qByCode.put(c2, q);
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

System.debug('SIM N3 EN OK | Inserted: ' + qIns.size() + ' | Updated: ' + qUpd.size() + ' | Alternatives: ' + altIns.size());
