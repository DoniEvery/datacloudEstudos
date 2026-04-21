// Seed: Questões SM016 a SM021 - Configuração e Ingestão

Id certId          = 'a2sfj000008BZ2fAAG';
Id domSetup        = 'a2tfj0000005HD8AAM'; // Data 360 Setup and Administration
Id domIngestion    = 'a2tfj0000005HD9AAM'; // Data Source Connection and Ingestion
Id topCiclo        = 'a2ufj00000CmkhfAAB'; // Ciclo de desenvolvimento e ferramentas disponíveis
Id topIngestion    = 'a2ufj00000CmkhiAAB'; // Ingestão de dados de fontes variadas
Id topTransformacao = 'a2ufj00000CmkhhAAB'; // Transformação de dados no Data 360

String colecao  = 'Fundamentos Data Cloud';
Integer nivel   = 1;
String origem   = 'Oficial (Fundamentos)';

List<Map<String, Object>> questoes = new List<Map<String, Object>>{
    new Map<String, Object>{
        'code'      => 'SM016',
        'name'      => 'Simulado - SM016',
        'enunc'     => 'Qual é a primeira ação que deve ser realizada ao iniciar a configuração do ambiente de Data Cloud?',
        'subTopico' => 'Setup e Provisionamento',
        'dominio'   => domSetup,
        'topico'    => topCiclo,
        'alts'      => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'Create the Contact data stream',             'correta' => false, 'exp' => 'Criar um Data Stream pressupõe que o ambiente já está provisionado. Sem verificar o provisionamento antes, a configuração pode falhar ou gerar inconsistências.' },
            new Map<String, Object>{ 'texto' => 'Verificar que o Data 360 está provisionado', 'correta' => true,  'exp' => 'Antes de qualquer ingestão ou modelagem, é essencial confirmar que a licença e o ambiente de Data 360 foram devidamente provisionados na organização.' },
            new Map<String, Object>{ 'texto' => 'Configure Identity Resolution',              'correta' => false, 'exp' => 'Identity Resolution é uma etapa mais avançada do ciclo; ela só faz sentido após a ingestão e mapeamento de dados.' },
            new Map<String, Object>{ 'texto' => 'Map Data Lake Objects to Data Model Objects','correta' => false, 'exp' => 'O mapeamento de DLOs para DMOs acontece após a criação dos Data Streams, não como primeiro passo.' }
        }
    },
    new Map<String, Object>{
        'code'      => 'SM017',
        'name'      => 'Simulado - SM017',
        'enunc'     => 'Após a verificação do provisionamento, qual é a próxima etapa lógica para começar a trazer dados de clientes para a plataforma?',
        'subTopico' => 'Conectores e Ingestão',
        'dominio'   => domIngestion,
        'topico'    => topIngestion,
        'alts'      => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'Create a Calculated Insight',                                  'correta' => false, 'exp' => 'Calculated Insights dependem de dados já ingeridos e mapeados; não é possível criá-los antes de estabelecer conexões de dados.' },
            new Map<String, Object>{ 'texto' => 'Define Match Rules for Identity',                              'correta' => false, 'exp' => 'Match Rules são configuradas na etapa de Identity Resolution, que ocorre depois que os dados já foram ingeridos e modelados.' },
            new Map<String, Object>{ 'texto' => 'Criar o Contact data stream via Salesforce CRM Connector',    'correta' => true,  'exp' => 'O segundo passo prático envolve estabelecer a conexão de dados, utilizando o Salesforce CRM Connector para criar o Data Stream referente ao objeto Contact.' },
            new Map<String, Object>{ 'texto' => 'Configure an Activation Target for Marketing Cloud',          'correta' => false, 'exp' => 'Activation Targets são configurados apenas após a criação de segmentos, que por sua vez dependem de dados ingeridos e unificados.' }
        }
    },
    new Map<String, Object>{
        'code'      => 'SM018',
        'name'      => 'Simulado - SM018',
        'enunc'     => 'Ao utilizar um Sales Bundle através do Salesforce CRM Connector, qual é a principal vantagem oferecida pela plataforma?',
        'subTopico' => 'Ingestão com Bundles',
        'dominio'   => domIngestion,
        'topico'    => topIngestion,
        'alts'      => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'Ele limita a ingestão apenas aos objetos Account e Contact',                                                          'correta' => false, 'exp' => 'Bundles incluem vários objetos relacionados, não apenas Account e Contact. Limitar seria o oposto da vantagem real dos bundles.' },
            new Map<String, Object>{ 'texto' => 'Ele aumenta a velocidade de processamento dos Calculated Insights',                                                   'correta' => false, 'exp' => 'Bundles não afetam diretamente a velocidade de processamento de Calculated Insights, que dependem de volume e complexidade dos dados.' },
            new Map<String, Object>{ 'texto' => 'Ele ingere um conjunto de objetos relacionados com campos e relacionamentos padrão pré-configurados',                 'correta' => true,  'exp' => 'O uso de bundles facilita a configuração inicial ao trazer objetos que normalmente trabalham juntos (como Account, Contact e Lead) com seus mapeamentos e relações já definidos.' },
            new Map<String, Object>{ 'texto' => 'Ele criptografa automaticamente os dados sensíveis na origem',                                                        'correta' => false, 'exp' => 'Bundles não são um mecanismo de segurança ou criptografia. Eles simplificam configuração de ingestão de objetos relacionados.' }
        }
    },
    new Map<String, Object>{
        'code'      => 'SM019',
        'name'      => 'Simulado - SM019',
        'enunc'     => 'Quando você precisa ingerir um objeto que não faz parte de um Standard Bundle, qual opção deve ser selecionada no Salesforce CRM Connector?',
        'subTopico' => 'Ingestão de Objetos Específicos',
        'dominio'   => domIngestion,
        'topico'    => topIngestion,
        'alts'      => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'Create from Bundle',        'correta' => false, 'exp' => 'Create from Bundle é usado justamente para objetos que fazem parte de um conjunto pré-definido. Para objetos fora dos bundles, é necessária outra abordagem.' },
            new Map<String, Object>{ 'texto' => 'All Objects',               'correta' => true,  'exp' => 'Ao selecionar "All Objects", você pode escolher qualquer objeto específico (Standard ou Custom) que o usuário de integração tenha permissão para visualizar, sem depender de um conjunto pré-definido.' },
            new Map<String, Object>{ 'texto' => 'Custom API Ingestion',      'correta' => false, 'exp' => 'Custom API Ingestion é para dados externos via API, não para objetos do Salesforce CRM disponíveis pelo conector nativo.' },
            new Map<String, Object>{ 'texto' => 'Schema Auto-Discovery',     'correta' => false, 'exp' => 'Schema Auto-Discovery não é uma opção de seleção no Salesforce CRM Connector para objetos não incluídos em bundles.' }
        }
    },
    new Map<String, Object>{
        'code'      => 'SM020',
        'name'      => 'Simulado - SM020',
        'enunc'     => 'Ao configurar um Data Stream para um objeto customizado, qual etapa é obrigatória para que os dados possam ser usados na unificação de perfis?',
        'subTopico' => 'Configuração de Data Streams Manuais',
        'dominio'   => domIngestion,
        'topico'    => topTransformacao,
        'alts'      => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'O objeto deve ser convertido em um Standard Bundle',                                                    'correta' => false, 'exp' => 'Objetos customizados não precisam ser convertidos em Standard Bundles. O mapeamento manual é suficiente para viabilizar a unificação.' },
            new Map<String, Object>{ 'texto' => 'Mapear os campos do DLO para os atributos correspondentes em um Data Model Object (DMO)',               'correta' => true,  'exp' => 'Diferente dos bundles, que já trazem o mapeamento pronto, objetos selecionados individualmente exigem mapeamento manual do DLO para o DMO para que o Data Cloud entenda como usar esses dados.' },
            new Map<String, Object>{ 'texto' => 'Ativar o campo Primary Key diretamente na origem do CRM',                                              'correta' => false, 'exp' => 'O campo Primary Key é definido na configuração do Data Stream dentro do Data Cloud, não na origem do CRM.' },
            new Map<String, Object>{ 'texto' => 'Criar um Calculated Insight antes da ingestão',                                                        'correta' => false, 'exp' => 'Calculated Insights são criados após a ingestão e mapeamento dos dados, não como pré-requisito para a configuração do Data Stream.' }
        }
    },
    new Map<String, Object>{
        'code'      => 'SM021',
        'name'      => 'Simulado - SM021',
        'enunc'     => 'Durante a criação de um Data Stream via All Objects, o que define a unicidade dos registros dentro do Data Cloud para aquele objeto específico?',
        'subTopico' => 'Identificação de Dados na Ingestão',
        'dominio'   => domIngestion,
        'topico'    => topIngestion,
        'alts'      => new List<Map<String, Object>>{
            new Map<String, Object>{ 'texto' => 'O nome da categoria do Data Stream',                                  'correta' => false, 'exp' => 'O nome da categoria é apenas uma classificação organizacional e não define unicidade de registros no Data Lake Object.' },
            new Map<String, Object>{ 'texto' => 'A seleção do campo que servirá como Primary Key no schema do DLO',   'correta' => true,  'exp' => 'Na configuração manual, você deve garantir que o campo correto seja identificado como Primary Key para evitar duplicidade de dados brutos dentro do Data Lake Object.' },
            new Map<String, Object>{ 'texto' => 'A data de modificação do registro no Salesforce CRM',                'correta' => false, 'exp' => 'A data de modificação é usada para controle de sincronização incremental, não para definir unicidade de registros no DLO.' },
            new Map<String, Object>{ 'texto' => 'O mapeamento automático para o Cloud Information Model',              'correta' => false, 'exp' => 'O mapeamento para o CIM ocorre após a definição do DLO e não define unicidade dos registros brutos ingeridos.' }
        }
    }
};

