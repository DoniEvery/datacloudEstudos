// Questões sobre a ORDEM de ingestão de dados no Data Cloud
// Cobrindo: Salesforce CRM Connector e Amazon S3
// Códigos: WK028..WK032

Certificacao__c cert;
List<Certificacao__c> certs = [SELECT Id, Name FROM Certificacao__c WHERE Name = 'Salesforce Data 360 Consultant' LIMIT 1];
if (certs.isEmpty()) {
    cert = new Certificacao__c(Name = 'Salesforce Data 360 Consultant');
    insert cert;
} else {
    cert = certs[0];
}
Id certId = cert.Id;

Map<String, DominioCertificacao__c> domByName = new Map<String, DominioCertificacao__c>();
for (DominioCertificacao__c d : [SELECT Id, Name FROM DominioCertificacao__c WHERE Certificacao__c = :cert.Id]) {
    domByName.put(d.Name, d);
}

Map<String, Topico__c> topByKey = new Map<String, Topico__c>();
for (Topico__c t : [SELECT Id, Name, DominioCertificacao__r.Name FROM Topico__c WHERE DominioCertificacao__r.Certificacao__c = :cert.Id]) {
    topByKey.put(t.DominioCertificacao__r.Name + '|' + t.Name, t);
}

// Formato: [dominio, topico, subtopico, legacyKey, enunciado, altCorreta, alt2, alt3, alt4, referencia]
List<List<String>> qData = new List<List<String>>{

    // WK028 — Ordem CRM Connector
    new List<String>{
        'Data Source Connection and Ingestion',
        'Ingestão de dados de fontes variadas',
        'Ordem do pipeline de ingestão no Data Cloud',
        'WQ028',
        'Qual é a ordem correta das etapas para ingerir dados do Salesforce CRM no Data Cloud usando o CRM Connector?',
        'Criar Data Stream → dados chegam ao DLO → mapear DLO para DMO',
        'Criar DMO → mapear para DLO → criar Data Stream',
        'Criar DLO → criar Data Stream → mapear para DMO',
        'Criar Data Stream → mapear para DMO → dados chegam ao DLO',
        'Ordem CRM Connector: 1) Data Stream define a fonte; 2) dados brutos chegam ao DLO; 3) campos do DLO são mapeados para o DMO do Customer 360 Data Model.'
    },

    // WK029 — Ordem S3
    new List<String>{
        'Data Source Connection and Ingestion',
        'Ingestão de dados de fontes variadas',
        'Ordem do pipeline de ingestão no Data Cloud',
        'WQ029',
        'Qual é a ordem correta das etapas para ingerir dados de arquivos CSV armazenados no Amazon S3 no Data Cloud?',
        'Criar conexão S3 → criar Data Stream → dados chegam ao DLO → mapear DLO para DMO',
        'Criar Data Stream → criar conexão S3 → DLO → DMO',
        'Criar DLO → criar conexão S3 → criar Data Stream → DMO',
        'Criar conexão S3 → DMO → DLO → Data Stream',
        'Ordem S3: 1) Conexão S3 autentica o bucket; 2) Data Stream define o arquivo/schema; 3) dados brutos chegam ao DLO; 4) DLO é mapeado para DMO.'
    },

    // WK030 — O que é DLO
    new List<String>{
        'Data Source Connection and Ingestion',
        'Transformação de dados no Data 360',
        'DLO vs DMO — diferenças e papéis no pipeline',
        'WQ030',
        'O que é um Data Lake Object (DLO) no contexto do Data Cloud?',
        'A camada de armazenamento bruto onde os dados ingeridos chegam antes de serem mapeados para o modelo de dados',
        'O objeto final do Customer 360 Data Model que representa entidades como Individual e Contact Point Email',
        'Um conector nativo que extrai registros diretamente do Salesforce CRM sem transformação',
        'Uma view criada automaticamente para relatórios no CRM Analytics',
        'DLO (Data Lake Object) é a representação bruta dos dados da fonte dentro do Data Cloud. Os dados chegam primeiro ao DLO antes de qualquer harmonização.'
    },

    // WK031 — Quando ocorre o mapeamento DLO → DMO
    new List<String>{
        'Data Source Connection and Ingestion',
        'Transformação de dados no Data 360',
        'Mapeamento de DLO para DMO no Customer 360 Data Model',
        'WQ031',
        'Em qual etapa do pipeline de ingestão do Data Cloud os campos da fonte de dados (ex: arquivo S3 ou CRM) são mapeados para o Customer 360 Data Model?',
        'Após o Data Stream ser criado e o DLO gerado, no passo de mapeamento DLO → DMO',
        'Durante a criação do Data Stream, antes de qualquer dado ser armazenado no DLO',
        'Antes de criar a conexão com a fonte, ao definir o schema do arquivo',
        'Automaticamente pelo Identity Resolution Ruleset, sem necessidade de mapeamento manual',
        'O mapeamento para o DMO ocorre como etapa separada depois da criação do Data Stream. O DLO já existe com os dados brutos e o administrador mapeia os campos para o modelo.'
    },

    // WK032 — DLO vs DMO diferença
    new List<String>{
        'Data Source Connection and Ingestion',
        'Transformação de dados no Data 360',
        'DLO vs DMO — diferenças e papéis no pipeline',
        'WQ032',
        'Qual é a principal diferença entre um Data Lake Object (DLO) e um Data Model Object (DMO) no Data Cloud?',
        'DLO armazena os dados brutos da fonte de origem; DMO representa entidades harmonizadas do Customer 360 Data Model (ex: Individual, Contact Point Email)',
        'DLO é exclusivo para fontes Salesforce; DMO é usado apenas para fontes externas como Amazon S3',
        'DLO e DMO são sinônimos — ambos representam o mesmo dado em camadas diferentes de acesso',
        'DMO armazena dados brutos da fonte; DLO é a camada de harmonização e modelagem',
        'DLO = dados brutos da fonte (ex: Contact_sfcrm__dll). DMO = modelo harmonizado do ecossistema Salesforce (ex: ssot__Individual__dlm). O mapeamento DLO → DMO é a etapa de transformação.'
    }
};

