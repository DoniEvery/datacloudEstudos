String runId = String.valueOf(Datetime.now().getTime());

// =========================
// 1) Garante Catálogo Base
// =========================
Certificacao__c cert;
List<Certificacao__c> certs = [
    SELECT Id, Name
    FROM Certificacao__c
    WHERE Name = 'Data Cloud Consultant'
    ORDER BY CreatedDate DESC
    LIMIT 1
];
if (certs.isEmpty()) {
    cert = new Certificacao__c(
        Name = 'Data Cloud Consultant',
        Codigo__c = 'DCC',
        Descricao__c = 'Certificação para trilha de estudos Data Cloud',
        Nivel__c = 'Professional',
        Ativa__c = true,
        OrdemExibicao__c = 1
    );
    insert cert;
} else {
    cert = certs[0];
}

DominioCertificacao__c dominio;
List<DominioCertificacao__c> dominios = [
    SELECT Id, Name
    FROM DominioCertificacao__c
    WHERE Certificacao__c = :cert.Id
      AND Name = 'Identity Resolution'
    ORDER BY CreatedDate DESC
    LIMIT 1
];
if (dominios.isEmpty()) {
    dominio = new DominioCertificacao__c(
        Name = 'Identity Resolution',
        Certificacao__c = cert.Id,
        Codigo__c = 'IR',
        Descricao__c = 'Unificação de perfis, match e reconciliação',
        PesoProva__c = 20,
        Ativo__c = true,
        OrdemExibicao__c = 1
    );
    insert dominio;
} else {
    dominio = dominios[0];
}

Topico__c topico;
List<Topico__c> topicos = [
    SELECT Id, Name
    FROM Topico__c
    WHERE DominioCertificacao__c = :dominio.Id
      AND Name = 'Identity Resolution - Questões Oficiais'
    ORDER BY CreatedDate DESC
    LIMIT 1
];
if (topicos.isEmpty()) {
    topico = new Topico__c(
        Name = 'Identity Resolution - Questões Oficiais',
        DominioCertificacao__c = dominio.Id,
        Descricao__c = 'Lote de questões reais sobre match rules e reconciliation rules',
        EhTopicoCritico__c = true,
        Ativo__c = true,
        OrdemExibicao__c = 1
    );
    insert topico;
} else {
    topico = topicos[0];
}

// =========================
// 2) Questões Reais
// =========================
public class Q {
    public String enunciado;
    public String explicacao;
    public String dificuldade;
    public List<String> alternativas;
    public Integer correta;
    public Q(String e, String ex, String d, List<String> a, Integer c) {
        enunciado = e;
        explicacao = ex;
        dificuldade = d;
        alternativas = a;
        correta = c;
    }
}

