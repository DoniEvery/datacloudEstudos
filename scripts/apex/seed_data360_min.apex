// Seed compatível com campos que EXISTEM na org DATACLOUDestudos
// Objetos/f campos disponíveis:
// Certificacao__c: Name
// DominioCertificacao__c: Name, Certificacao__c
// Topico__c: Name, DominioCertificacao__c
// Questao__c: Name, Certificacao__c, DominioPrincipal__c, TopicoPrincipal__c, Subtopico__c, TipoQuestao__c, NivelDificuldade__c
// AlternativaQuestao__c: Name, Questao__c, Correta__c, OrdemExibicao__c, ExplicacaoAlternativa__c, Ativa__c

Certificacao__c cert;
List<Certificacao__c> certs = [SELECT Id, Name FROM Certificacao__c WHERE Name = 'Salesforce Data 360 Consultant' LIMIT 1];
if (certs.isEmpty()) {
    cert = new Certificacao__c(Name = 'Salesforce Data 360 Consultant');
    insert cert;
} else {
    cert = certs[0];
}

List<String> domNames = new List<String>{
    'Solution Positioning',
    'Data 360 Setup and Administration',
    'Data Source Connection and Ingestion',
    'Harmonization and Unification',
    'Data Enhancements, Sharing, and Analysis',
    'Data Activations and Utilization'
};

Map<String, DominioCertificacao__c> domByName = new Map<String, DominioCertificacao__c>();
for (DominioCertificacao__c d : [SELECT Id, Name FROM DominioCertificacao__c WHERE Certificacao__c = :cert.Id]) domByName.put(d.Name, d);
List<DominioCertificacao__c> domIns = new List<DominioCertificacao__c>();
for (String dn : domNames) if (!domByName.containsKey(dn)) domIns.add(new DominioCertificacao__c(Name = dn, Certificacao__c = cert.Id));
if (!domIns.isEmpty()) insert domIns;
for (DominioCertificacao__c d : [SELECT Id, Name FROM DominioCertificacao__c WHERE Certificacao__c = :cert.Id]) domByName.put(d.Name, d);

List<List<String>> topicData = new List<List<String>>{
    new List<String>{'Solution Positioning','Terminologia e valor de negócio do Data 360'},
    new List<String>{'Solution Positioning','Data 360 como base para IA generativa e preditiva'},
    new List<String>{'Solution Positioning','Casos de uso iniciais para Data 360'},
    new List<String>{'Solution Positioning','Ética e governança de dados'},

    new List<String>{'Data 360 Setup and Administration','Permissões e configurações organizacionais'},
    new List<String>{'Data 360 Setup and Administration','Governança de dados na configuração da plataforma'},
    new List<String>{'Data 360 Setup and Administration','Ciclo de desenvolvimento e ferramentas disponíveis'},
    new List<String>{'Data 360 Setup and Administration','Diagnóstico e solução de problemas comuns'},

    new List<String>{'Data Source Connection and Ingestion','Transformação de dados no Data 360'},
    new List<String>{'Data Source Connection and Ingestion','Ingestão de dados de fontes variadas'},
    new List<String>{'Data Source Connection and Ingestion','Colaboração de dados e Zero-Copy'},

    new List<String>{'Harmonization and Unification','Propósito, processo e casos de uso da unificação'},
    new List<String>{'Harmonization and Unification','Modelagem de dados no Data 360'},

    new List<String>{'Data Enhancements, Sharing, and Analysis','Enriquecimento de dados e construção de insights'},
    new List<String>{'Data Enhancements, Sharing, and Analysis','Referenciamento de dados do Data 360 em outros sistemas'},
    new List<String>{'Data Enhancements, Sharing, and Analysis','Relatórios e dashboards com Data 360'},
    new List<String>{'Data Enhancements, Sharing, and Analysis','IA preditiva e generativa no Data 360'},

    new List<String>{'Data Activations and Utilization','Conceitos de segmentação e casos de uso'},
    new List<String>{'Data Activations and Utilization','Gerenciamento de segmentos no Data 360'},
    new List<String>{'Data Activations and Utilization','Publicação de Activations no Data 360'},
    new List<String>{'Data Activations and Utilization','Ação sobre dados'},
    new List<String>{'Data Activations and Utilization','Uso do Data 360 em Salesforce Flows'}
};

