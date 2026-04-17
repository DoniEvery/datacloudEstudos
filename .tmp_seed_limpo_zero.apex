String fieldApiIgnoreCase(Schema.SObjectType t, String wanted) {
    for (String f : t.getDescribe().fields.getMap().keySet()) {
        if (f.toLowerCase() == wanted.toLowerCase()) return f;
    }
    return null;
}

void putIfExists(SObject rec, String preferredField, Object value) {
    if (value == null) return;
    String real = fieldApiIgnoreCase(rec.getSObjectType(), preferredField);
    if (real != null) rec.put(real, value);
}

Object pickVal(Schema.SObjectType t, String fieldApi, List<String> preferred) {
    String real = fieldApiIgnoreCase(t, fieldApi);
    if (real == null) return null;
    List<Schema.PicklistEntry> vals = t.getDescribe().fields.getMap().get(real).getDescribe().getPicklistValues();
    if (vals.isEmpty()) return null;

    Set<String> allowed = new Set<String>();
    for (Schema.PicklistEntry pe : vals) allowed.add(pe.getValue());

    for (String p : preferred) if (allowed.contains(p)) return p;
    return vals[0].getValue();
}

Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

Id certId;
List<SObject> certRows = Database.query('SELECT Id FROM Certificacao__c WHERE Name = \'Data Cloud\' ORDER BY CreatedDate DESC LIMIT 1');
if (certRows.isEmpty()) {
    SObject cert = gd.get('Certificacao__c').newSObject();
    putIfExists(cert, 'Name', 'Data Cloud');
    putIfExists(cert, 'Codigo__c', 'DC');
    putIfExists(cert, 'Descricao__c', 'Trilha Data Cloud');
    putIfExists(cert, 'Nivel__c', pickVal(gd.get('Certificacao__c'), 'Nivel__c', new List<String>{'Professional','Associate'}));
    putIfExists(cert, 'Ativa__c', true);
    putIfExists(cert, 'OrdemExibicao__c', 1);
    insert cert;
    certId = cert.Id;
} else {
    certId = (Id) certRows[0].get('Id');
}

Id dominioId;
List<SObject> domRows = Database.query('SELECT Id FROM DominioCertificacao__c WHERE Name = \'Identity Resolution\' ORDER BY CreatedDate DESC LIMIT 1');
if (domRows.isEmpty()) {
    SObject dom = gd.get('DominioCertificacao__c').newSObject();
    putIfExists(dom, 'Name', 'Identity Resolution');
    putIfExists(dom, 'Certificacao__c', certId);
    putIfExists(dom, 'Codigo__c', 'IR');
    putIfExists(dom, 'Descricao__c', 'Resolução de identidade');
    putIfExists(dom, 'PesoProva__c', 20);
    putIfExists(dom, 'Ativo__c', true);
    putIfExists(dom, 'OrdemExibicao__c', 1);
    insert dom;
    dominioId = dom.Id;
} else {
    dominioId = (Id) domRows[0].get('Id');
}

Id topicoId;
List<SObject> topRows = Database.query('SELECT Id FROM Topico__c WHERE Name = \'Identity Resolution\' ORDER BY CreatedDate DESC LIMIT 1');
if (topRows.isEmpty()) {
    SObject top = gd.get('Topico__c').newSObject();
    putIfExists(top, 'Name', 'Identity Resolution');
    putIfExists(top, 'DominioCertificacao__c', dominioId);
    putIfExists(top, 'Descricao__c', 'Identity Resolution');
    putIfExists(top, 'Ativo__c', true);
    putIfExists(top, 'EhTopicoCritico__c', true);
    putIfExists(top, 'OrdemExibicao__c', 1);
    insert top;
    topicoId = top.Id;
} else {
    topicoId = (Id) topRows[0].get('Id');
}

public class Q {
    public String pergunta;
    public String explicacao;
    public String nivel;
    public List<String> alternativas;
    public Integer correta;
    public Q(String pergunta, String explicacao, String nivel, List<String> alternativas, Integer correta) {
        this.pergunta = pergunta;
        this.explicacao = explicacao;
        this.nivel = nivel;
        this.alternativas = alternativas;
        this.correta = correta;
    }
}

List<Q> banco = new List<Q>{
    new Q('Qual é o objetivo principal do Identity Resolution?', 'Unificar registros de origem em um perfil único.', 'Facil', new List<String>{'Unificar perfis de origem','Criar dashboards automaticamente','Gerar permissões de usuário','Substituir sistemas externos'}, 0),
    new Q('Qual é o limite de Match Rules por ruleset?', 'O limite recomendado é 10.', 'Media', new List<String>{'5','10','20','50'}, 1),
    new Q('Qual é o limite de critérios por Match Rule?', 'Cada Match Rule suporta até 10 critérios.', 'Media', new List<String>{'3','5','10','15'}, 2),
    new Q('Qual é a frequência agendada máxima por ruleset?', 'A execução agendada máxima é uma vez por dia.', 'Facil', new List<String>{'Uma vez por hora','Uma vez por dia','Uma vez por semana','Sem limite'}, 1),
    new Q('Qual é o papel do Unified Link Object?', 'Conectar os registros de origem aos registros unificados.', 'Media', new List<String>{'Excluir duplicados automaticamente','Conectar source records aos unified records','Definir perfis de acesso','Criar filas de atendimento'}, 1)
};

List<SObject> qIns = new List<SObject>();
for (Q q : banco) {
    SObject qr = gd.get('Questao__c').newSObject();
    putIfExists(qr, 'Name', q.pergunta);
    putIfExists(qr, 'Enunciado__c', q.pergunta);
    putIfExists(qr, 'Certificacao__c', certId);
    putIfExists(qr, 'DominioPrincipal__c', dominioId);
    putIfExists(qr, 'TopicoPrincipal__c', topicoId);
    putIfExists(qr, 'TipoQuestao__c', pickVal(gd.get('Questao__c'), 'TipoQuestao__c', new List<String>{'MultiplaEscolha'}));
    putIfExists(qr, 'NivelDificuldade__c', pickVal(gd.get('Questao__c'), 'NivelDificuldade__c', new List<String>{q.nivel,'Media','Facil','Dificil'}));
    putIfExists(qr, 'ExplicacaoResposta__c', q.explicacao);
    putIfExists(qr, 'Ativa__c', true);
    qIns.add(qr);
}
insert qIns;

List<SObject> aIns = new List<SObject>();
for (Integer i = 0; i < banco.size(); i++) {
    Q q = banco[i];
    for (Integer a = 0; a < q.alternativas.size(); a++) {
        SObject ar = gd.get('AlternativaQuestao__c').newSObject();
        String altTexto = q.alternativas[a];
        putIfExists(ar, 'Name', altTexto.length() > 80 ? altTexto.substring(0, 80) : altTexto);
        putIfExists(ar, 'Questao__c', (Id) qIns[i].get('Id'));
        putIfExists(ar, 'TextoAlternativa__c', altTexto);
        putIfExists(ar, 'AlternativaCorreta__c', a == q.correta);
        putIfExists(ar, 'Correta__c', a == q.correta);
        putIfExists(ar, 'OrdemExibicao__c', a + 1);
        putIfExists(ar, 'Ativa__c', true);
        aIns.add(ar);
    }
}
insert aIns;

System.debug('SEED_OK|CERT=' + certId + '|DOM=' + dominioId + '|TOP=' + topicoId + '|Q=' + qIns.size() + '|A=' + aIns.size());
