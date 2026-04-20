// Questões baseadas nos 11 exercícios do workshop oficial da Salesforce
// Fonte: https://developer.salesforce.com/workshops/agentforce-new-workshop/data-cloud
// Exercícios 1-11 mapeados para domínios e tópicos da certificação Data 360 Consultant

Certificacao__c cert;
List<Certificacao__c> certs = [SELECT Id, Name FROM Certificacao__c WHERE Name = 'Salesforce Data 360 Consultant' LIMIT 1];
if (certs.isEmpty()) {
    cert = new Certificacao__c(Name = 'Salesforce Data 360 Consultant');
    insert cert;
} else {
    cert = certs[0];
}
Id certId = cert.Id;

// Recarrega domínios existentes
Map<String, DominioCertificacao__c> domByName = new Map<String, DominioCertificacao__c>();
for (DominioCertificacao__c d : [SELECT Id, Name FROM DominioCertificacao__c WHERE Certificacao__c = :cert.Id]) {
    domByName.put(d.Name, d);
}

// Recarrega tópicos existentes
Map<String, Topico__c> topByKey = new Map<String, Topico__c>();
for (Topico__c t : [SELECT Id, Name, DominioCertificacao__r.Name FROM Topico__c WHERE DominioCertificacao__r.Certificacao__c = :cert.Id]) {
    topByKey.put(t.DominioCertificacao__r.Name + '|' + t.Name, t);
}

