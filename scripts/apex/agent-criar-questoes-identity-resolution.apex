String runId = String.valueOf(Datetime.now().getTime());
Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

void putIfExists(SObject rec, String fieldApi, Object value) {
    Map<String, Schema.SObjectField> fm = rec.getSObjectType().getDescribe().fields.getMap();
    if (fm.containsKey(fieldApi) && value != null) rec.put(fieldApi, value);
}

Id certId;
List<SObject> certs = Database.query('SELECT Id, Name FROM Certificacao__c WHERE Name LIKE \'Data Cloud%\' ORDER BY CreatedDate DESC LIMIT 1');
if (certs.isEmpty()) {
    SObject cert = gd.get('Certificacao__c').newSObject();
    putIfExists(cert, 'Name', 'Data Cloud Consultant');
    putIfExists(cert, 'Codigo__c', 'DC-' + runId.right(6));
    putIfExists(cert, 'Descricao__c', 'Certificação base para questões de teste');
    putIfExists(cert, 'Nivel__c', 'Professional');
    putIfExists(cert, 'Ativa__c', true);
    putIfExists(cert, 'OrdemExibicao__c', 1);
    insert cert;
    certId = cert.Id;
} else {
    certId = (Id)certs[0].get('Id');
}

Id dominioId;
List<SObject> dominios = Database.query('SELECT Id, Name FROM DominioCertificacao__c WHERE Certificacao__c = \'' + String.escapeSingleQuotes(String.valueOf(certId)) + '\' AND Name = \'Identity Resolution\' ORDER BY CreatedDate DESC LIMIT 1');
if (dominios.isEmpty()) {
    SObject dominio = gd.get('DominioCertificacao__c').newSObject();
    putIfExists(dominio, 'Name', 'Identity Resolution');
    putIfExists(dominio, 'Certificacao__c', certId);
    putIfExists(dominio, 'Codigo__c', 'IR-' + runId.right(5));
    putIfExists(dominio, 'Descricao__c', 'Domínio para questões de unificação de perfis');
    putIfExists(dominio, 'PesoProva__c', 20);
    putIfExists(dominio, 'Ativo__c', true);
    putIfExists(dominio, 'OrdemExibicao__c', 1);
    insert dominio;
    dominioId = dominio.Id;
} else {
    dominioId = (Id)dominios[0].get('Id');
}

Id topicoId;
List<SObject> topicos = Database.query('SELECT Id, Name FROM Topico__c WHERE DominioCertificacao__c = \'' + String.escapeSingleQuotes(String.valueOf(dominioId)) + '\' AND Name = \'Identity Resolution - Fundamentos\' ORDER BY CreatedDate DESC LIMIT 1');
if (topicos.isEmpty()) {
    SObject topico = gd.get('Topico__c').newSObject();
    putIfExists(topico, 'Name', 'Identity Resolution - Fundamentos');
    putIfExists(topico, 'DominioCertificacao__c', dominioId);
    putIfExists(topico, 'Descricao__c', 'Conceitos e limites de Identity Resolution');
    putIfExists(topico, 'EhTopicoCritico__c', true);
    putIfExists(topico, 'Ativo__c', true);
    putIfExists(topico, 'OrdemExibicao__c', 1);
    insert topico;
    topicoId = topico.Id;
} else {
    topicoId = (Id)topicos[0].get('Id');
}

public class QItem {
    public String codigo;
    public String enunciado;
    public String explicacao;
    public String nivel;
    public List<String> alternativas;
    public Integer correta;
    public QItem(String codigo, String enunciado, String explicacao, String nivel, List<String> alternativas, Integer correta) {
        this.codigo = codigo;
        this.enunciado = enunciado;
        this.explicacao = explicacao;
        this.nivel = nivel;
        this.alternativas = alternativas;
        this.correta = correta;
    }
}

