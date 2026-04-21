// Seed: Questões SM011 a SM015 - inserção direta com IDs reais da org

Id certId     = 'a2sfj000008BZ2fAAG';

// Domínios
Id domIngestion       = 'a2tfj0000005HD9AAM'; // Data Source Connection and Ingestion
Id domHarmonization   = 'a2tfj0000005HDAAA2'; // Harmonization and Unification
Id domEnhancements    = 'a2tfj0000005HDBAA2'; // Data Enhancements, Sharing, and Analysis
Id domActivations     = 'a2tfj0000005HDCAA2'; // Data Activations and Utilization

// Tópicos
Id topIngestion       = 'a2ufj00000CmkhiAAB'; // Ingestão de dados de fontes variadas
Id topModelagem       = 'a2ufj00000CmkhlAAB'; // Modelagem de dados no Data 360
Id topUnificacao      = 'a2ufj00000CmkhkAAB'; // Propósito, processo e casos de uso da unificação
Id topInsights        = 'a2ufj00000CmkhmAAB'; // Enriquecimento de dados e construção de insights
Id topActivations     = 'a2ufj00000CmkhsAAB'; // Publicação de Activations no Data 360

String colecao  = 'Fundamentos Data Cloud';
Integer nivel   = 1;
String origem   = 'Oficial (Fundamentos)';

// --- Definição das questões ---
List<Map<String, Object>> questoes = new List<Map<String, Object>>{
    new Map<String, Object>{
        'code'    => 'SM011',
        'name'    => 'Simulado - SM011',
        'enunc'   => 'Qual objeto representa o dado em seu estado bruto dentro do Data Cloud, mantendo o formato original da fonte de origem?',
        'subTopico' => 'Ingestão de Dados',
        'dominio' => domIngestion,
        'topico'  => topIngestion,
        'alts'    => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'Data Model Object (DMO)',  'correta' => false, 'exp' => 'DMO é a camada modelada após a harmonização, não o estado bruto dos dados.' },
            new Map<String, Object>{ 'texto' => 'Data Lake Object (DLO)',   'correta' => true,  'exp' => 'O Data Lake Object (DLO) é o contêiner que armazena os dados brutos assim que são ingeridos, antes de qualquer processo de transformação ou harmonização.' },
            new Map<String, Object>{ 'texto' => 'Calculated Insight',       'correta' => false, 'exp' => 'Calculated Insights são métricas calculadas derivadas de dados harmonizados, não armazenamento de dados brutos.' },
            new Map<String, Object>{ 'texto' => 'Activation Target',        'correta' => false, 'exp' => 'Activation Targets são destinos externos para envio de dados já processados, não armazenamento bruto.' }
        }
    },
    new Map<String, Object>{
        'code'    => 'SM012',
        'name'    => 'Simulado - SM012',
        'enunc'   => 'No processo de mapeamento, para qual modelo padrão os Data Lake Objects (DLOs) devem ser direcionados para permitir a unificação dos perfis?',
        'subTopico' => 'Modelagem e Harmonização',
        'dominio' => domHarmonization,
        'topico'  => topModelagem,
        'alts'    => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'Data Model Object (DMO)', 'correta' => true,  'exp' => 'Os DMOs são a camada modelada do Data Cloud. Eles seguem o Cloud Information Model (CIM) para garantir que dados de diferentes fontes falem a mesma linguagem.' },
            new Map<String, Object>{ 'texto' => 'Custom Metadata',         'correta' => false, 'exp' => 'Custom Metadata é usado para configurações, não como destino de mapeamento de DLOs.' },
            new Map<String, Object>{ 'texto' => 'Salesforce Schema',        'correta' => false, 'exp' => 'Salesforce Schema refere-se ao CRM tradicional, não ao modelo de dados do Data Cloud.' },
            new Map<String, Object>{ 'texto' => 'Data Stream Object',       'correta' => false, 'exp' => 'Data Stream Objects orquestram a ingestão, mas não são o alvo do mapeamento.' }
        }
    },
    new Map<String, Object>{
        'code'    => 'SM013',
        'name'    => 'Simulado - SM013',
        'enunc'   => 'Qual recurso é utilizado para consolidar múltiplos registros (como diferentes e-mails ou telefones) de fontes distintas em um perfil único de Unified Individual?',
        'subTopico' => 'Resolução de Identidade',
        'dominio' => domHarmonization,
        'topico'  => topUnificacao,
        'alts'    => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'Data Mapping',              'correta' => false, 'exp' => 'Data Mapping é o processo de transformação de dados, não o recurso de consolidação de identidades.' },
            new Map<String, Object>{ 'texto' => 'Streaming Insights',        'correta' => false, 'exp' => 'Streaming Insights processam dados em tempo real, mas não consolidam identidades em um perfil unificado.' },
            new Map<String, Object>{ 'texto' => 'Identity Resolution Rules', 'correta' => true,  'exp' => 'As Identity Resolution Rules utilizam critérios de correspondência (Match Rules) para identificar e unir registros duplicados em um único perfil unificado.' },
            new Map<String, Object>{ 'texto' => 'Connector API',             'correta' => false, 'exp' => 'Connector API orquestra a ingestão de dados externos, mas não resolve identidades nem consolida perfis.' }
        }
    },
    new Map<String, Object>{
        'code'    => 'SM014',
        'name'    => 'Simulado - SM014',
        'enunc'   => 'Qual funcionalidade permite criar métricas complexas processadas em lote (batch), como o cálculo do Lifetime Value (LTV) de um cliente?',
        'subTopico' => 'Inteligência de Dados',
        'dominio' => domEnhancements,
        'topico'  => topInsights,
        'alts'    => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'Calculated Insights',   'correta' => true,  'exp' => 'Calculated Insights são usados para cálculos multidimensionais históricos que exigem grande processamento, como o Lifetime Value (LTV) de um cliente.' },
            new Map<String, Object>{ 'texto' => 'Streaming Insights',    'correta' => false, 'exp' => 'Streaming Insights focam em ações de tempo real e eventos em cadência alta, não em cálculos complexos de lote com histórico acumulado.' },
            new Map<String, Object>{ 'texto' => 'Data Streams',          'correta' => false, 'exp' => 'Data Streams orquestram a ingestão de dados, não realizam cálculos ou derivações de métricas complexas como LTV.' },
            new Map<String, Object>{ 'texto' => 'Identity Resolution',   'correta' => false, 'exp' => 'Identity Resolution consolida identidades, não calcula métricas de negócio como Lifetime Value.' }
        }
    },
    new Map<String, Object>{
        'code'    => 'SM015',
        'name'    => 'Simulado - SM015',
        'enunc'   => 'Para onde os dados segmentados são enviados quando precisam ser utilizados em ferramentas externas, como o Marketing Cloud ou Amazon S3?',
        'subTopico' => 'Ativação de Dados',
        'dominio' => domActivations,
        'topico'  => topActivations,
        'alts'    => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'Data Lake',          'correta' => false, 'exp' => 'Data Lake armazena dados internamente no Data Cloud. Activation Targets são para envio de dados para destinos externos.' },
            new Map<String, Object>{ 'texto' => 'Identity Rules',     'correta' => false, 'exp' => 'Identity Rules consolidam perfis internamente e não representam destinos de ativação.' },
            new Map<String, Object>{ 'texto' => 'DMO',                'correta' => false, 'exp' => 'DMOs armazenam dados modelados internamente. Para envio externo, usa-se Activation Targets.' },
            new Map<String, Object>{ 'texto' => 'Activation Targets', 'correta' => true,  'exp' => 'Activation Targets representam o destino final para onde os segmentos de audiência são exportados para que a jornada do cliente continue fora do Data Cloud.' }
        }
    }
};