// Questões baseadas nos exercícios do workshop
// Formato: [dominio, topico, subtopico, name_questao, enunciado, altCorreta, alt2, alt3, alt4, referencia]
List<List<String>> qData = new List<List<String>>{

    // === EXERCÍCIO 1: Ingest Contacts via CRM Connector ===
    new List<String>{
        'Data Source Connection and Ingestion',
        'Ingestão de dados de fontes variadas',
        'Ingestão via CRM Connector e Sales Bundle',
        'WQ001 - Qual conector é usado para ingerir registros de Contact do Salesforc...',
        'Qual conector nativo deve ser utilizado para ingerir registros de Contact do Salesforce CRM diretamente no Data 360 sem necessidade de exportação de arquivos?',
        'Salesforce CRM Connector',
        'Amazon S3 Connector',
        'MuleSoft Connector',
        'REST API Streaming Connector',
        'Ex1 - CRM Connector. Referência: developer.salesforce.com/workshops - Exercise 1.'
    },
    new List<String>{
        'Data Source Connection and Ingestion',
        'Ingestão de dados de fontes variadas',
        'Ingestão via CRM Connector e Sales Bundle',
        'WQ002 - Qual Sales Bundle deve ser selecionado para ingerir Contacts com rel...',
        'Ao criar um Data Stream de Contacts usando o Salesforce CRM Connector, qual bundle de objetos deve ser selecionado para ingerir Account, Contact, Lead, Opportunity Contact Role e User juntos?',
        'Sales Bundle',
        'Service Bundle',
        'Marketing Bundle',
        'Commerce Bundle',
        'Ex1 - Sales Bundle inclui Account, Contact, Lead, OCR e User. Referência: Exercise 1 Step 2.'
    },
    new List<String>{
        'Data Source Connection and Ingestion',
        'Transformação de dados no Data 360',
        'Mapeamento de DLO para DMO no Customer 360 Data Model',
        'WQ003 - A quais DMOs padrão o Contact DLO é mapeado automaticamente?',
        'Após ingerir Contacts via CRM Connector, o Contact DLO é mapeado automaticamente para quais Data Model Objects do Customer 360 Data Model?',
        'Account Contact, Contact Point Address, Contact Point Email, Contact Point Phone e Individual',
        'Individual, Lead, User e Account',
        'Contact Point Email, Contact Point Phone e Opportunity',
        'Individual e Case',
        'Ex1 Step 3 - Contact DLO mapeia para 5 DMOs. Referência: Exercise 1 Step 3.'
    },

    // === EXERCÍCIO 2: Create Amazon S3 Connection ===
    new List<String>{
        'Data Source Connection and Ingestion',
        'Ingestão de dados de fontes variadas',
        'Conexão com Amazon S3 e configuração de credenciais',
        'WQ004 - Onde deve ser configurada uma nova conexão Amazon S3 no Data 360?',
        'Qual caminho no Setup deve ser seguido para criar uma nova conexão Amazon S3 no Data 360?',
        'Data Cloud Setup > Other Connectors > New > Amazon S3',
        'App Manager > Connected Apps > New > Amazon S3',
        'Data Cloud > Data Streams > New > Amazon S3',
        'Integration > Named Credentials > Amazon S3',
        'Ex2 - Conexão é criada em Data Cloud Setup > Other Connectors. Referência: Exercise 2.'
    },
    new List<String>{
        'Data Source Connection and Ingestion',
        'Ingestão de dados de fontes variadas',
        'Conexão com Amazon S3 e configuração de credenciais',
        'WQ005 - Qual método de autenticação é padrão ao criar conexão Amazon S3 no D...',
        'Ao criar uma nova conexão Amazon S3 no Data 360, qual opção de autenticação é apresentada como padrão?',
        'Access Key / Secret Based',
        'OAuth 2.0 Authorization Code',
        'JWT Bearer Token',
        'IAM Role Federation',
        'Ex2 - Autenticação padrão é Access Key/Secret. Referência: Exercise 2.'
    },

    // === EXERCÍCIO 3: Ingest Customers from Amazon S3 ===
    new List<String>{
        'Data Source Connection and Ingestion',
        'Ingestão de dados de fontes variadas',
        'Categoria de DLO e configuração de propriedades',
        'WQ006 - Qual categoria deve ser definida no DLO de clientes ingeridos do Ama...',
        'Ao criar um Data Stream para ingerir dados de clientes (Customer Accounts) do Amazon S3, qual Category deve ser definida para o Data Lake Object?',
        'Profile',
        'Engagement',
        'Transaction',
        'Other',
        'Ex3 Step 1 - Category = Profile para dados de clientes. Referência: Exercise 3 Step 1.'
    },
    new List<String>{
        'Harmonization and Unification',
        'Modelagem de dados no Data 360',
        'Mapeamento de fontes externas ao Customer 360 Data Model',
        'WQ007 - Quais DMOs devem ser selecionados ao mapear o DLO Customer Accounts ...',
        'No mapeamento do DLO Customer Accounts (Amazon S3) ao Customer 360 Data Model, quais Data Model Objects devem ser selecionados?',
        'Individual e Contact Point Email',
        'Account e Lead',
        'Contact Point Phone e User',
        'Case e Opportunity',
        'Ex3 Step 2 - Individual e Contact Point Email são os DMOs corretos. Referência: Exercise 3 Step 2.'
    },
    new List<String>{
        'Harmonization and Unification',
        'Modelagem de dados no Data 360',
        'Mapeamento de fontes externas ao Customer 360 Data Model',
        'WQ008 - Como o campo Customer Id do S3 deve ser mapeado no Contact Point Ema...',
        'Ao mapear o DLO Customer Accounts para o Contact Point Email DMO, para quais campos do DMO o Customer Id deve ser mapeado?',
        'Contact Point Email Id e Party',
        'Somente Email Address',
        'Individual Id e First Name',
        'Data Source Id e Last Name',
        'Ex3 Step 2 - Customer Id mapeia para Contact Point Email Id e Party. Referência: Exercise 3 Step 2.'
    },

    // === EXERCÍCIO 4: Ingest Orders from Amazon S3 ===
    new List<String>{
        'Harmonization and Unification',
        'Modelagem de dados no Data 360',
        'Criação de objetos customizados no Data Model',
        'WQ009 - O que deve ser feito quando o Customer 360 Data Model não tem um DMO...',
        'Ao ingerir pedidos (Orders) do Amazon S3, o Customer 360 Data Model não possui um objeto padrão para representar pedidos. Qual é a abordagem correta?',
        'Criar um Custom Data Model Object com base no DLO de Orders',
        'Usar o objeto Case do CRM como proxy',
        'Criar um campo customizado no objeto Individual',
        'Carregar os dados apenas no DLO sem mapear para DMO',
        'Ex4 Step 2 - Custom DMO deve ser criado quando não existe DMO padrão. Referência: Exercise 4 Step 2.'
    },
    new List<String>{
        'Harmonization and Unification',
        'Modelagem de dados no Data 360',
        'Criação de objetos customizados no Data Model',
        'WQ010 - Qual cardinalidade deve ser configurada no relacionamento Order-Indi...',
        'Ao criar o relacionamento entre o objeto Order (custom DMO) e o objeto Individual no Data Model, qual cardinalidade deve ser configurada?',
        'N:1 — múltiplos pedidos para um único Individual',
        '1:1 — um pedido para um único Individual',
        '1:N — um pedido para múltiplos Individuals',
        'N:N — múltiplos pedidos para múltiplos Individuals',
        'Ex4 Step 3 - N:1 pois muitos pedidos pertencem a um cliente. Referência: Exercise 4 Step 3.'
    },
    new List<String>{
        'Data Source Connection and Ingestion',
        'Ingestão de dados de fontes variadas',
        'Categoria de DLO e configuração de propriedades',
        'WQ011 - Qual categoria deve ser definida para um DLO de pedidos (Orders) no ...',
        'Ao configurar o Data Stream para ingestão de pedidos (Orders) do Amazon S3, qual Category deve ser definida para representar dados transacionais de engajamento?',
        'Engagement',
        'Profile',
        'Transaction',
        'Other',
        'Ex4 Step 1 - Category = Engagement para eventos/pedidos. Referência: Exercise 4 Step 1.'
    },

    // === EXERCÍCIO 5: Create Unified Profile ===
    new List<String>{
        'Harmonization and Unification',
        'Propósito, processo e casos de uso da unificação',
        'Identity Resolution e Data Explorer',
        'WQ012 - Qual ferramenta do Data Cloud permite explorar e filtrar registros e...',
        'Qual ferramenta nativa do Data Cloud permite consultar e filtrar registros de Data Model Objects, como o Individual, para identificar perfis duplicados antes da unificação?',
        'Data Explorer',
        'Data Streams Monitor',
        'Salesforce Reports',
        'Query Editor do Apex',
        'Ex5 Step 1 - Data Explorer serve para consultar DMOs. Referência: Exercise 5 Step 1.'
    },
    new List<String>{
        'Harmonization and Unification',
        'Propósito, processo e casos de uso da unificação',
        'Identity Resolution e Data Explorer',
        'WQ013 - Qual técnica de match rule une perfis com pequenas variações de graf...',
        'Ao configurar o Identity Resolution Ruleset, qual Match Rule deve ser aplicada para unificar registros com pequenas variações no nome (ex: "Alex" vs "Alexander")?',
        'Fuzzy Name',
        'Exact Match Name',
        'Normalized Email',
        'Phone Normalization',
        'Ex5 Step 2 - Fuzzy Name trata variações de grafia no nome. Referência: Exercise 5 Step 2.'
    },
    new List<String>{
        'Harmonization and Unification',
        'Propósito, processo e casos de uso da unificação',
        'Identity Resolution e Data Explorer',
        'WQ014 - Onde ficam disponíveis os perfis unificados após a execução do Ident...',
        'Após a execução bem-sucedida de um Identity Resolution Ruleset, em qual objeto do Data Model os perfis unificados podem ser consultados?',
        'Unified Individual (ex: Unified Individual ccid)',
        'No DLO Individual original',
        'No objeto Contact do CRM',
        'No Segment Member',
        'Ex5 Step 3 - Perfis unificados ficam em Unified Individual ccid. Referência: Exercise 5 Step 3.'
    },

    // === EXERCÍCIO 6: Access Unified Data from Salesforce ===
    new List<String>{
        'Data Enhancements, Sharing, and Analysis',
        'Referenciamento de dados do Data 360 em outros sistemas',
        'Data Cloud Related List e Dynamic Related List',
        'WQ015 - Qual recurso permite exibir dados de Orders do Data 360 na página de...',
        'Qual recurso do Data 360 deve ser configurado para exibir uma lista relacionada de pedidos diretamente na página de registro do Contact no Salesforce CRM?',
        'Data Cloud Related List',
        'Custom Report Embedded',
        'Lookup Relationship Field',
        'Platform Event Listener',
        'Ex6 Step 1 - Data Cloud Related List conecta DMO ao layout do Contact. Referência: Exercise 6 Step 1.'
    },
    new List<String>{
        'Data Enhancements, Sharing, and Analysis',
        'Referenciamento de dados do Data 360 em outros sistemas',
        'Data Cloud Related List e Dynamic Related List',
        'WQ016 - O que acontece se nenhum filtro for configurado em uma Dynamic Relat...',
        'Ao adicionar uma Dynamic Related List de Orders na página do Contact, qual é o comportamento padrão se nenhum filtro for configurado?',
        'Apenas os dados dos últimos 7 dias são exibidos',
        'Todos os registros históricos são exibidos sem limite',
        'Somente registros do usuário atual são exibidos',
        'Nenhum dado é exibido até ativar o Identity Resolution',
        'Ex6 Step 3 - Sem filtro, apenas últimos 7 dias são exibidos. Referência: Exercise 6 Step 3.'
    },

    // === EXERCÍCIO 7: Calculated Insights ===
    new List<String>{
        'Data Enhancements, Sharing, and Analysis',
        'Enriquecimento de dados e construção de insights',
        'Calculated Insights Builder e métricas de agregação',
        'WQ017 - Qual função de métrica deve ser usada para calcular o total de pedid...',
        'No Calculated Insights Builder, ao criar a métrica Lifetime Orders (total de pedidos de um cliente), qual Metric Function deve ser selecionada?',
        'Count',
        'Sum',
        'Average',
        'Max',
        'Ex7 Step 2 - Count sobre Order Id calcula o número total de pedidos. Referência: Exercise 7 Step 2.'
    },
    new List<String>{
        'Data Enhancements, Sharing, and Analysis',
        'Enriquecimento de dados e construção de insights',
        'Calculated Insights Builder e métricas de agregação',
        'WQ018 - Qual função de métrica deve ser usada para calcular o valor total ga...',
        'No Calculated Insights Builder, ao criar a métrica Lifetime Value (soma do valor total de todos os pedidos de um cliente), qual Metric Function deve ser selecionada?',
        'Sum sobre o campo Total Amount',
        'Count sobre o campo Order Id',
        'Average sobre o campo Order Total',
        'Min sobre o campo Order Date',
        'Ex7 Step 3 - Sum sobre Total Amount calcula o Lifetime Value. Referência: Exercise 7 Step 3.'
    },
    new List<String>{
        'Data Enhancements, Sharing, and Analysis',
        'Enriquecimento de dados e construção de insights',
        'Calculated Insights Builder e métricas de agregação',
        'WQ019 - O que representa uma Dimension no Calculated Insights Builder?',
        'No Calculated Insights Builder, qual é o papel de um elemento do tipo Dimension na definição de um Calculated Insight?',
        'O campo pelo qual os dados são agrupados (ex: Unified Individual Id)',
        'O filtro de datas aplicado aos registros',
        'A fonte de dados de origem (ex: S3 ou CRM)',
        'O campo de saída calculado pela métrica',
        'Ex7 Step 4 - Dimension define o agrupamento dos dados. Referência: Exercise 7 Step 4.'
    },

    // === EXERCÍCIO 8: Access Calculated Insights from Salesforce ===
    new List<String>{
        'Data Enhancements, Sharing, and Analysis',
        'Referenciamento de dados do Data 360 em outros sistemas',
        'CRM Enrichment e Data Cloud Copy Field',
        'WQ020 - Qual recurso copia valores de Calculated Insights do Data 360 para c...',
        'Para disponibilizar os valores de Lifetime Orders e Lifetime Value (calculados no Data 360) diretamente em campos do objeto Contact no CRM, qual recurso deve ser configurado?',
        'Data Cloud Copy Field (CRM Enrichment)',
        'Data Stream de retorno',
        'Outbound Message',
        'Platform Event com Apex Trigger',
        'Ex8 Step 3 - Data Cloud Copy Field copia CI para campos CRM. Referência: Exercise 8 Step 3.'
    },
    new List<String>{
        'Data 360 Setup and Administration',
        'Permissões e configurações organizacionais',
        'Permission Sets e Data Cloud Enrichment',
        'WQ021 - Qual Permission Set deve ser modificado para habilitar a escrita de ...',
        'Para que o Data Cloud Copy Field consiga gravar valores nos campos Lifetime_Orders__c e Lifetime_Value__c do objeto Contact, qual Permission Set deve ter as permissões de edição habilitadas?',
        'Customer 360 Data Platform Integration',
        'Data Cloud Admin',
        'System Administrator',
        'CRM Analytics Admin',
        'Ex8 Step 1 - Customer 360 Data Platform Integration precisa de Modify All em Contacts. Referência: Exercise 8 Step 1.'
    },

    // === EXERCÍCIO 9: Analyze Data Cloud Data in Reports ===
    new List<String>{
        'Data Enhancements, Sharing, and Analysis',
        'Relatórios e dashboards com Data 360',
        'Criação de relatórios com dados do Data Cloud',
        'WQ022 - Qual categoria de tipo de relatório deve ser selecionada para criar ...',
        'Ao criar um novo relatório no Salesforce que utilize dados do Data 360, qual categoria de Report Type deve ser selecionada?',
        'Data Cloud',
        'CRM Analytics',
        'Custom Report Types',
        'Standard Salesforce Reports',
        'Ex9 Step 1 - Categoria Data Cloud expõe tipos de relatório do Data 360. Referência: Exercise 9 Step 1.'
    },
    new List<String>{
        'Data Enhancements, Sharing, and Analysis',
        'Relatórios e dashboards com Data 360',
        'Fórmulas de linha em relatórios do Data Cloud',
        'WQ023 - Qual fórmula calcula os dias decorridos desde a data de um pedido em...',
        'Em um relatório do Data 360 com dados de Orders, qual fórmula de linha deve ser usada para calcular quantos dias se passaram desde a data do pedido até hoje?',
        'TODAY() - DATEVALUE(Orders__dlm.Order_Date__c)',
        'DATEDIFF(TODAY(), Orders__dlm.Order_Date__c)',
        'NOW() - Orders__dlm.Order_Date__c',
        'DAYS_BETWEEN(Orders__dlm.Order_Date__c, TODAY())',
        'Ex9 Step 2 - TODAY() - DATEVALUE() é a fórmula correta. Referência: Exercise 9 Step 2.'
    },

    // === EXERCÍCIO 10: Query Data 360 Data in a Flow ===
    new List<String>{
        'Data Activations and Utilization',
        'Uso do Data 360 em Salesforce Flows',
        'Get Records com Data Cloud Object no Flow Builder',
        'WQ024 - Qual Data Source deve ser selecionada ao consultar dados do Data 360...',
        'Em um Salesforce Flow, ao configurar um elemento Get Records para buscar dados de pedidos do Data 360, qual opção de Data Source deve ser selecionada?',
        'Data Cloud Object',
        'Salesforce Object',
        'External Object',
        'Custom Metadata Type',
        'Ex10 Step 1 - Data Cloud Object é a fonte correta para DMOs do Data 360. Referência: Exercise 10 Step 1.'
    },
    new List<String>{
        'Data Activations and Utilization',
        'Uso do Data 360 em Salesforce Flows',
        'Screen Flow e Quick Action para contexto de atendimento',
        'WQ025 - Qual combinação de recursos disponibiliza um Flow com dados do Data ...',
        'Para que agentes de suporte possam consultar dados do Data 360 diretamente na página de um Case, qual combinação de recursos deve ser configurada?',
        'Screen Flow + Quick Action + Highlights Panel',
        'Schedule-Triggered Flow + Salesforce Object',
        'Record-Triggered Flow + Platform Event',
        'Auto-Launched Flow + External Object',
        'Ex10 Steps 1-3 - Screen Flow com Quick Action adicionada ao Highlights Panel. Referência: Exercise 10.'
    },

    // === EXERCÍCIO 11: Access Data 360 with SOQL ===
    new List<String>{
        'Data Enhancements, Sharing, and Analysis',
        'Relatórios e dashboards com Data 360',
        'SOQL em DMOs do Data Cloud',
        'WQ026 - Qual sufixo de objeto deve ser utilizado em queries SOQL para acessa...',
        'Ao escrever uma query SOQL para acessar objetos do Data Model do Data 360 (como Individual ou Orders), qual sufixo deve ser utilizado no nome do objeto?',
        '__dlm (ex: ssot__Individual__dlm)',
        '__c (ex: ssot__Individual__c)',
        '__mdt (ex: ssot__Individual__mdt)',
        '__r (ex: ssot__Individual__r)',
        'Ex11 - DMOs do Data 360 usam sufixo __dlm. Referência: Exercise 11.'
    },
    new List<String>{
        'Data Enhancements, Sharing, and Analysis',
        'Relatórios e dashboards com Data 360',
        'SOQL em DMOs do Data Cloud',
        'WQ027 - Qual ferramenta do Salesforce permite executar queries SOQL contra D...',
        'Em qual ferramenta do ecossistema Salesforce é possível escrever e executar queries SOQL diretamente contra Data Model Objects (DMOs) do Data 360?',
        'Code Builder com SFDX: Execute SOQL Query',
        'Salesforce Developer Console',
        'Flow Builder com Formula Element',
        'Report Builder com Custom Formula',
        'Ex11 - Code Builder + SFDX Execute SOQL Query. Referência: Exercise 11.'
    }
};