List<QItem> banco = new List<QItem>{
    new QItem(
        'IR-001',
        'No Data Cloud, qual é o objetivo principal do Identity Resolution?',
        'Identity Resolution corresponde ao processo de combinar perfis de origem em um perfil unificado (Unified Profile).',
        'Facil',
        new List<String>{
            'Unificar perfis de origem em um Unified Profile',
            'Criar apenas segmentos de ativação',
            'Executar deduplicação somente em Contact',
            'Substituir os sistemas de origem'
        },
        0
    ),
    new QItem(
        'IR-002',
        'Como as Match Rules funcionam no ruleset de Identity Resolution?',
        'Todos os critérios dentro de uma match rule devem ser verdadeiros; se qualquer match rule for verdadeira, os perfis podem ser vinculados.',
        'Media',
        new List<String>{
            'Qualquer critério de uma mesma regra basta',
            'Todos os critérios de uma regra devem ser verdadeiros; qualquer regra verdadeira pode gerar match',
            'Somente regras com Fuzzy podem gerar match',
            'Match depende apenas de Last Updated'
        },
        1
    ),
    new QItem(
        'IR-003',
        'Em Identity Resolution, qual afirmação sobre Reconciliation Rules é correta?',
        'Reconciliation define valor vencedor para campos unificados, mas não se aplica a Contact Points.',
        'Media',
        new List<String>{
            'Aplica-se normalmente a Contact Point Email e Phone',
            'Escolhe valor único para campos reconciliáveis e não se aplica a contact points',
            'Substitui as match rules',
            'Atualiza os sistemas de origem automaticamente'
        },
        1
    ),
    new QItem(
        'IR-004',
        'Qual é uma boa prática para estabilizar valores de ID em reconciliação?',
        'A documentação recomenda Source Priority para campos de ID, quando aplicável.',
        'Dificil',
        new List<String>{
            'Most Frequent em todos os campos',
            'Last Updated sempre',
            'Source Priority para campos de ID',
            'Fuzzy para campos de ID'
        },
        2
    ),
    new QItem(
        'IR-005',
        'Qual é o limite máximo de Match Rules por ruleset (guidelines)?',
        'Limite indicado: 10 match rules por ruleset.',
        'Facil',
        new List<String>{
            '5',
            '10',
            '20',
            '50'
        },
        1
    ),
    new QItem(
        'IR-006',
        'Qual é o limite máximo de critérios por Match Rule?',
        'Limite indicado: 10 critérios por match rule.',
        'Facil',
        new List<String>{
            '5',
            '8',
            '10',
            '25'
        },
        2
    ),
    new QItem(
        'IR-007',
        'Qual é a frequência máxima de execução agendada por ruleset?',
        'A execução agendada é no máximo uma vez por dia.',
        'Media',
        new List<String>{
            'A cada hora',
            'A cada 6 horas',
            'Uma vez por dia',
            'Sem limite'
        },
        2
    ),
    new QItem(
        'IR-008',
        'Qual é o limite de jobs de ruleset em qualquer janela de 24h?',
        'Limite indicado: 4 jobs por ruleset por data space em 24h.',
        'Media',
        new List<String>{
            '2',
            '4',
            '10',
            '24'
        },
        1
    ),
    new QItem(
        'IR-009',
        'Qual é o limite máximo de source profiles unificados em um único unified profile?',
        'Limite indicado: 50.000 source profiles por unified profile.',
        'Dificil',
        new List<String>{
            '5.000',
            '10.000',
            '50.000',
            '100.000'
        },
        2
    ),
    new QItem(
        'IR-010',
        'Qual o tamanho máximo de source record processado por ruleset?',
        'Registros maiores que 15 KB podem ser ignorados no processamento.',
        'Dificil',
        new List<String>{
            '10 KB',
            '15 KB',
            '50 KB',
            '200 KB'
        },
        1
    ),
    new QItem(
        'IR-011',
        'Sobre o Ruleset ID, qual afirmação está correta?',
        'Ruleset ID é opcional, até 4 caracteres, e passa a compor nomes/API dos objetos resultantes.',
        'Media',
        new List<String>{
            'É obrigatório e pode ser alterado depois',
            'É opcional, até 4 caracteres, e não pode ser alterado após criação',
            'Aceita até 10 caracteres',
            'Só existe para Household'
        },
        1
    ),
    new QItem(
        'IR-012',
        'Qual é o papel dos Unified Link Objects no Identity Resolution?',
        'Eles fazem a ponte entre registros de origem e registros unificados, preservando lineage.',
        'Media',
        new List<String>{
            'Substituir os objetos de origem',
            'Apagar históricos antigos',
            'Conectar source objects aos unified objects (bridge/link)',
            'Definir automaticamente segmentos de ativação'
        },
        2
    )
};

List<SObject> questoes = new List<SObject>();
for (Integer i = 0; i < banco.size(); i++) {
    QItem q = banco[i];
    SObject qRec = gd.get('Questao__c').newSObject();
    putIfExists(qRec, 'Name', q.codigo + '-' + runId.right(6));
    putIfExists(qRec, 'CodigoInterno__c', q.codigo + '-' + runId);
    putIfExists(qRec, 'Certificacao__c', certId);
    putIfExists(qRec, 'DominioPrincipal__c', dominioId);
    putIfExists(qRec, 'TopicoPrincipal__c', topicoId);
    putIfExists(qRec, 'Enunciado__c', q.enunciado);
    putIfExists(qRec, 'TipoQuestao__c', 'MultiplaEscolha');
    putIfExists(qRec, 'NivelDificuldade__c', q.nivel);
    putIfExists(qRec, 'ExplicacaoResposta__c', q.explicacao);
    putIfExists(qRec, 'Fonte__c', 'Agente Questoes - URL');
    putIfExists(qRec, 'FonteURL__c', 'https://help.salesforce.com/s/articleView?id=data.c360_a_identity_resolution.htm&type=5');
    putIfExists(qRec, 'OrigemConteudo__c', 'Adaptado');
    putIfExists(qRec, 'StatusPublicacao__c', 'Publicado');
    putIfExists(qRec, 'Ativa__c', true);
    putIfExists(qRec, 'PossuiMidia__c', false);
    putIfExists(qRec, 'DataUltimaRevisaoConteudo__c', Date.today());
    putIfExists(qRec, 'DataCriacao__c', System.now());
    questoes.add(qRec);
}
insert questoes;

List<SObject> alternativas = new List<SObject>();
List<String> altLabels = new List<String>{'A','B','C','D','E','F'};
for (Integer i = 0; i < banco.size(); i++) {
    QItem q = banco[i];
    for (Integer a = 0; a < q.alternativas.size(); a++) {
        SObject aRec = gd.get('AlternativaQuestao__c').newSObject();
        putIfExists(aRec, 'Name', altLabels[a]);
        putIfExists(aRec, 'Questao__c', (Id)questoes[i].get('Id'));
        putIfExists(aRec, 'TextoAlternativa__c', q.alternativas[a]);
        putIfExists(aRec, 'Correta__c', (a == q.correta));
        putIfExists(aRec, 'AlternativaCorreta__c', (a == q.correta));
        putIfExists(aRec, 'ExplicacaoAlternativa__c', (a == q.correta ? 'Alternativa correta.' : 'Alternativa incorreta.'));
        putIfExists(aRec, 'OrdemExibicao__c', a + 1);
        putIfExists(aRec, 'Ativa__c', true);
        alternativas.add(aRec);
    }
}
insert alternativas;

System.debug('QUESTOES_CRIADAS=' + questoes.size() + '; ALTERNATIVAS_CRIADAS=' + alternativas.size() + '; RUN_ID=' + runId);