Map<String, Topico__c> topByKey = new Map<String, Topico__c>();
for (Topico__c t : [SELECT Id, Name, DominioCertificacao__r.Name FROM Topico__c WHERE DominioCertificacao__r.Certificacao__c = :cert.Id]) {
    topByKey.put(t.DominioCertificacao__r.Name + '|' + t.Name, t);
}
List<Topico__c> topIns = new List<Topico__c>();
for (List<String> row : topicData) {
    String dom = row[0], top = row[1], key = dom + '|' + top;
    if (!topByKey.containsKey(key)) topIns.add(new Topico__c(Name = top, DominioCertificacao__c = domByName.get(dom).Id));
}
if (!topIns.isEmpty()) insert topIns;
for (Topico__c t : [SELECT Id, Name, DominioCertificacao__r.Name FROM Topico__c WHERE DominioCertificacao__r.Certificacao__c = :cert.Id]) {
    topByKey.put(t.DominioCertificacao__r.Name + '|' + t.Name, t);
}

List<List<String>> qData = new List<List<String>>{
    new List<String>{'Solution Positioning','Terminologia e valor de negócio do Data 360','Q001 - Qual camada representa entidades harmonizadas no Data Cloud?','DMO (Data Model Object)','DLO (Data Lake Object)','Data Stream','CRM Report','Referência: Data Cloud Glossary (help.salesforce.com). DMO é harmonizado; DLO é bruto.'},
    new List<String>{'Solution Positioning','Data 360 como base para IA generativa e preditiva','Q002 - Como Data 360 apoia IA generativa?','Com contexto unificado (RAG)','Treinando LLM nativamente','Substituindo Einstein','Sem uso em IA','Referência: Einstein + Data Cloud. Data Cloud fornece contexto, não treina LLM.'},
    new List<String>{'Solution Positioning','Casos de uso iniciais para Data 360','Q003 - Melhor caso inicial de uso?','Unificação de perfil para personalização','Data warehouse financeiro','Substituir CRM','Log de auditoria','Referência: Trailhead Data Cloud Quick Look.'},
    new List<String>{'Solution Positioning','Ética e governança de dados','Q004 - Princípio de coletar só o necessário?','Minimização de dados','Portabilidade','Transparência algorítmica','Direito ao esquecimento','Referência: GDPR e Data Ethics Salesforce.'},

    new List<String>{'Data 360 Setup and Administration','Permissões e configurações organizacionais','Q005 - Qual acesso para gerenciar Data Streams?','Permissões Data Cloud Admin','Somente Sys Admin CRM','Role Marketing Cloud','CRM Analytics Admin','Referência: Data Cloud permissions (help.salesforce.com).'},
    new List<String>{'Data 360 Setup and Administration','Governança de dados na configuração da plataforma','Q006 - Recurso para isolar dados sensíveis?','Data Spaces','FLS do CRM','Shield Encryption apenas','Sharing Rules CRM','Referência: Data Spaces no Data Cloud.'},
    new List<String>{'Data 360 Setup and Administration','Ciclo de desenvolvimento e ferramentas disponíveis','Q007 - Melhor abordagem de migração entre ambientes?','Salesforce CLI + metadata','Copiar manual Setup','Só sandbox sem deploy','Workbench manual','Referência: Developer Guide Data Cloud.'},
    new List<String>{'Data 360 Setup and Administration','Diagnóstico e solução de problemas comuns','Q008 - Primeiro lugar para erro de ingestão?','Data Stream Monitor','Debug Apex','CloudWatch apenas','Event Monitoring','Referência: Monitor Data Streams.'},

    new List<String>{'Data Source Connection and Ingestion','Transformação de dados no Data 360','Q009 - Onde criar campo calculado no mapeamento?','Data Transform Formulas','Apex Trigger em DMO','Process Builder','Só pré-processar fora','Referência: Data Transforms.'},
    new List<String>{'Data Source Connection and Ingestion','Ingestão de dados de fontes variadas','Q010 - Conector para evento web em tempo real?','Streaming API / Web SDK','S3 diário','Data Loader','Mule com lote horário','Referência: Streaming Ingestion API.'},
    new List<String>{'Data Source Connection and Ingestion','Colaboração de dados e Zero-Copy','Q011 - O que significa Zero-Copy?','Acessar dado na fonte sem copiar','Copiar sem transformar','Zip antes de transferir','CDC replicado','Referência: Zero-Copy Data Cloud.'},

    new List<String>{'Harmonization and Unification','Propósito, processo e casos de uso da unificação','Q012 - Objetivo do Identity Resolution?','Unificar registros da mesma pessoa','Só deduplicar DLO','Sincronizar para CRM','Validar ingestão','Referência: Identity Resolution.'},
    new List<String>{'Harmonization and Unification','Modelagem de dados no Data 360','Q013 - Diferença principal DLO x DMO?','DLO bruto, DMO harmonizado','Batch vs streaming','DMO é interno','São sinônimos','Referência: Data Model Data Cloud.'},

    new List<String>{'Data Enhancements, Sharing, and Analysis','Enriquecimento de dados e construção de insights','Q014 - Recurso para métricas como gasto 90 dias?','Calculated Insights','Formula field CRM','Analytics Recipe apenas','Flow agendado CRM','Referência: Calculated Insights.'},
    new List<String>{'Data Enhancements, Sharing, and Analysis','Referenciamento de dados do Data 360 em outros sistemas','Q015 - Ver dado unificado no Contact sem duplicar?','Data Cloud for CRM (insights/lists)','SOQL direto em DMO','Sync diário para custom obj','Salesforce Connect','Referência: Use Data Cloud in CRM.'},
    new List<String>{'Data Enhancements, Sharing, and Analysis','Relatórios e dashboards com Data 360','Q016 - Ferramenta nativa de visualização?','Data Cloud Analytics','Report clássico direto em DMO','Google Data Studio','Excel manual','Referência: Analyze Data Cloud Data.'},
    new List<String>{'Data Enhancements, Sharing, and Analysis','IA preditiva e generativa no Data 360','Q017 - Onde configurar churn scoring no Data Cloud?','Einstein Studio','Apex Batch custom','Einstein Lead Scoring','Import PMML via loader','Referência: Einstein Studio.'},

    new List<String>{'Data Activations and Utilization','Conceitos de segmentação e casos de uso','Q018 - Base de construção dos segmentos?','Unified Individual','Contact CRM','Qualquer DLO','Lead','Referência: Segments no Data Cloud.'},
    new List<String>{'Data Activations and Utilization','Gerenciamento de segmentos no Data 360','Q019 - Segmento desatualizado no destino: revisar?','Publish schedule','Identity Resolution apenas','Manutenção MC','Sem activation target','Referência: Publish Segments.'},
    new List<String>{'Data Activations and Utilization','Publicação de Activations no Data 360','Q020 - O que define atributos enviados na Activation?','Attributes da Activation','Data Stream origem','Campos do DLO','Sharing rules CRM','Referência: Activations no Data Cloud.'},
    new List<String>{'Data Activations and Utilization','Ação sobre dados','Q021 - Disparar jornada ao entrar em segmento?','Data Action','Flow agendado','Republicar a cada 5 min','Trigger em Contact','Referência: Data Actions.'},
    new List<String>{'Data Activations and Utilization','Uso do Data 360 em Salesforce Flows','Q022 - Como Flow consulta Data Cloud em runtime?','Get Data Cloud Records','Get Records CRM sync','HTTP callout manual','SOQL em external obj','Referência: Use Data Cloud in Flow.'}
};