// Helpers de schema para update dinâmico
Map<String, Schema.SObjectField> qFields = Schema.SObjectType.Questao__c.fields.getMap();
Boolean hasEnunciado = qFields.containsKey('Enunciado__c');
Boolean hasSubtopico = qFields.containsKey('Subtopico__c');
Boolean hasCodigo = qFields.containsKey('CodigoInterno__c');

// Carrega questões existentes para migração e idempotência
Map<String, Questao__c> qByCodigo = new Map<String, Questao__c>();
Map<String, Questao__c> qByLegacyWQ = new Map<String, Questao__c>();
Map<String, Questao__c> qByEnunciado = new Map<String, Questao__c>();

List<String> qLoadFields = new List<String>{ 'Id', 'Name' };
if (hasCodigo) qLoadFields.add('CodigoInterno__c');
if (hasEnunciado) qLoadFields.add('Enunciado__c');
String qLoadSoql = 'SELECT ' + String.join(qLoadFields, ', ')
    + ' FROM Questao__c WHERE Certificacao__c = :certId';
for (SObject sob : Database.query(qLoadSoql)) {
    Questao__c q = (Questao__c) sob;
    if (hasCodigo && !String.isBlank((String) q.get('CodigoInterno__c'))) {
        qByCodigo.put((String) q.get('CodigoInterno__c'), q);
    }
    if (q.Name != null && q.Name.startsWith('WQ') && q.Name.length() >= 5) {
        qByLegacyWQ.put('WK' + q.Name.substring(2, 5), q);
    } else if (q.Name != null && q.Name.startsWith('Workshop WK') && q.Name.length() >= 12) {
        qByLegacyWQ.put(q.Name.substring(9, 14), q); // WK001
    }
    if (hasEnunciado && !String.isBlank((String) q.get('Enunciado__c'))) {
        qByEnunciado.put((String) q.get('Enunciado__c'), q);
    }
}