List<Q> banco = new List<Q>{
    new Q(
        'No Data Cloud, quando um perfil é unificado no Identity Resolution?',
        'Um perfil unificado é criado quando ao menos uma Match Rule ativa é satisfeita, sendo que todos os critérios daquela regra precisam ser verdadeiros.',
        'Facil',
        new List<String>{
            'Quando qualquer critério isolado de qualquer regra for verdadeiro',
            'Quando todos os critérios de uma mesma match rule forem verdadeiros',
            'Somente quando houver regra de reconciliação Source Priority',
            'Apenas em execuções manuais'
        },
        1
    ),
    new Q(
        'Qual é o limite máximo de Match Rules por ruleset em Identity Resolution?',
        'Segundo os limites de Data 360, cada ruleset suporta até 10 match rules.',
        'Media',
        new List<String>{
            '5',
            '10',
            '15',
            '25'
        },
        1
    ),
    new Q(
        'Qual é o limite máximo de critérios por Match Rule?',
        'Cada match rule suporta no máximo 10 critérios.',
        'Facil',
        new List<String>{
            '3',
            '5',
            '10',
            '20'
        },
        2
    ),
    new Q(
        'Em reconciliação, qual regra é mais indicada para estabilizar valores de ID?',
        'A recomendação de documentação é usar Source Priority para campos de ID.',
        'Media',
        new List<String>{
            'Most Frequent',
            'Last Updated',
            'Source Priority',
            'Exact Normalized'
        },
        2
    ),
    new Q(
        'Qual afirmação sobre Reconciliation Rules está correta?',
        'Reconciliation escolhe um valor consolidado para campos unificados e não altera dados de origem.',
        'Media',
        new List<String>{
            'Altera os sistemas de origem para refletir o valor final',
            'Define valor vencedor em campos unificados sem alterar os dados de origem',
            'Aplica-se diretamente aos contact points',
            'Substitui totalmente as match rules'
        },
        1
    ),
    new Q(
        'Qual é a frequência máxima de execução agendada por ruleset?',
        'A execução agendada é no máximo uma vez por dia; também existem limites de jobs em janela de 24h.',
        'Facil',
        new List<String>{
            'A cada hora',
            'A cada 6 horas',
            'Uma vez por dia',
            'Sem limite'
        },
        2
    ),
    new Q(
        'Qual é o limite de jobs de ruleset em qualquer período de 24 horas?',
        'O limite é de 4 jobs por ruleset por data space em 24h.',
        'Dificil',
        new List<String>{
            '2',
            '4',
            '8',
            '24'
        },
        1
    ),
    new Q(
        'Qual é o papel dos Unified Link Objects?',
        'Unified Link Objects conectam registros de origem aos registros unificados para manter rastreabilidade.',
        'Media',
        new List<String>{
            'Substituir os objetos de origem',
            'Conectar source records aos unified records',
            'Armazenar apenas métricas de consolidação',
            'Bloquear regras de reconciliação'
        },
        1
    ),
    new Q(
        'Ao criar um ruleset, qual é a característica do Ruleset ID?',
        'Ruleset ID é opcional, tem até 4 caracteres e vira parte dos nomes/API names dos objetos gerados.',
        'Dificil',
        new List<String>{
            'É obrigatório, até 10 caracteres e editável depois',
            'É opcional, até 4 caracteres e não pode ser alterado após criação',
            'É opcional, sem limite de tamanho',
            'Só existe para Account unification'
        },
        1
    ),
    new Q(
        'No real-time matching, quais métodos de match são usados?',
        'Em tempo real, a documentação indica uso de Exact e Exact Normalized.',
        'Dificil',
        new List<String>{
            'Somente Fuzzy',
            'Exact e Exact Normalized',
            'Source Priority e Last Updated',
            'Most Frequent e Fuzzy'
        },
        1
    )
};

List<Questao__c> questoes = new List<Questao__c>();
for (Integer i = 0; i < banco.size(); i++) {
    Q q = banco[i];
    String cod = 'IR-REAL-' + String.valueOf(i + 1).leftPad(2, '0') + '-' + runId;
    questoes.add(new Questao__c(
        Name = 'IR REAL ' + String.valueOf(i + 1) + ' - ' + runId.right(6),
        CodigoInterno__c = cod,
        Certificacao__c = cert.Id,
        DominioPrincipal__c = dominio.Id,
        TopicoPrincipal__c = topico.Id,
        Enunciado__c = q.enunciado,
        TipoQuestao__c = 'MultiplaEscolha',
        NivelDificuldade__c = q.dificuldade,
        ExplicacaoResposta__c = q.explicacao,
        JustificativaOficial__c = q.explicacao,
        Fonte__c = 'Salesforce Help - Identity Resolution',
        FonteURL__c = 'https://help.salesforce.com/s/articleView?id=data.c360_a_identity_resolution.htm&type=5',
        OrigemConteudo__c = 'Adaptado',
        StatusPublicacao__c = 'Publicado',
        Ativa__c = true,
        PossuiMidia__c = false,
        DataUltimaRevisaoConteudo__c = Date.today(),
        DataCriacao__c = System.now()
    ));
}
insert questoes;

List<String> labels = new List<String>{'A', 'B', 'C', 'D'};
List<AlternativaQuestao__c> alternativas = new List<AlternativaQuestao__c>();
for (Integer i = 0; i < banco.size(); i++) {
    Q q = banco[i];
    for (Integer a = 0; a < q.alternativas.size(); a++) {
        alternativas.add(new AlternativaQuestao__c(
            Name = labels[a],
            Questao__c = questoes[i].Id,
            TextoAlternativa__c = q.alternativas[a],
            Correta__c = (a == q.correta),
            AlternativaCorreta__c = (a == q.correta),
            ExplicacaoAlternativa__c = (a == q.correta ? 'Alternativa correta, conforme documentação.' : 'Alternativa incorreta para este contexto.'),
            OrdemExibicao__c = a + 1,
            Ativa__c = true
        ));
    }
}
insert alternativas;

System.debug('LOTE_REAL_OK | QUESTOES=' + questoes.size() + ' | ALTERNATIVAS=' + alternativas.size() + ' | RUN=' + runId + ' | TOPICO=' + topico.Id);