// Schema detection
Map<String, Schema.SObjectField> qFields = Schema.SObjectType.Questao__c.fields.getMap();
Boolean hasEnunciado = qFields.containsKey('Enunciado__c');
Boolean hasSubtopico = qFields.containsKey('Subtopico__c');
Boolean hasCodigo = qFields.containsKey('CodigoInterno__c');
Boolean hasCodigoQuestao = qFields.containsKey('CodigoQuestao__c');

// Carrega questões existentes para idempotência
Map<String, Questao__c> qByCodigo = new Map<String, Questao__c>();
Map<String, Questao__c> qByEnunciado = new Map<String, Questao__c>();

List<String> qLoadFields = new List<String>{ 'Id', 'Name' };
if (hasCodigo) qLoadFields.add('CodigoInterno__c');
if (hasCodigoQuestao) qLoadFields.add('CodigoQuestao__c');
if (hasEnunciado) qLoadFields.add('Enunciado__c');
String qLoadSoql = 'SELECT ' + String.join(qLoadFields, ', ')
    + ' FROM Questao__c WHERE Certificacao__c = :certId';
for (SObject sob : Database.query(qLoadSoql)) {
    Questao__c q = (Questao__c) sob;
    if (hasCodigo && !String.isBlank((String) q.get('CodigoInterno__c'))) {
        qByCodigo.put((String) q.get('CodigoInterno__c'), q);
    } else if (hasCodigoQuestao && !String.isBlank((String) q.get('CodigoQuestao__c'))) {
        qByCodigo.put((String) q.get('CodigoQuestao__c'), q);
    }
    if (hasEnunciado && !String.isBlank((String) q.get('Enunciado__c'))) {
        qByEnunciado.put((String) q.get('Enunciado__c'), q);
    }
}

List<Questao__c> qIns = new List<Questao__c>();
List<Questao__c> qUpd = new List<Questao__c>();