List<Questao__c> qIns = new List<Questao__c>();
List<Questao__c> qUpd = new List<Questao__c>();

for (List<String> row : qData) {
    String dom = row[0], top = row[1], sub = row[2], legacyWqName = row[3], enunciadoCompleto = row[4];
    String code = legacyWqName != null && legacyWqName.startsWith('WQ') && legacyWqName.length() >= 5
        ? 'WK' + legacyWqName.substring(2, 5)
        : null;

    // Name curto para não truncar pergunta (sem prefixo WQ)
    String nomeQuestao = 'Workshop - ' + sub;
    if (nomeQuestao.length() > 80) {
        nomeQuestao = nomeQuestao.left(80);
    }

    String topKey = dom + '|' + top;
    if (!(domByName.containsKey(dom) && topByKey.containsKey(topKey))) {
        System.debug('AVISO: domínio ou tópico não encontrado: ' + topKey);
        continue;
    }

    Questao__c existing = null;
    if (!String.isBlank(code) && qByCodigo.containsKey(code)) {
        existing = qByCodigo.get(code);
    } else if (!String.isBlank(code) && qByLegacyWQ.containsKey(code)) {
        existing = qByLegacyWQ.get(code);
    } else if (hasEnunciado && qByEnunciado.containsKey(enunciadoCompleto)) {
        existing = qByEnunciado.get(enunciadoCompleto);
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
        if (hasCodigo && !String.isBlank(code)) nova.put('CodigoInterno__c', code);
        if (hasEnunciado) nova.put('Enunciado__c', enunciadoCompleto);
        if (hasSubtopico) nova.put('Subtopico__c', sub);
        qIns.add(nova);
    } else {
        Boolean changed = false;
        if (existing.Name != nomeQuestao) {
            existing.Name = nomeQuestao;
            changed = true;
        }
        if (hasCodigo && !String.isBlank(code) && (String) existing.get('CodigoInterno__c') != code) {
            existing.put('CodigoInterno__c', code);
            changed = true;
        }
        if (hasEnunciado) {
            existing.put('Enunciado__c', enunciadoCompleto);
            changed = true;
        }
        if (hasSubtopico) {
            existing.put('Subtopico__c', sub);
            changed = true;
        }
        if (changed) qUpd.add(existing);
    }
}

