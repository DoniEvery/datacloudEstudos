// Popula CodigoQuestao__c para questões da certificação Data 360 Consultant
// - Questões originais: Q001..Q022 (derivado do Name quando começa com Q### -)
// - Questões workshop: WK001..WK027 (mapeado por Enunciado__c)

Certificacao__c cert = [
    SELECT Id
    FROM Certificacao__c
    WHERE Name = 'Salesforce Data 360 Consultant'
    LIMIT 1
];

Map<String, Schema.SObjectField> qFields = Schema.SObjectType.Questao__c.fields.getMap();
if (!qFields.containsKey('CodigoQuestao__c')) {
    System.debug('CODIGO SKIPPED | Campo CodigoQuestao__c não disponível.');
    return;
}

Map<String, String> wkByEnunciado = new Map<String, String>{
    'Qual conector nativo deve ser utilizado para ingerir registros de Contact do Salesforce CRM diretamente no Data 360 sem necessidade de exportação de arquivos?' => 'WK001',
    'Ao criar um Data Stream de Contacts usando o Salesforce CRM Connector, qual bundle de objetos deve ser selecionado para ingerir Account, Contact, Lead, Opportunity Contact Role e User juntos?' => 'WK002',
    'Após ingerir Contacts via CRM Connector, o Contact DLO é mapeado automaticamente para quais Data Model Objects do Customer 360 Data Model?' => 'WK003',
    'Qual caminho no Setup deve ser seguido para criar uma nova conexão Amazon S3 no Data 360?' => 'WK004',
    'Ao criar uma nova conexão Amazon S3 no Data 360, qual opção de autenticação é apresentada como padrão?' => 'WK005',
    'Ao criar um Data Stream para ingerir dados de clientes (Customer Accounts) do Amazon S3, qual Category deve ser definida para o Data Lake Object?' => 'WK006',
    'No mapeamento do DLO Customer Accounts (Amazon S3) ao Customer 360 Data Model, quais Data Model Objects devem ser selecionados?' => 'WK007',
    'Ao mapear o DLO Customer Accounts para o Contact Point Email DMO, para quais campos do DMO o Customer Id deve ser mapeado?' => 'WK008',
    'Ao ingerir pedidos (Orders) do Amazon S3, o Customer 360 Data Model não possui um objeto padrão para representar pedidos. Qual é a abordagem correta?' => 'WK009',
    'Ao criar o relacionamento entre o objeto Order (custom DMO) e o objeto Individual no Data Model, qual cardinalidade deve ser configurada?' => 'WK010',
    'Ao configurar o Data Stream para ingestão de pedidos (Orders) do Amazon S3, qual Category deve ser definida para representar dados transacionais de engajamento?' => 'WK011',
    'Qual ferramenta nativa do Data Cloud permite consultar e filtrar registros de Data Model Objects, como o Individual, para identificar perfis duplicados antes da unificação?' => 'WK012',
    'Ao configurar o Identity Resolution Ruleset, qual Match Rule deve ser aplicada para unificar registros com pequenas variações no nome (ex: "Alex" vs "Alexander")?' => 'WK013',
    'Após a execução bem-sucedida de um Identity Resolution Ruleset, em qual objeto do Data Model os perfis unificados podem ser consultados?' => 'WK014',
    'Qual recurso do Data 360 deve ser configurado para exibir uma lista relacionada de pedidos diretamente na página de registro do Contact no Salesforce CRM?' => 'WK015',
    'Ao adicionar uma Dynamic Related List de Orders na página do Contact, qual é o comportamento padrão se nenhum filtro for configurado?' => 'WK016',
    'No Calculated Insights Builder, ao criar a métrica Lifetime Orders (total de pedidos de um cliente), qual Metric Function deve ser selecionada?' => 'WK017',
    'No Calculated Insights Builder, ao criar a métrica Lifetime Value (soma do valor total de todos os pedidos de um cliente), qual Metric Function deve ser selecionada?' => 'WK018',
    'No Calculated Insights Builder, qual é o papel de um elemento do tipo Dimension na definição de um Calculated Insight?' => 'WK019',
    'Para disponibilizar os valores de Lifetime Orders e Lifetime Value (calculados no Data 360) diretamente em campos do objeto Contact no CRM, qual recurso deve ser configurado?' => 'WK020',
    'Para que o Data Cloud Copy Field consiga gravar valores nos campos Lifetime_Orders__c e Lifetime_Value__c do objeto Contact, qual Permission Set deve ter as permissões de edição habilitadas?' => 'WK021',
    'Ao criar um novo relatório no Salesforce que utilize dados do Data 360, qual categoria de Report Type deve ser selecionada?' => 'WK022',
    'Em um relatório do Data 360 com dados de Orders, qual fórmula de linha deve ser usada para calcular quantos dias se passaram desde a data do pedido até hoje?' => 'WK023',
    'Em um Salesforce Flow, ao configurar um elemento Get Records para buscar dados de pedidos do Data 360, qual opção de Data Source deve ser selecionada?' => 'WK024',
    'Para que agentes de suporte possam consultar dados do Data 360 diretamente na página de um Case, qual combinação de recursos deve ser configurada?' => 'WK025',
    'Ao escrever uma query SOQL para acessar objetos do Data Model do Data 360 (como Individual ou Orders), qual sufixo deve ser utilizado no nome do objeto?' => 'WK026',
    'Em qual ferramenta do ecossistema Salesforce é possível escrever e executar queries SOQL diretamente contra Data Model Objects (DMOs) do Data 360?' => 'WK027'
};

List<Questao__c> questoes = [
    SELECT Id, Name, Enunciado__c, CodigoQuestao__c
    FROM Questao__c
    WHERE Certificacao__c = :cert.Id
];

List<Questao__c> toUpdate = new List<Questao__c>();
Integer changed = 0;
Integer semCodigo = 0;

for (Questao__c q : questoes) {
    String novoCodigo;

    // Originais (Q001..Q022)
    if (q.Name != null && q.Name.length() >= 4 && q.Name.startsWith('Q')) {
        String prefix = q.Name.substring(0, 4);
        if (Pattern.matches('Q\\d{3}', prefix)) {
            novoCodigo = prefix;
        }
    }

    // Workshop (WK001..WK027)
    if (novoCodigo == null && !String.isBlank(q.Enunciado__c) && wkByEnunciado.containsKey(q.Enunciado__c)) {
        novoCodigo = wkByEnunciado.get(q.Enunciado__c);
    }

    if (String.isBlank(novoCodigo)) {
        semCodigo++;
        continue;
    }

    if (q.CodigoQuestao__c != novoCodigo) {
        q.CodigoQuestao__c = novoCodigo;
        toUpdate.add(q);
        changed++;
    }
}

if (!toUpdate.isEmpty()) {
    update toUpdate;
}

System.debug('CODIGO QUESTAO OK | Atualizadas: ' + changed + ' | Sem código: ' + semCodigo);
