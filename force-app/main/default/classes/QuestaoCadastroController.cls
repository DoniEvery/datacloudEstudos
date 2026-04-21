public with sharing class QuestaoCadastroController {
    
    public class OptionItem {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }

        public OptionItem(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    public class AlternativaInput {
        @AuraEnabled public Integer ordem { get; set; }
        @AuraEnabled public String texto { get; set; }
        @AuraEnabled public String explicacao { get; set; }
        @AuraEnabled public Boolean correta { get; set; }
    }

    public class QuestaoCreateInput {
        @AuraEnabled public String nome { get; set; }
        @AuraEnabled public String enunciado { get; set; }
        @AuraEnabled public Id certificacaoId { get; set; }
        @AuraEnabled public Id dominioId { get; set; }
        @AuraEnabled public Id topicoId { get; set; }
        @AuraEnabled public String tipoQuestao { get; set; }
        @AuraEnabled public String nivelDificuldade { get; set; }
        @AuraEnabled public String colecaoSimulado { get; set; }
        @AuraEnabled public Integer nivelSimulado { get; set; }
        @AuraEnabled public String origemSimulado { get; set; }
        @AuraEnabled public String codigoQuestao { get; set; }
        @AuraEnabled public String codigoInterno { get; set; }
        @AuraEnabled public String subtopico { get; set; }
        @AuraEnabled public Boolean ativa { get; set; }
        @AuraEnabled public List<AlternativaInput> alternativas { get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static List<OptionItem> getCertificacoes() {
        List<OptionItem> result = new List<OptionItem>();
        for (Certificacao__c c : [
            SELECT Id, Name
            FROM Certificacao__c
            ORDER BY Name ASC
        ]) {
            result.add(new OptionItem(c.Name, c.Id));
        }
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<OptionItem> getDominios(Id certificacaoId) {
        List<OptionItem> result = new List<OptionItem>();
        if (certificacaoId == null) {
            return result;
        }

        for (DominioCertificacao__c d : [
            SELECT Id, Name
            FROM DominioCertificacao__c
            WHERE Certificacao__c = :certificacaoId
            ORDER BY Name ASC
        ]) {
            result.add(new OptionItem(d.Name, d.Id));
        }
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<OptionItem> getTopicos(Id dominioId) {
        List<OptionItem> result = new List<OptionItem>();
        if (dominioId == null) {
            return result;
        }

        for (Topico__c t : [
            SELECT Id, Name
            FROM Topico__c
            WHERE DominioCertificacao__c = :dominioId
            ORDER BY Name ASC
        ]) {
            result.add(new OptionItem(t.Name, t.Id));
        }
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<OptionItem> getColecoesSimulado() {
        List<OptionItem> result = new List<OptionItem>();
        Set<String> valores = new Set<String>();

        for (Questao__c q : [
            SELECT ColecaoSimulado__c
            FROM Questao__c
            WHERE ColecaoSimulado__c != null
            ORDER BY ColecaoSimulado__c ASC
            LIMIT 2000
        ]) {
            String valor = q.ColecaoSimulado__c == null ? null : q.ColecaoSimulado__c.trim();
            if (!String.isBlank(valor) && !valores.contains(valor)) {
                valores.add(valor);
                result.add(new OptionItem(valor, valor));
            }
        }

        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<OptionItem> getSubtopicos() {
        List<OptionItem> result = new List<OptionItem>();
        Set<String> valores = new Set<String>();

        for (Questao__c q : [
            SELECT Subtopico__c
            FROM Questao__c
            ORDER BY CreatedDate DESC
            LIMIT 2000
        ]) {
            String valor = q.Subtopico__c == null ? null : q.Subtopico__c.trim();
            if (!String.isBlank(valor) && !valores.contains(valor)) {
                valores.add(valor);
                result.add(new OptionItem(valor, valor));
            }
        }

        return result;
    }

    @AuraEnabled
    public static Id criarQuestaoComAlternativas(QuestaoCreateInput input) {
        if (input == null) {
            throw new AuraHandledException('Dados de entrada não informados.');
        }

        normalizarInput(input);
        normalizarRelacionamentos(input);

        validarInput(input);

        String codigoQuestao = gerarCodigoQuestao(input.codigoQuestao);

        Questao__c questao = new Questao__c();
        questao.Name = String.isBlank(input.nome)
            ? ('Questão - ' + codigoQuestao).left(80)
            : input.nome.left(80);
        questao.Enunciado__c = input.enunciado;
        questao.Certificacao__c = input.certificacaoId;
        questao.DominioPrincipal__c = input.dominioId;
        questao.TopicoPrincipal__c = input.topicoId;
        questao.TipoQuestao__c = input.tipoQuestao;
        questao.NivelDificuldade__c = input.nivelDificuldade;
        questao.ColecaoSimulado__c = input.colecaoSimulado;
        questao.NivelSimulado__c = input.nivelSimulado;
        questao.OrigemSimulado__c = input.origemSimulado;
        questao.CodigoQuestao__c = codigoQuestao;
        if (!String.isBlank(input.codigoInterno)) {
            questao.CodigoInterno__c = input.codigoInterno;
        }
        questao.Subtopico__c = input.subtopico;
        questao.Ativa__c = (input.ativa == null) ? true : input.ativa;

        insert questao;

        List<AlternativaQuestao__c> alternativas = new List<AlternativaQuestao__c>();
        for (AlternativaInput alt : input.alternativas) {
            AlternativaQuestao__c rec = new AlternativaQuestao__c();
            rec.Questao__c = questao.Id;
            rec.OrdemExibicao__c = alt.ordem;
            rec.TextoAlternativa__c = alt.texto;
            rec.Name = alt.texto.left(80);
            rec.ExplicacaoAlternativa__c = alt.explicacao;
            rec.Correta__c = (alt.correta == true);
            rec.Ativa__c = true;
            alternativas.add(rec);
        }

        insert alternativas;
        return questao.Id;
    }

    private static void normalizarInput(QuestaoCreateInput input) {
        input.nome = input.nome == null ? null : input.nome.trim();
        input.enunciado = input.enunciado == null ? null : input.enunciado.trim();
        if (String.isBlank(input.tipoQuestao)) { input.tipoQuestao = 'Simulado'; }
        if (String.isBlank(input.nivelDificuldade)) { input.nivelDificuldade = 'Facil'; }

        if (!String.isBlank(input.enunciado)) {
            return;
        }

        if (!String.isBlank(input.nome)) {
            input.enunciado = 'Enunciado automático: ' + input.nome;
            return;
        }

        if (input.alternativas != null) {
            for (AlternativaInput alt : input.alternativas) {
                if (alt != null && !String.isBlank(alt.texto)) {
                    input.enunciado = 'Enunciado automático baseado na alternativa: ' + alt.texto.trim();
                    return;
                }
            }
        }

        input.enunciado = 'Enunciado automático';
    }

    private static void normalizarRelacionamentos(QuestaoCreateInput input) {
        if (input.certificacaoId == null) {
            List<Certificacao__c> certs = [SELECT Id FROM Certificacao__c ORDER BY Name ASC LIMIT 1];
            if (!certs.isEmpty()) {
                input.certificacaoId = certs[0].Id;
            }
        }

        if (input.dominioId == null && input.certificacaoId != null) {
            List<DominioCertificacao__c> doms = [
                SELECT Id FROM DominioCertificacao__c
                WHERE Certificacao__c = :input.certificacaoId
                ORDER BY Name ASC LIMIT 1
            ];
            if (!doms.isEmpty()) {
                input.dominioId = doms[0].Id;
            }
        }

        if (input.topicoId == null && input.dominioId != null) {
            List<Topico__c> tops = [
                SELECT Id FROM Topico__c
                WHERE DominioCertificacao__c = :input.dominioId
                ORDER BY Name ASC LIMIT 1
            ];
            if (!tops.isEmpty()) {
                input.topicoId = tops[0].Id;
            }
        }
    }

    private static void validarInput(QuestaoCreateInput input) {
        if (String.isBlank(input.enunciado)) {
            throw new AuraHandledException('Informe o enunciado da questão.');
        }
        if (input.certificacaoId == null || input.dominioId == null || input.topicoId == null) {
            throw new AuraHandledException('Certificação, domínio e tópico são obrigatórios.');
        }
        if (String.isBlank(input.tipoQuestao) || String.isBlank(input.nivelDificuldade)) {
            throw new AuraHandledException('Tipo de questão e nível de dificuldade são obrigatórios.');
        }
        if (input.alternativas == null) {
            input.alternativas = new List<AlternativaInput>();
        }

        while (input.alternativas.size() < 4) {
            AlternativaInput a = new AlternativaInput();
            a.ordem = input.alternativas.size() + 1;
            a.texto = 'Alternativa ' + a.ordem;
            a.explicacao = '';
            a.correta = false;
            input.alternativas.add(a);
        }

        Boolean temCorreta = false;
        for (AlternativaInput alt : input.alternativas) {
            if (alt.correta == true) { temCorreta = true; break; }
        }
        if (!temCorreta) { input.alternativas[0].correta = true; }

        if (input.alternativas.size() != 4) {
            throw new AuraHandledException('É obrigatório informar exatamente 4 alternativas.');
        }

        Integer corretas = 0;
        Set<String> textosNormalizados = new Set<String>();

        for (AlternativaInput alt : input.alternativas) {
            if (alt == null || String.isBlank(alt.texto)) {
                throw new AuraHandledException('Todas as alternativas devem ter texto.');
            }

            String textoNormalizado = alt.texto.trim().toLowerCase().replaceAll('\\s+', ' ');
            if (textosNormalizados.contains(textoNormalizado)) {
                throw new AuraHandledException('Não é permitido repetir textos de alternativa na mesma questão.');
            }
            textosNormalizados.add(textoNormalizado);

            if (alt.correta == true) {
                corretas++;
            }
        }

        if (corretas != 1) {
            throw new AuraHandledException('Marque exatamente 1 alternativa como correta.');
        }
    }

    private static String gerarCodigoQuestao(String codigoInformado) {
        if (!String.isBlank(codigoInformado)) {
            return codigoInformado.trim().left(10);
        }

        Integer proximoNumero = 1;
        for (Questao__c q : [
            SELECT CodigoQuestao__c
            FROM Questao__c
            WHERE CodigoQuestao__c LIKE 'SL%'
            ORDER BY CreatedDate DESC
            LIMIT 5000
        ]) {
            if (String.isBlank(q.CodigoQuestao__c) || !q.CodigoQuestao__c.startsWith('SL')) {
                continue;
            }

            String sufixo = q.CodigoQuestao__c.substring(2);
            if (Pattern.matches('^[0-9]+$', sufixo)) {
                Integer numero = Integer.valueOf(sufixo);
                if (numero >= proximoNumero) {
                    proximoNumero = numero + 1;
                }
            }
        }

        return ('SL' + String.valueOf(proximoNumero)).left(10);
    }
}