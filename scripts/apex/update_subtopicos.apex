// Popula Subtopico__c em TODAS as 49 questões (22 originais + 27 workshop)
// Apenas UPDATE — sem insert nem delete

Certificacao__c cert = [SELECT Id FROM Certificacao__c WHERE Name = 'Salesforce Data 360 Consultant' LIMIT 1];

// ── Mapeamento WQxxx (5 chars) → subtópico ──────────────────────────────────
Map<String, String> wqMap = new Map<String, String>{
    'WQ001' => 'Ingestão via CRM Connector e Sales Bundle',
    'WQ002' => 'Ingestão via CRM Connector e Sales Bundle',
    'WQ003' => 'Mapeamento de DLO para DMO no Customer 360 Data Model',
    'WQ004' => 'Conexão com Amazon S3 e configuração de credenciais',
    'WQ005' => 'Conexão com Amazon S3 e configuração de credenciais',
    'WQ006' => 'Categoria de DLO e configuração de propriedades',
    'WQ007' => 'Mapeamento de fontes externas ao Customer 360 Data Model',
    'WQ008' => 'Mapeamento de fontes externas ao Customer 360 Data Model',
    'WQ009' => 'Criação de objetos customizados no Data Model',
    'WQ010' => 'Criação de objetos customizados no Data Model',
    'WQ011' => 'Categoria de DLO e configuração de propriedades',
    'WQ012' => 'Identity Resolution e Data Explorer',
    'WQ013' => 'Identity Resolution e Data Explorer',
    'WQ014' => 'Identity Resolution e Data Explorer',
    'WQ015' => 'Data Cloud Related List e Dynamic Related List',
    'WQ016' => 'Data Cloud Related List e Dynamic Related List',
    'WQ017' => 'Calculated Insights Builder e métricas de agregação',
    'WQ018' => 'Calculated Insights Builder e métricas de agregação',
    'WQ019' => 'Calculated Insights Builder e métricas de agregação',
    'WQ020' => 'CRM Enrichment e Data Cloud Copy Field',
    'WQ021' => 'Permission Sets e Data Cloud Enrichment',
    'WQ022' => 'Criação de relatórios com dados do Data Cloud',
    'WQ023' => 'Fórmulas de linha em relatórios do Data Cloud',
    'WQ024' => 'Get Records com Data Cloud Object no Flow Builder',
    'WQ025' => 'Screen Flow e Quick Action para contexto de atendimento',
    'WQ026' => 'SOQL em DMOs do Data Cloud',
    'WQ027' => 'SOQL em DMOs do Data Cloud'
};

// ── Mapeamento tópico → subtópico (22 questões originais Q001-Q022) ──────────
Map<String, String> topMap = new Map<String, String>{
    'Terminologia e valor de negócio do Data 360'             => 'Proposta de valor e linguagem comum do Data Cloud',
    'Data 360 como base para IA generativa e preditiva'       => 'Contexto de dados para IA (RAG e personalização)',
    'Casos de uso iniciais para Data 360'                     => 'Priorização de quick wins de negócio',
    'Ética e governança de dados'                             => 'Princípios de minimização e uso responsável de dados',
    'Permissões e configurações organizacionais'              => 'Acesso e papéis para administração da plataforma',
    'Governança de dados na configuração da plataforma'       => 'Segregação e segurança com Data Spaces',
    'Ciclo de desenvolvimento e ferramentas disponíveis'      => 'Gestão de mudanças e lifecycle em Data Cloud',
    'Diagnóstico e solução de problemas comuns'               => 'Monitoramento e troubleshooting de ingestão',
    'Transformação de dados no Data 360'                      => 'Regras de mapeamento e transformação DLO para DMO',
    'Ingestão de dados de fontes variadas'                    => 'Padrões de ingestão batch e streaming',
    'Colaboração de dados e Zero-Copy'                        => 'Arquitetura federada sem duplicação de dados',
    'Propósito, processo e casos de uso da unificação'        => 'Identity Resolution e perfil unificado',
    'Modelagem de dados no Data 360'                          => 'Diferenças e papel de DLO, DMO e modelo canônico',
    'Enriquecimento de dados e construção de insights'        => 'Calculated Insights e métricas derivadas',
    'Referenciamento de dados do Data 360 em outros sistemas' => 'Consumo em CRM sem replicação desnecessária',
    'Relatórios e dashboards com Data 360'                    => 'Camadas analíticas nativas e visualização',
    'IA preditiva e generativa no Data 360'                   => 'Modelos no Einstein Studio e uso operacional',
    'Conceitos de segmentação e casos de uso'                 => 'Critérios de audiência sobre Unified Individual',
    'Gerenciamento de segmentos no Data 360'                  => 'Atualização, frequência e governança de segmentos',
    'Publicação de Activations no Data 360'                   => 'Mapeamento de atributos e destinos de ativação',
    'Ação sobre dados'                                        => 'Orquestração orientada a eventos com Data Actions',
    'Uso do Data 360 em Salesforce Flows'                     => 'Consulta em runtime no Flow Builder'
};

List<Questao__c> allQ = [
    SELECT Id, Name, TopicoPrincipal__r.Name
    FROM Questao__c
    WHERE Certificacao__c = :cert.Id
];

List<Questao__c> toUpdate = new List<Questao__c>();
Integer skipped = 0;

for (Questao__c q : allQ) {
    String sub = null;

    if (q.Name != null && q.Name.startsWith('WQ')) {
        // Usa os primeiros 5 chars como chave: 'WQ001', 'WQ002', etc.
        sub = wqMap.get(q.Name.left(5));
    }

    // Questões originais: resolve pelo nome do tópico
    if (sub == null && q.TopicoPrincipal__r.Name != null) {
        sub = topMap.get(q.TopicoPrincipal__r.Name);
    }

    if (sub != null) {
        q.put('Subtopico__c', sub);
        toUpdate.add(q);
    } else if (sub == null) {
        skipped++;
        System.debug('SEM SUBTOPICO: ' + q.Name);
    }
}

if (!toUpdate.isEmpty()) update toUpdate;

System.debug('SUBTOPICO UPDATE OK | Atualizadas: ' + toUpdate.size() + ' | Sem mapeamento: ' + skipped);