Map<String, String> subtopicByTopico = new Map<String, String>{
    'Terminologia e valor de negócio do Data 360' => 'Proposta de valor e linguagem comum do Data Cloud',
    'Data 360 como base para IA generativa e preditiva' => 'Contexto de dados para IA (RAG e personalização)',
    'Casos de uso iniciais para Data 360' => 'Priorização de quick wins de negócio',
    'Ética e governança de dados' => 'Princípios de minimização e uso responsável de dados',

    'Permissões e configurações organizacionais' => 'Acesso e papéis para administração da plataforma',
    'Governança de dados na configuração da plataforma' => 'Segregação e segurança com Data Spaces',
    'Ciclo de desenvolvimento e ferramentas disponíveis' => 'Gestão de mudanças e lifecycle em Data Cloud',
    'Diagnóstico e solução de problemas comuns' => 'Monitoramento e troubleshooting de ingestão',

    'Transformação de dados no Data 360' => 'Regras de mapeamento e transformação DLO→DMO',
    'Ingestão de dados de fontes variadas' => 'Padrões de ingestão batch e streaming',
    'Colaboração de dados e Zero-Copy' => 'Arquitetura federada sem duplicação de dados',

    'Propósito, processo e casos de uso da unificação' => 'Identity Resolution e perfil unificado',
    'Modelagem de dados no Data 360' => 'Diferenças e papel de DLO, DMO e modelo canônico',

    'Enriquecimento de dados e construção de insights' => 'Calculated Insights e métricas derivadas',
    'Referenciamento de dados do Data 360 em outros sistemas' => 'Consumo em CRM sem replicação desnecessária',
    'Relatórios e dashboards com Data 360' => 'Camadas analíticas nativas e visualização',
    'IA preditiva e generativa no Data 360' => 'Modelos no Einstein Studio e uso operacional',

    'Conceitos de segmentação e casos de uso' => 'Critérios de audiência sobre Unified Individual',
    'Gerenciamento de segmentos no Data 360' => 'Atualização, frequência e governança de segmentos',
    'Publicação de Activations no Data 360' => 'Mapeamento de atributos e destinos de ativação',
    'Ação sobre dados' => 'Orquestração orientada a eventos com Data Actions',
    'Uso do Data 360 em Salesforce Flows' => 'Consulta em runtime no Flow Builder'
};

