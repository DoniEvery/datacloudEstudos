String runId = String.valueOf(Datetime.now().getTime());
Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

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
    Set<String> allowed = new Set<String>();
    for (Schema.PicklistEntry pe : vals) allowed.add(pe.getValue());
    for (String p : preferred) if (allowed.contains(p)) return p;
    return vals.isEmpty() ? null : vals[0].getValue();
}

Id certId;
List<SObject> certRows = Database.query('SELECT Id, Name FROM Certificacao__c WHERE Name = \'Data Cloud Consultant\' ORDER BY CreatedDate DESC LIMIT 1');
if (certRows.isEmpty()) {
    SObject c = gd.get('Certificacao__c').newSObject();
    putIfExists(c, 'Name', 'Data Cloud Consultant');
    insert c;
    certId = c.Id;
} else {
    certId = (Id)certRows[0].get('Id');
}

Id dominioId;
List<SObject> domRows = Database.query('SELECT Id, Name FROM DominioCertificacao__c WHERE Name = \'Identity Resolution\' ORDER BY CreatedDate DESC LIMIT 1');
if (domRows.isEmpty()) {
    SObject d = gd.get('DominioCertificacao__c').newSObject();
    putIfExists(d, 'Name', 'Identity Resolution');
    putIfExists(d, 'Certificacao__c', certId);
    insert d;
    dominioId = d.Id;
} else {
    dominioId = (Id)domRows[0].get('Id');
}

Id topicoId;
List<SObject> topRows = Database.query('SELECT Id, Name FROM Topico__c WHERE Name = \'Identity Resolution - VISIVEL\' ORDER BY CreatedDate DESC LIMIT 1');
if (topRows.isEmpty()) {
    SObject t = gd.get('Topico__c').newSObject();
    putIfExists(t, 'Name', 'Identity Resolution - VISIVEL');
    putIfExists(t, 'DominioCertificacao__c', dominioId);
    insert t;
    topicoId = t.Id;
} else {
    topicoId = (Id)topRows[0].get('Id');
}

public class Q {
    public String pergunta;
    public List<String> alt;
    public Integer correta;
    public String explic;
    public Q(String pergunta, List<String> alt, Integer correta, String explic) {
        this.pergunta = pergunta;
        this.alt = alt;
        this.correta = correta;
        this.explic = explic;
    }
}

List<Q> banco = new List<Q>{
    new Q('[IR] Qual limite de Match Rules por ruleset?', new List<String>{'5','10','15','20'}, 1, 'Limite documentado: 10.'),
    new Q('[IR] Qual limite de critérios por Match Rule?', new List<String>{'5','8','10','12'}, 2, 'Limite documentado: 10 critérios.'),
    new Q('[IR] Frequência agendada máxima por ruleset?', new List<String>{'1h','6h','1x por dia','Sem limite'}, 2, 'Máximo: uma execução agendada por dia.'),
    new Q('[IR] Limite de jobs do ruleset em 24h?', new List<String>{'2','4','8','24'}, 1, 'Máximo: 4 jobs por ruleset em 24h.'),
    new Q('[IR] Papel do Unified Link Object?', new List<String>{'Substituir source','Conectar source ao unified','Criar segmentos','Deletar duplicados'}, 1, 'Bridge entre source records e unified records.')
};

List<SObject> qIns = new List<SObject>();
for (Integer i = 0; i < banco.size(); i++) {
    Q q = banco[i];
    SObject qr = gd.get('Questao__c').newSObject();

    String nameTxt = q.pergunta + ' #' + runId.right(6);
    if (nameTxt.length() > 80) nameTxt = nameTxt.substring(0, 80);

    putIfExists(qr, 'Name', nameTxt);
    putIfExists(qr, 'CodigoInterno__c', 'IR-VIS-' + String.valueOf(i + 1).leftPad(2, '0') + '-' + runId);
    putIfExists(qr, 'Certificacao__c', certId);
    putIfExists(qr, 'DominioPrincipal__c', dominioId);
    putIfExists(qr, 'TopicoPrincipal__c', topicoId);
    putIfExists(qr, 'Enunciado__c', q.pergunta);
    putIfExists(qr, 'TipoQuestao__c', pickVal(gd.get('Questao__c'), 'TipoQuestao__c', new List<String>{'MultiplaEscolha'}));
    putIfExists(qr, 'NivelDificuldade__c', pickVal(gd.get('Questao__c'), 'NivelDificuldade__c', new List<String>{'Media','Facil'}));
    putIfExists(qr, 'ExplicacaoResposta__c', q.explic);
    putIfExists(qr, 'Fonte__c', 'IR - carga visível');
    putIfExists(qr, 'OrigemConteudo__c', pickVal(gd.get('Questao__c'), 'OrigemConteudo__c', new List<String>{'Adaptado','Autoral'}));
    putIfExists(qr, 'StatusPublicacao__c', pickVal(gd.get('Questao__c'), 'StatusPublicacao__c', new List<String>{'Publicado','Rascunho'}));
    putIfExists(qr, 'Ativa__c', true);
    qIns.add(qr);
}
insert qIns;

List<String> labels = new List<String>{'A','B','C','D'};
List<SObject> aIns = new List<SObject>();
for (Integer i = 0; i < banco.size(); i++) {
    Q q = banco[i];
    for (Integer a = 0; a < q.alt.size(); a++) {
        SObject ar = gd.get('AlternativaQuestao__c').newSObject();
        putIfExists(ar, 'Name', labels[a] + ' - ' + q.alt[a]);
        putIfExists(ar, 'Questao__c', (Id)qIns[i].get('Id'));
        putIfExists(ar, 'TextoAlternativa__c', q.alt[a]);
        putIfExists(ar, 'Correta__c', a == q.correta);
        putIfExists(ar, 'AlternativaCorreta__c', a == q.correta);
        putIfExists(ar, 'ExplicacaoAlternativa__c', a == q.correta ? 'Correta' : 'Incorreta');
        putIfExists(ar, 'OrdemExibicao__c', a + 1);
        putIfExists(ar, 'Ativa__c', true);
        aIns.add(ar);
    }
}
insert aIns;

System.debug('LOTE_VISIVEL_OK|RUN=' + runId + '|TOPICO=' + topicoId + '|Q=' + qIns.size() + '|A=' + aIns.size());
for (Integer i = 0; i < qIns.size(); i++) {
    System.debug('Q_VISIVEL|' + qIns[i].get('Id') + '|' + qIns[i].get('Name'));
}