if (!qIns.isEmpty()) insert qIns;
if (!qUpd.isEmpty()) update qUpd;

// Recarrega mapa por código após inserts/updates
qByCodigo.clear();
qByEnunciado.clear();
for (SObject sob : Database.query(qLoadSoql)) {
    Questao__c q = (Questao__c) sob;
    if (hasCodigo && !String.isBlank((String) q.get('CodigoInterno__c'))) {
        qByCodigo.put((String) q.get('CodigoInterno__c'), q);
    } else if (q.Name != null && q.Name.startsWith('WQ') && q.Name.length() >= 5) {
        qByCodigo.put('WK' + q.Name.substring(2, 5), q);
    } else if (q.Name != null && q.Name.startsWith('Workshop WK') && q.Name.length() >= 12) {
        qByCodigo.put(q.Name.substring(9, 14), q); // WK001
    }
    if (hasEnunciado && !String.isBlank((String) q.get('Enunciado__c'))) {
        qByEnunciado.put((String) q.get('Enunciado__c'), q);
    }
}

// Limpa alternativas existentes para as questões do workshop (idempotente)
Set<Id> qIds = new Set<Id>();
for (List<String> row : qData) {
    String legacyWqName = row[3];
    String code = legacyWqName != null && legacyWqName.startsWith('WQ') && legacyWqName.length() >= 5
        ? 'WK' + legacyWqName.substring(2, 5)
        : null;
    if (!String.isBlank(code) && qByCodigo.containsKey(code)) {
        qIds.add(qByCodigo.get(code).Id);
    } else if (hasEnunciado && qByEnunciado.containsKey(row[4])) {
        qIds.add(qByEnunciado.get(row[4]).Id);
    }
}