Map<String, Questao__c> qByName = new Map<String, Questao__c>();
for (Questao__c q : [SELECT Id, Name, Subtopico__c FROM Questao__c WHERE Certificacao__c = :cert.Id]) qByName.put(q.Name, q);

List<Questao__c> qIns = new List<Questao__c>();
for (List<String> q : qData) {
    String qName = q[2];
    if (!qByName.containsKey(qName)) {
        String dom = q[0], top = q[1];
        qIns.add(new Questao__c(
            Name = qName,
            Certificacao__c = cert.Id,
            DominioPrincipal__c = domByName.get(dom).Id,
            TopicoPrincipal__c = topByKey.get(dom + '|' + top).Id,
            Subtopico__c = subtopicByTopico.containsKey(top) ? subtopicByTopico.get(top) : top,
            TipoQuestao__c = 'MultiplaEscolha',
            NivelDificuldade__c = 'Media'
        ));
    }
}
if (!qIns.isEmpty()) insert qIns;
for (Questao__c q : [SELECT Id, Name, Subtopico__c FROM Questao__c WHERE Certificacao__c = :cert.Id]) qByName.put(q.Name, q);

List<Questao__c> qUpd = new List<Questao__c>();
for (List<String> q : qData) {
    String top = q[1];
    String qName = q[2];
    String sub = subtopicByTopico.containsKey(top) ? subtopicByTopico.get(top) : top;
    Questao__c existingQ = qByName.get(qName);
    if (existingQ != null && existingQ.Subtopico__c != sub) {
        existingQ.Subtopico__c = sub;
        qUpd.add(existingQ);
    }
}
if (!qUpd.isEmpty()) update qUpd;

Set<Id> qIds = new Set<Id>();
for (List<String> q : qData) qIds.add(qByName.get(q[2]).Id);
List<AlternativaQuestao__c> altOld = [SELECT Id FROM AlternativaQuestao__c WHERE Questao__c IN :qIds];
if (!altOld.isEmpty()) delete altOld;

List<AlternativaQuestao__c> altIns = new List<AlternativaQuestao__c>();
for (List<String> q : qData) {
    Id qId = qByName.get(q[2]).Id;
    String ref = q[7];
    altIns.add(new AlternativaQuestao__c(Questao__c=qId, OrdemExibicao__c=1, Name=q[3], Correta__c=true,  Ativa__c=true, ExplicacaoAlternativa__c='Correta. ' + ref));
    altIns.add(new AlternativaQuestao__c(Questao__c=qId, OrdemExibicao__c=2, Name=q[4], Correta__c=false, Ativa__c=true, ExplicacaoAlternativa__c='Incorreta. ' + ref));
    altIns.add(new AlternativaQuestao__c(Questao__c=qId, OrdemExibicao__c=3, Name=q[5], Correta__c=false, Ativa__c=true, ExplicacaoAlternativa__c='Incorreta. ' + ref));
    altIns.add(new AlternativaQuestao__c(Questao__c=qId, OrdemExibicao__c=4, Name=q[6], Correta__c=false, Ativa__c=true, ExplicacaoAlternativa__c='Incorreta. ' + ref));
}
insert altIns;

System.debug('SEED OK | Cert=' + cert.Id + ' | Domínios=' + domByName.size() + ' | Tópicos=' + topByKey.size() + ' | Questões=' + qIds.size() + ' | Alternativas=' + altIns.size());