// --- Verificar quais já existem por código ---
Map<String, Questao__c> existentes = new Map<String, Questao__c>();
for (Questao__c q : [SELECT Id, CodigoQuestao__c FROM Questao__c WHERE Certificacao__c = :certId AND CodigoQuestao__c IN ('SM011','SM012','SM013','SM014','SM015')]) {
    existentes.put(q.CodigoQuestao__c, q);
}

List<Questao__c> qIns = new List<Questao__c>();
List<Questao__c> qUpd = new List<Questao__c>();

for (Map<String, Object> q : questoes) {
    String code = (String) q.get('code');
    Questao__c rec = existentes.containsKey(code) ? existentes.get(code) : new Questao__c();

    rec.Name                = (String) q.get('name');
    rec.put('Enunciado__c', q.get('enunc'));
    rec.Certificacao__c     = certId;
    rec.DominioPrincipal__c = (Id) q.get('dominio');
    rec.TopicoPrincipal__c  = (Id) q.get('topico');
    rec.TipoQuestao__c      = 'Simulado';
    rec.NivelDificuldade__c = 'Facil';
    rec.put('ColecaoSimulado__c', colecao);
    rec.put('NivelSimulado__c',   nivel);
    rec.put('OrigemSimulado__c',  origem);
    rec.put('CodigoQuestao__c',   code);
    rec.put('Subtopico__c', q.get('subTopico'));

    if (rec.Id == null) {
        qIns.add(rec);
    } else {
        qUpd.add(rec);
    }
}

if (!qIns.isEmpty()) insert qIns;
if (!qUpd.isEmpty()) update qUpd;

// Recarregar mapa com IDs finais
Map<String, Id> codeToId = new Map<String, Id>();
for (Questao__c q : [SELECT Id, CodigoQuestao__c FROM Questao__c WHERE Certificacao__c = :certId AND CodigoQuestao__c IN ('SM011','SM012','SM013','SM014','SM015')]) {
    codeToId.put(q.CodigoQuestao__c, q.Id);
}

// Deletar alternativas antigas
Set<Id> qIds = new Set<Id>(codeToId.values());
List<AlternativaQuestao__c> altOld = [SELECT Id FROM AlternativaQuestao__c WHERE Questao__c IN :qIds];
if (!altOld.isEmpty()) delete altOld;

// Inserir alternativas
List<AlternativaQuestao__c> altIns = new List<AlternativaQuestao__c>();
for (Map<String, Object> q : questoes) {
    String code = (String) q.get('code');
    if (!codeToId.containsKey(code)) continue;
    Id qId = codeToId.get(code);

    List<Map<String, Object>> alts = (List<Map<String, Object>>) q.get('alts');
    for (Integer i = 0; i < alts.size(); i++) {
        Map<String, Object> a = alts[i];
        altIns.add(new AlternativaQuestao__c(
            Questao__c            = qId,
            OrdemExibicao__c      = i + 1,
            Name                  = ((String) a.get('texto')).left(80),
            Correta__c            = (Boolean) a.get('correta'),
            Ativa__c              = true,
            ExplicacaoAlternativa__c = (String) a.get('exp')
        ));
    }
}

if (!altIns.isEmpty()) insert altIns;

System.debug('SEED SM011-SM015 OK | Inseridas: ' + qIns.size() + ' | Atualizadas: ' + qUpd.size() + ' | Alternativas: ' + altIns.size());