List<AlternativaQuestao__c> altOld = [SELECT Id FROM AlternativaQuestao__c WHERE Questao__c IN :qIds];
if (!altOld.isEmpty()) delete altOld;

// Insere alternativas
List<AlternativaQuestao__c> altIns = new List<AlternativaQuestao__c>();
for (List<String> row : qData) {
    String legacyWqName = row[3];
    String code = legacyWqName != null && legacyWqName.startsWith('WQ') && legacyWqName.length() >= 5
        ? 'WK' + legacyWqName.substring(2, 5)
        : null;
    Id qId;
    if (!String.isBlank(code) && qByCodigo.containsKey(code)) {
        qId = qByCodigo.get(code).Id;
    } else if (hasEnunciado && qByEnunciado.containsKey(row[4])) {
        qId = qByEnunciado.get(row[4]).Id;
    } else {
        continue;
    }

    String ref = row[9];
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 1, Name = row[5].left(80), Correta__c = true,  Ativa__c = true, ExplicacaoAlternativa__c = 'Correto. ' + ref));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 2, Name = row[6].left(80), Correta__c = false, Ativa__c = true, ExplicacaoAlternativa__c = 'Incorreto. ' + ref));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 3, Name = row[7].left(80), Correta__c = false, Ativa__c = true, ExplicacaoAlternativa__c = 'Incorreto. ' + ref));
    altIns.add(new AlternativaQuestao__c(Questao__c = qId, OrdemExibicao__c = 4, Name = row[8].left(80), Correta__c = false, Ativa__c = true, ExplicacaoAlternativa__c = 'Incorreto. ' + ref));
}
if (!altIns.isEmpty()) insert altIns;

System.debug('WORKSHOP SEED OK | Questões inseridas: ' + qIns.size() + ' | Questões atualizadas: ' + qUpd.size() + ' | Alternativas: ' + altIns.size());