// Verificar existentes
Set<String> codigos = new Set<String>{'SM016','SM017','SM018','SM019','SM020','SM021'};
Map<String, Questao__c> existentes = new Map<String, Questao__c>();
for (Questao__c q : [SELECT Id, CodigoQuestao__c FROM Questao__c WHERE Certificacao__c = :certId AND CodigoQuestao__c IN :codigos]) {
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

    if (rec.Id == null) { qIns.add(rec); } else { qUpd.add(rec); }
}

if (!qIns.isEmpty()) insert qIns;
if (!qUpd.isEmpty()) update qUpd;

// Recarregar IDs
Map<String, Id> codeToId = new Map<String, Id>();
for (Questao__c q : [SELECT Id, CodigoQuestao__c FROM Questao__c WHERE Certificacao__c = :certId AND CodigoQuestao__c IN :codigos]) {
    codeToId.put(q.CodigoQuestao__c, q.Id);
}

// Deletar alternativas antigas e reinserir
Set<Id> qIds = new Set<Id>(codeToId.values());
List<AlternativaQuestao__c> altOld = [SELECT Id FROM AlternativaQuestao__c WHERE Questao__c IN :qIds];
if (!altOld.isEmpty()) delete altOld;

List<AlternativaQuestao__c> altIns = new List<AlternativaQuestao__c>();
for (Map<String, Object> q : questoes) {
    String code = (String) q.get('code');
    if (!codeToId.containsKey(code)) continue;
    Id qId = codeToId.get(code);

    List<Map<String, Object>> alts = (List<Map<String, Object>>) q.get('alts');
    for (Integer i = 0; i < alts.size(); i++) {
        Map<String, Object> a = alts[i];
        altIns.add(new AlternativaQuestao__c(
            Questao__c               = qId,
            OrdemExibicao__c         = i + 1,
            Name                     = ((String) a.get('texto')).left(80),
            Correta__c               = (Boolean) a.get('correta'),
            Ativa__c                 = true,
            ExplicacaoAlternativa__c = (String) a.get('exp')
        ));
    }
}

if (!altIns.isEmpty()) insert altIns;

System.debug('SEED SM016-SM021 OK | Inseridas: ' + qIns.size() + ' | Atualizadas: ' + qUpd.size() + ' | Alternativas: ' + altIns.size());
