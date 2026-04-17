String runId = String.valueOf(Datetime.now().getTime());
Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

String fieldApiIgnoreCase(Schema.SObjectType t, String wanted) {
    for (String f : t.getDescribe().fields.getMap().keySet()) {
        if (f.toLowerCase() == wanted.toLowerCase()) return f;
    }
    return null;
}

void putByName(SObject rec, String preferredField, Object value) {
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

Id ensureCert() {
    List<SObject> rows = Database.query('SELECT Id, Name FROM Certificacao__c WHERE Name = \'Data Cloud Consultant\' ORDER BY CreatedDate DESC LIMIT 1');
    if (!rows.isEmpty()) return (Id) rows[0].get('Id');

    SObject rec = gd.get('Certificacao__c').newSObject();
    putByName(rec, 'Name', 'Data Cloud Consultant');
    putByName(rec, 'Codigo__c', 'DCC');
    putByName(rec, 'Descricao__c', 'Certificação para trilha Data Cloud');
    putByName(rec, 'Nivel__c', pickVal(gd.get('Certificacao__c'), 'Nivel__c', new List<String>{'Professional','Associate','Architect'}));
    putByName(rec, 'Ativa__c', true);
    putByName(rec, 'OrdemExibicao__c', 1);
    insert rec;
    return rec.Id;
}

Id ensureDominio(Id certId) {
    List<SObject> rows = Database.query('SELECT Id, Name FROM DominioCertificacao__c WHERE Name = \'Identity Resolution\' ORDER BY CreatedDate DESC LIMIT 1');
    for (SObject r : rows) {
        String fk = fieldApiIgnoreCase(gd.get('DominioCertificacao__c'), 'Certificacao__c');
        if (fk != null && (Id)r.get('Id') != null) {
            // Relação já existente com esse nome é suficiente para este seed
            return (Id) r.get('Id');
        }
    }

    SObject rec = gd.get('DominioCertificacao__c').newSObject();
    putByName(rec, 'Name', 'Identity Resolution');
    putByName(rec, 'Certificacao__c', certId);
    putByName(rec, 'Codigo__c', 'IR');
    putByName(rec, 'Descricao__c', 'Domínio de unificação de perfis');
    putByName(rec, 'PesoProva__c', 20);
    putByName(rec, 'Ativo__c', true);
    putByName(rec, 'OrdemExibicao__c', 1);
    insert rec;
    return rec.Id;
}

Id ensureTopico(Id dominioId) {
    List<SObject> rows = Database.query('SELECT Id, Name FROM Topico__c WHERE Name = \'Identity Resolution - Questoes Reais\' ORDER BY CreatedDate DESC LIMIT 1');
    if (!rows.isEmpty()) return (Id) rows[0].get('Id');

    SObject rec = gd.get('Topico__c').newSObject();
    putByName(rec, 'Name', 'Identity Resolution - Questoes Reais');
    putByName(rec, 'DominioCertificacao__c', dominioId);
    putByName(rec, 'Descricao__c', 'Questões reais de Identity Resolution');
    putByName(rec, 'EhTopicoCritico__c', true);
    putByName(rec, 'Ativo__c', true);
    putByName(rec, 'OrdemExibicao__c', 1);
    insert rec;
    return rec.Id;
}

Id certId = ensureCert();
Id dominioId = ensureDominio(certId);
Id topicoId = ensureTopico(dominioId);

public class Q {
    public String enun;
    public String expl;
    public String niv;
    public List<String> alts;
    public Integer ok;
    public Q(String enun, String expl, String niv, List<String> alts, Integer ok) {
        this.enun = enun;
        this.expl = expl;
        this.niv = niv;
        this.alts = alts;
        this.ok = ok;
    }
}

List<Q> banco = new List<Q>{
    new Q('No Identity Resolution, quando um perfil unificado é criado?', 'Quando ao menos uma match rule ativa é satisfeita e todos os critérios dessa regra são verdadeiros.', 'Facil', new List<String>{'Quando qualquer critério isolado for verdadeiro','Quando todos os critérios de uma mesma regra forem verdadeiros','Somente com reconciliação Source Priority','Apenas em execução manual'}, 1),
    new Q('Qual é o limite máximo de match rules por ruleset?', 'O limite documentado é 10 match rules por ruleset.', 'Media', new List<String>{'5','10','15','25'}, 1),
    new Q('Qual é o limite máximo de critérios por match rule?', 'O limite documentado é 10 critérios por match rule.', 'Facil', new List<String>{'3','5','10','20'}, 2),
    new Q('Qual regra de reconciliação é recomendada para estabilizar IDs?', 'A documentação recomenda Source Priority para campos de ID.', 'Media', new List<String>{'Most Frequent','Last Updated','Source Priority','Exact Normalized'}, 2),
    new Q('Qual é a frequência agendada máxima por ruleset?', 'A frequência agendada máxima é uma vez por dia.', 'Facil', new List<String>{'A cada hora','A cada 6 horas','Uma vez por dia','Sem limite'}, 2),
    new Q('Qual é o limite de jobs por ruleset em 24 horas?', 'O limite documentado é 4 jobs por ruleset por data space em 24h.', 'Dificil', new List<String>{'2','4','8','24'}, 1),
    new Q('Qual é o papel dos Unified Link Objects?', 'Fazem a ponte entre registros de origem e registros unificados para rastreabilidade.', 'Media', new List<String>{'Substituir registros de origem','Conectar source records aos unified records','Guardar só métricas','Definir segmentos automaticamente'}, 1),
    new Q('Sobre o Ruleset ID, qual afirmação é correta?', 'É opcional, até 4 caracteres, e vira parte dos nomes/API names de objetos gerados.', 'Dificil', new List<String>{'Obrigatório e editável','Opcional, até 4 caracteres, não alterável depois','Sem limite de tamanho','Só para Account'}, 1)
};

List<SObject> qRecs = new List<SObject>();
for (Integer i = 0; i < banco.size(); i++) {
    Q q = banco[i];
    SObject rec = gd.get('Questao__c').newSObject();
    putByName(rec, 'Name', 'IR REAL ' + String.valueOf(i + 1) + ' - ' + runId.right(6));
    putByName(rec, 'CodigoInterno__c', 'IR-REAL-' + String.valueOf(i + 1).leftPad(2, '0') + '-' + runId);
    putByName(rec, 'Certificacao__c', certId);
    putByName(rec, 'DominioPrincipal__c', dominioId);
    putByName(rec, 'TopicoPrincipal__c', topicoId);
    putByName(rec, 'Enunciado__c', q.enun);
    putByName(rec, 'TipoQuestao__c', pickVal(gd.get('Questao__c'), 'TipoQuestao__c', new List<String>{'MultiplaEscolha'}));
    putByName(rec, 'NivelDificuldade__c', pickVal(gd.get('Questao__c'), 'NivelDificuldade__c', new List<String>{q.niv,'Media','Facil','Dificil'}));
    putByName(rec, 'ExplicacaoResposta__c', q.expl);
    putByName(rec, 'JustificativaOficial__c', q.expl);
    putByName(rec, 'Fonte__c', 'Salesforce Help - Identity Resolution');
    putByName(rec, 'FonteURL__c', 'https://help.salesforce.com/s/articleView?id=data.c360_a_identity_resolution.htm&type=5');
    putByName(rec, 'OrigemConteudo__c', pickVal(gd.get('Questao__c'), 'OrigemConteudo__c', new List<String>{'Adaptado','Referencia','Autoral'}));
    putByName(rec, 'StatusPublicacao__c', pickVal(gd.get('Questao__c'), 'StatusPublicacao__c', new List<String>{'Publicado','Rascunho'}));
    putByName(rec, 'Ativa__c', true);
    putByName(rec, 'PossuiMidia__c', false);
    putByName(rec, 'DataUltimaRevisaoConteudo__c', Date.today());
    putByName(rec, 'DataCriacao__c', System.now());
    qRecs.add(rec);
}
insert qRecs;

List<String> labels = new List<String>{'A','B','C','D'};
List<SObject> altRecs = new List<SObject>();
for (Integer i = 0; i < banco.size(); i++) {
    Q q = banco[i];
    for (Integer a = 0; a < q.alts.size(); a++) {
        SObject ar = gd.get('AlternativaQuestao__c').newSObject();
        putByName(ar, 'Name', labels[a]);
        putByName(ar, 'Questao__c', (Id)qRecs[i].get('Id'));
        putByName(ar, 'TextoAlternativa__c', q.alts[a]);
        putByName(ar, 'Correta__c', a == q.ok);
        putByName(ar, 'AlternativaCorreta__c', a == q.ok);
        putByName(ar, 'ExplicacaoAlternativa__c', a == q.ok ? 'Alternativa correta.' : 'Alternativa incorreta para este contexto.');
        putByName(ar, 'OrdemExibicao__c', a + 1);
        putByName(ar, 'Ativa__c', true);
        altRecs.add(ar);
    }
}
insert altRecs;

System.debug('LOTE_REAL_OK|RUN=' + runId + '|QUESTOES=' + qRecs.size() + '|ALTERNATIVAS=' + altRecs.size() + '|TOPICO=' + topicoId);
for (Integer i = 0; i < qRecs.size(); i++) {
    System.debug('Q_CRIADA|' + qRecs[i].get('Id') + '|' + qRecs[i].get('Name'));
}