for (List<String> row : qData) {
    String dom = row[0], top = row[1], sub = row[2], legacyKey = row[3], enunciado = row[4];
    String code = 'WK' + legacyKey.substring(2, 5); // WQ028 → WK028

    String nomeQuestao = 'Workshop - ' + sub;
    if (nomeQuestao.length() > 80) nomeQuestao = nomeQuestao.left(80);

    String topKey = dom + '|' + top;
    if (!(domByName.containsKey(dom) && topByKey.containsKey(topKey))) {
        System.debug('AVISO: domínio/tópico não encontrado: ' + topKey);
        continue;
    }

    Questao__c existing = null;
    if (qByCodigo.containsKey(code)) {
        existing = qByCodigo.get(code);
    } else if (hasEnunciado && qByEnunciado.containsKey(enunciado)) {
        existing = qByEnunciado.get(enunciado);
    }

    if (existing == null) {
        Questao__c nova = new Questao__c(
            Name = nomeQuestao,
            Certificacao__c = cert.Id,
            DominioPrincipal__c = domByName.get(dom).Id,
            TopicoPrincipal__c = topByKey.get(topKey).Id,
            TipoQuestao__c = 'MultiplaEscolha',
            NivelDificuldade__c = 'Media'
        );
        if (hasCodigo) nova.put('CodigoInterno__c', code);
        if (hasCodigoQuestao) nova.put('CodigoQuestao__c', code);
        if (hasEnunciado) nova.put('Enunciado__c', enunciado);
        if (hasSubtopico) nova.put('Subtopico__c', sub);
        qIns.add(nova);
    } else {
        Boolean changed = false;
        if (existing.Name != nomeQuestao) { existing.Name = nomeQuestao; changed = true; }
        if (hasCodigo && (String) existing.get('CodigoInterno__c') != code) { existing.put('CodigoInterno__c', code); changed = true; }
        if (hasCodigoQuestao && (String) existing.get('CodigoQuestao__c') != code) { existing.put('CodigoQuestao__c', code); changed = true; }
        if (hasEnunciado) { existing.put('Enunciado__c', enunciado); changed = true; }
        if (hasSubtopico) { existing.put('Subtopico__c', sub); changed = true; }
        if (changed) qUpd.add(existing);
    }
}

if (!qIns.isEmpty()) insert qIns;
if (!qUpd.isEmpty()) update qUpd;

// Recarrega mapa após inserts
qByCodigo.clear();
qByEnunciado.clear();
for (SObject sob : Database.query(qLoadSoql)) {
    Questao__c q = (Questao__c) sob;
    if (hasCodigo && !String.isBlank((String) q.get('CodigoInterno__c'))) qByCodigo.put((String) q.get('CodigoInterno__c'), q);
    else if (hasCodigoQuestao && !String.isBlank((String) q.get('CodigoQuestao__c'))) qByCodigo.put((String) q.get('CodigoQuestao__c'), q);
    if (hasEnunciado && !String.isBlank((String) q.get('Enunciado__c'))) qByEnunciado.put((String) q.get('Enunciado__c'), q);
}

// Limpa e recria alternativas (idempotente)
Set<Id> qIds = new Set<Id>();
for (List<String> row : qData) {
    String code = 'WK' + row[3].substring(2, 5);
    if (qByCodigo.containsKey(code)) qIds.add(qByCodigo.get(code).Id);
    else if (hasEnunciado && qByEnunciado.containsKey(row[4])) qIds.add(qByEnunciado.get(row[4]).Id);
}
List<AlternativaQuestao__c> altOld = [SELECT Id FROM AlternativaQuestao__c WHERE Questao__c IN :qIds];
if (!altOld.isEmpty()) delete altOld;

List<AlternativaQuestao__c> altIns = new List<AlternativaQuestao__c>();
for (List<String> row : qData) {
    String code = 'WK' + row[3].substring(2, 5);
    Id qId;
    if (qByCodigo.containsKey(code)) qId = qByCodigo.get(code).Id;
    else if (hasEnunciado && qByEnunciado.containsKey(row[4])) qId = qByEnunciado.get(row[4]).Id;
    else continue;

    String ref = row[9];
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 1, Name = row[5].left(80), Correta__c = true,  Ativa__c = true, ExplicacaoAlternativa__c = 'Correto. ' + ref));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 2, Name = row[6].left(80), Correta__c = false, Ativa__c = true, ExplicacaoAlternativa__c = 'Incorreto. ' + ref));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 3, Name = row[7].left(80), Correta__c = false, Ativa__c = true, ExplicacaoAlternativa__c = 'Incorreto. ' + ref));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 4, Name = row[8].left(80), Correta__c = false, Ativa__c = true, ExplicacaoAlternativa__c = 'Incorreto. ' + ref));
}
if (!altIns.isEmpty()) insert altIns;

// Atualiza CodigoQuestao__c se o campo existir
if (hasCodigoQuestao) {
    List<Questao__c> qCodUpd = new List<Questao__c>();
    for (List<String> row : qData) {
        String code = 'WK' + row[3].substring(2, 5);
        if (qByCodigo.containsKey(code)) {
            Questao__c q = qByCodigo.get(code);
            q.put('CodigoQuestao__c', code);
            qCodUpd.add(q);
        }
    }
    if (!qCodUpd.isEmpty()) update qCodUpd;
}

System.debug('INGESTÃO ORDER SEED OK | Inseridas: ' + qIns.size() + ' | Atualizadas: ' + qUpd.size() + ' | Alternativas: ' + altIns.size());
