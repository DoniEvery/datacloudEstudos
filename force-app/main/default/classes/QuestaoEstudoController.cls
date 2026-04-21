public without sharing class QuestaoEstudoController {
    private static String pickField(Map<String, Schema.SObjectField> fieldsMap, List<String> candidates) {
        for (String fieldName : candidates) {
            if (fieldsMap.containsKey(fieldName)) {
                return fieldName;
            }
        }
        return null;
    }

    private static Boolean getBooleanValue(SObject record, String fieldName) {
        if (String.isBlank(fieldName)) {
            return false;
        }
        Object value = record.get(fieldName);
        return value != null && (Boolean) value;
    }

    private static Boolean getAnyBooleanValue(SObject record, List<String> fieldNames) {
        Map<String, Schema.SObjectField> fieldsMap = record.getSObjectType().getDescribe().fields.getMap();
        for (String fieldName : fieldNames) {
            if (String.isBlank(fieldName)) {
                continue;
            }
            if (!fieldsMap.containsKey(fieldName)) {
                continue;
            }
            Object value = record.get(fieldName);
            if (value != null && (Boolean) value) {
                return true;
            }
        }
        return false;
    }

    private static Integer getIntegerValue(SObject record, String fieldName, Integer defaultValue) {
        if (String.isBlank(fieldName)) {
            return defaultValue;
        }
        Object value = record.get(fieldName);
        if (value == null) {
            return defaultValue;
        }
        if (value instanceof Integer) {
            return (Integer) value;
        }
        if (value instanceof Decimal) {
            return ((Decimal) value).intValue();
        }
        return defaultValue;
    }

    private static String getStringValue(SObject record, String fieldName) {
        if (String.isBlank(fieldName)) {
            return null;
        }
        Object value = record.get(fieldName);
        return value == null ? null : String.valueOf(value);
    }

    private static Decimal getDecimalValue(SObject record, String fieldName) {
        if (String.isBlank(fieldName)) {
            return null;
        }
        Object value = record.get(fieldName);
        if (value == null) {
            return null;
        }
        if (value instanceof Decimal) {
            return (Decimal) value;
        }
        if (value instanceof Integer) {
            return Decimal.valueOf((Integer) value);
        }
        return null;
    }

    private static String limparPrefixoQuestao(String texto) {
        if (String.isBlank(texto)) {
            return texto;
        }

        // Remove padrões como: Q005 - , WQ021 - , ABC123 -
        String limpo = texto.replaceFirst('^[A-Za-z]{1,3}\\d{3}\\s*-\\s*', '');
        return limpo;
    }

    private static String normalizarTextoAlternativa(String texto) {
        if (String.isBlank(texto)) {
            return '';
        }
        return texto.trim().toLowerCase().replaceAll('\\s+', ' ');
    }

    private static List<Map<String, Object>> removerAlternativasDuplicadas(List<Map<String, Object>> alternativas) {
        List<Map<String, Object>> unicas = new List<Map<String, Object>>();
        if (alternativas == null || alternativas.isEmpty()) {
            return unicas;
        }

        Set<String> textosVistos = new Set<String>();
        Integer ordem = 1;
        for (Map<String, Object> alt : alternativas) {
            String texto = String.valueOf(alt.get('texto'));
            String chave = normalizarTextoAlternativa(texto);
            if (String.isBlank(chave) || textosVistos.contains(chave)) {
                continue;
            }
            textosVistos.add(chave);

            Map<String, Object> copia = new Map<String, Object>(alt);
            copia.put('ordem', ordem++);
            unicas.add(copia);
        }

        return unicas;
    }

    private static Boolean alternativasValidas(List<Map<String, Object>> alternativas) {
        if (alternativas == null || alternativas.size() < 4) {
            return false;
        }

        Integer totalCorretas = 0;
        for (Map<String, Object> alt : alternativas) {
            Object corretaRaw = alt.get('correta');
            Boolean correta = corretaRaw != null && (Boolean) corretaRaw;
            if (correta) {
                totalCorretas++;
            }
        }

        return totalCorretas == 1;
    }
    
    private static List<SObject> ordenarQuestoesPorRevisao(List<SObject> questoes) {
        if (questoes.isEmpty()) {
            return questoes;
        }

        Set<Id> qIdsForProgress = new Set<Id>();
        for (SObject q : questoes) {
            qIdsForProgress.add((Id) q.get('Id'));
        }

        Map<Id, Date> proximaRevisaoPorQuestao = new Map<Id, Date>();
        for (ProgressoQuestaoUsuario__c p : [
            SELECT Questao__c, ProximaRevisao__c
            FROM ProgressoQuestaoUsuario__c
            WHERE Questao__c IN :qIdsForProgress
            AND OwnerId = :UserInfo.getUserId()
        ]) {
            proximaRevisaoPorQuestao.put(p.Questao__c, p.ProximaRevisao__c);
        }

        Date hoje = Date.today();
        List<SObject> novas = new List<SObject>();
        List<SObject> vencidas = new List<SObject>();
        List<SObject> futuras = new List<SObject>();

        for (SObject q : questoes) {
            Date pr = proximaRevisaoPorQuestao.get((Id) q.get('Id'));
            if (pr == null) {
                novas.add(q);
            } else if (pr <= hoje) {
                vencidas.add(q);
            } else {
                futuras.add(q);
            }
        }

        List<SObject> ordenadas = new List<SObject>();
        ordenadas.addAll(novas);
        ordenadas.addAll(vencidas);
        ordenadas.addAll(futuras);
        return ordenadas;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getQuestoes(Id topicoId, Id dominioId, Id certificacaoId, Boolean incluirTodosTopicos, String modoEstudo, String colecaoSimulado) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        Boolean isSimulado = String.valueOf(modoEstudo) == 'SIMULADO';

        Map<String, Schema.SObjectField> questaoFields = Schema.SObjectType.Questao__c.fields.getMap();
        String qTextoField = pickField(questaoFields, new List<String>{ 'Enunciado__c', 'TextoQuestao__c', 'Pergunta__c', 'Name' });
        String qNivelField = pickField(questaoFields, new List<String>{ 'NivelDificuldade__c' });
        String qSubtopicoField = pickField(questaoFields, new List<String>{ 'Subtopico__c', 'SubTopico__c', 'Subtema__c' });
        String qExplicacaoField = pickField(questaoFields, new List<String>{ 'ExplicacaoResposta__c', 'Explicacao__c' });
        String qAtivaField = pickField(questaoFields, new List<String>{ 'Ativa__c', 'Ativo__c' });

        String qColecaoSimuladoField = pickField(questaoFields, new List<String>{ 'ColecaoSimulado__c' });
        String qNivelSimuladoField = pickField(questaoFields, new List<String>{ 'NivelSimulado__c' });
        String qOrigemSimuladoField = pickField(questaoFields, new List<String>{ 'OrigemSimulado__c' });

        List<String> qSelectFields = new List<String>{ 'Id', 'Name' };
        if (!String.isBlank(qTextoField) && !qSelectFields.contains(qTextoField)) qSelectFields.add(qTextoField);
        if (!String.isBlank(qNivelField) && !qSelectFields.contains(qNivelField)) qSelectFields.add(qNivelField);
        if (!String.isBlank(qSubtopicoField) && !qSelectFields.contains(qSubtopicoField)) qSelectFields.add(qSubtopicoField);
        if (!String.isBlank(qExplicacaoField) && !qSelectFields.contains(qExplicacaoField)) qSelectFields.add(qExplicacaoField);
        if (!String.isBlank(qAtivaField) && !qSelectFields.contains(qAtivaField)) qSelectFields.add(qAtivaField);
        if (!String.isBlank(qColecaoSimuladoField) && !qSelectFields.contains(qColecaoSimuladoField)) qSelectFields.add(qColecaoSimuladoField);
        if (!String.isBlank(qNivelSimuladoField) && !qSelectFields.contains(qNivelSimuladoField)) qSelectFields.add(qNivelSimuladoField);
        if (!String.isBlank(qOrigemSimuladoField) && !qSelectFields.contains(qOrigemSimuladoField)) qSelectFields.add(qOrigemSimuladoField);

        Set<Id> topicoIds = new Set<Id>();
        if (Boolean.valueOf(incluirTodosTopicos)) {
            if (certificacaoId == null) {
                return result;
            }
            for (Topico__c t : [
                SELECT Id
                FROM Topico__c
                WHERE DominioCertificacao__r.Certificacao__c = :certificacaoId
                ORDER BY CreatedDate ASC
            ]) {
                topicoIds.add(t.Id);
            }
        } else if (dominioId != null) {
            for (Topico__c t : [
                SELECT Id
                FROM Topico__c
                WHERE DominioCertificacao__c = :dominioId
                ORDER BY CreatedDate ASC
            ]) {
                topicoIds.add(t.Id);
            }
        } else {
            if (topicoId == null) {
                return result;
            }
            topicoIds.add(topicoId);
        }

        if (topicoIds.isEmpty()) {
            return result;
        }

        String qSoql = 'SELECT ' + String.join(qSelectFields, ', ')
            + ' FROM Questao__c WHERE TopicoPrincipal__c IN :topicoIds';

        if (isSimulado) {
            qSoql += ' AND TipoQuestao__c = \'Simulado\'';
            if (certificacaoId != null) {
                qSoql += ' AND Certificacao__c = :certificacaoId';
            }
            if (!String.isBlank(colecaoSimulado) && !String.isBlank(qColecaoSimuladoField)) {
                qSoql += ' AND ' + qColecaoSimuladoField + ' = :colecaoSimulado';
            }
        } else {
            qSoql += ' AND TipoQuestao__c != \'Simulado\'';
        }

        qSoql += ' ORDER BY CreatedDate ASC';

        if (isSimulado) {
            qSoql += ' LIMIT 60';
        }

        List<SObject> questoes = Database.query(qSoql);
        if (!isSimulado) {
            questoes = ordenarQuestoesPorRevisao(questoes);
        }

        Map<String, Schema.SObjectField> alternativaFields = Schema.SObjectType.AlternativaQuestao__c.fields.getMap();
        String aTextoField = pickField(alternativaFields, new List<String>{ 'TextoAlternativa__c', 'Texto__c', 'Descricao__c', 'Name' });
        List<String> aCorretaCandidates = new List<String>{ 'Correta__c', 'Correto__c' };
        String aCorretaField = pickField(alternativaFields, aCorretaCandidates);
        String aOrdemField = pickField(alternativaFields, new List<String>{ 'OrdemExibicao__c', 'Ordem__c' });
        String aExplicacaoField = pickField(alternativaFields, new List<String>{ 'ExplicacaoAlternativa__c', 'Explicacao__c', 'Justificativa__c' });
        String aAtivaField = pickField(alternativaFields, new List<String>{ 'Ativa__c', 'Ativo__c' });

        List<String> aSelectFields = new List<String>{ 'Id', 'Name', 'Questao__c' };
        if (!String.isBlank(aTextoField) && !aSelectFields.contains(aTextoField)) aSelectFields.add(aTextoField);
        for (String aCorretaCandidate : aCorretaCandidates) {
            if (alternativaFields.containsKey(aCorretaCandidate) && !aSelectFields.contains(aCorretaCandidate)) {
                aSelectFields.add(aCorretaCandidate);
            }
        }
        if (!String.isBlank(aOrdemField) && !aSelectFields.contains(aOrdemField)) aSelectFields.add(aOrdemField);
        if (!String.isBlank(aExplicacaoField) && !aSelectFields.contains(aExplicacaoField)) aSelectFields.add(aExplicacaoField);
        if (!String.isBlank(aAtivaField) && !aSelectFields.contains(aAtivaField)) aSelectFields.add(aAtivaField);

        Set<Id> questaoIds = new Set<Id>();
        for (SObject q : questoes) {
            questaoIds.add((Id) q.get('Id'));
        }

        Map<Id, List<Map<String, Object>>> alternativasPorQuestao = new Map<Id, List<Map<String, Object>>>();
        if (!questaoIds.isEmpty()) {
            String aSoql = 'SELECT ' + String.join(aSelectFields, ', ')
                + ' FROM AlternativaQuestao__c WHERE Questao__c IN :questaoIds';
            if (!String.isBlank(aOrdemField)) {
                aSoql += ' ORDER BY ' + aOrdemField + ' ASC, CreatedDate ASC';
            } else {
                aSoql += ' ORDER BY CreatedDate ASC';
            }

            for (SObject alt : Database.query(aSoql)) {
                Id qId = (Id) alt.get('Questao__c');
                if (!alternativasPorQuestao.containsKey(qId)) {
                    alternativasPorQuestao.put(qId, new List<Map<String, Object>>());
                }

                Map<String, Object> altMap = new Map<String, Object>();
                altMap.put('id', (Id) alt.get('Id'));

                String textoAlt = getStringValue(alt, aTextoField);
                if (String.isBlank(textoAlt)) {
                    textoAlt = getStringValue(alt, 'Name');
                }
                altMap.put('texto', textoAlt);
                altMap.put('correta', getAnyBooleanValue(alt, aCorretaCandidates));
                altMap.put('ordem', getIntegerValue(alt, aOrdemField, 0));
                altMap.put('explicacao', getStringValue(alt, aExplicacaoField));

                alternativasPorQuestao.get(qId).add(altMap);
            }
        }

        for (SObject q : questoes) {
            Map<String, Object> qMap = new Map<String, Object>();
            Id qId = (Id) q.get('Id');

            List<Map<String, Object>> alternativas = alternativasPorQuestao.containsKey(qId)
                ? alternativasPorQuestao.get(qId)
                : new List<Map<String, Object>>();
            alternativas = removerAlternativasDuplicadas(alternativas);
            if (!alternativasValidas(alternativas)) {
                continue;
            }

            qMap.put('id', qId);

            String enunciado = getStringValue(q, qTextoField);
            if (String.isBlank(enunciado)) {
                enunciado = getStringValue(q, 'Name');
            }
            enunciado = limparPrefixoQuestao(enunciado);
            qMap.put('enunciado', enunciado);
            qMap.put('nivel', getStringValue(q, qNivelField));
            qMap.put('subtopico', getStringValue(q, qSubtopicoField));
            qMap.put('explicacao', getStringValue(q, qExplicacaoField));
            qMap.put('colecaoSimulado', getStringValue(q, qColecaoSimuladoField));
            qMap.put('nivelSimulado', getDecimalValue(q, qNivelSimuladoField));
            qMap.put('origemSimulado', getStringValue(q, qOrigemSimuladoField));
            qMap.put('alternativas', alternativas);
            result.add(qMap);
        }

        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getSimuladosDisponiveis(Id certificacaoId) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        if (certificacaoId == null) {
            return result;
        }

        Map<String, Schema.SObjectField> questaoFields = Schema.SObjectType.Questao__c.fields.getMap();
        String qColecaoSimuladoField = pickField(questaoFields, new List<String>{ 'ColecaoSimulado__c' });
        String qNivelSimuladoField = pickField(questaoFields, new List<String>{ 'NivelSimulado__c' });
        String qOrigemSimuladoField = pickField(questaoFields, new List<String>{ 'OrigemSimulado__c' });

        if (String.isBlank(qColecaoSimuladoField)) {
            return result;
        }

        List<String> qFields = new List<String>{ 'Id', qColecaoSimuladoField };
        if (!String.isBlank(qNivelSimuladoField)) qFields.add(qNivelSimuladoField);
        if (!String.isBlank(qOrigemSimuladoField)) qFields.add(qOrigemSimuladoField);

        String soql = 'SELECT ' + String.join(qFields, ', ')
            + ' FROM Questao__c WHERE Certificacao__c = :certificacaoId AND TipoQuestao__c = \'Simulado\''
            + ' ORDER BY CreatedDate ASC';

        Set<String> chavesVistas = new Set<String>();
        for (SObject q : Database.query(soql)) {
            String colecao = getStringValue(q, qColecaoSimuladoField);
            if (String.isBlank(colecao) || chavesVistas.contains(colecao)) {
                continue;
            }
            chavesVistas.add(colecao);

            Decimal nivel = getDecimalValue(q, qNivelSimuladoField);
            String origem = getStringValue(q, qOrigemSimuladoField);

            String label = colecao;
            if (nivel != null) {
                label += ' · Nível ' + String.valueOf(nivel.intValue());
            }
            if (!String.isBlank(origem)) {
                label += ' · ' + origem;
            }

            result.add(new Map<String, Object>{
                'id' => colecao,
                'name' => label,
                'colecao' => colecao,
                'nivel' => nivel,
                'origem' => origem
            });
        }

        return result;
    }

    @AuraEnabled
    public static Map<String, Object> registrarResposta(Id questaoId, Boolean acertou) {
        Id currentUserId = UserInfo.getUserId();
        List<ProgressoQuestaoUsuario__c> progressos = [
            SELECT Id, Intervalo__c, ProximaRevisao__c
            FROM ProgressoQuestaoUsuario__c
            WHERE Questao__c = :questaoId AND OwnerId = :currentUserId
            LIMIT 1
        ];

        Integer intervaloAtual = 0;
        ProgressoQuestaoUsuario__c progresso;
        if (!progressos.isEmpty()) {
            progresso = progressos[0];
            intervaloAtual = progresso.Intervalo__c == null ? 0 : progresso.Intervalo__c.intValue();
        } else {
            progresso = new ProgressoQuestaoUsuario__c(
                Questao__c = questaoId,
                OwnerId = currentUserId,
                Name = String.valueOf(questaoId).left(40)
            );
        }

        Integer novoIntervalo;
        if (acertou) {
            if (intervaloAtual <= 1)       novoIntervalo = 3;
            else if (intervaloAtual <= 3)  novoIntervalo = 7;
            else if (intervaloAtual <= 7)  novoIntervalo = 14;
            else if (intervaloAtual <= 14) novoIntervalo = 30;
            else                           novoIntervalo = 60;
        } else {
            novoIntervalo = 1;
        }

        Date proximaRevisao = Date.today().addDays(novoIntervalo);
        progresso.Intervalo__c = novoIntervalo;
        progresso.ProximaRevisao__c = proximaRevisao;

        if (progresso.Id == null) {
            insert progresso;
        } else {
            update progresso;
        }

        insert new TentativaQuestao__c(
            Name = String.valueOf(System.currentTimeMillis()).left(80),
            OwnerId = currentUserId,
            Questao__c = questaoId,
            ProgressoQuestaoUsuario__c = progresso.Id,
            RespondidaEm__c = DateTime.now(),
            NotaQualidade__c = acertou ? 5 : 1
        );

        return new Map<String, Object>{
            'intervalo' => novoIntervalo,
            'proximaRevisao' => String.valueOf(proximaRevisao)
        };
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getCertificacoes() {
        List<Map<String, Object>> result = new List<Map<String, Object>>();

        for (Certificacao__c c : [
            SELECT Id, Name
            FROM Certificacao__c
            ORDER BY Name ASC
        ]) {
            result.add(new Map<String, Object>{
                'id' => c.Id,
                'name' => c.Name
            });
        }

        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getTopicos(Id certificacaoId) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        if (certificacaoId == null) {
            return result;
        }
        
        for (DominioCertificacao__c d : [
            SELECT Id, Name
            FROM DominioCertificacao__c
            WHERE Certificacao__c = :certificacaoId
            ORDER BY Name ASC
        ]) {
            Map<String, Object> tMap = new Map<String, Object>();
            tMap.put('id', d.Id);
            tMap.put('name', d.Name);
            tMap.put('dominio', d.Name);
            result.add(tMap);
        }
        
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getSubtopicos(Id topicoId, Id dominioId) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        if (topicoId == null && dominioId == null) {
            return result;
        }

        Map<String, Schema.SObjectField> questaoFields = Schema.SObjectType.Questao__c.fields.getMap();
        String qSubtopicoField = pickField(questaoFields, new List<String>{ 'Subtopico__c', 'SubTopico__c', 'Subtema__c' });

        if (String.isBlank(qSubtopicoField)) {
            return result;
        }

        // Query dinâmica para buscar subtópicos e deduplicar em Apex
        String soql;
        if (dominioId != null) {
            soql = 'SELECT Id, ' + qSubtopicoField
                + ' FROM Questao__c WHERE DominioPrincipal__c = :dominioId ORDER BY CreatedDate ASC';
        } else {
            soql = 'SELECT Id, ' + qSubtopicoField
                + ' FROM Questao__c WHERE TopicoPrincipal__c = :topicoId ORDER BY CreatedDate ASC';
        }

        Set<String> subtopicosVistos = new Set<String>();
        Integer ordem = 0;
        for (SObject q : Database.query(soql)) {
            String subtopico = getStringValue(q, qSubtopicoField);
            if (String.isBlank(subtopico) || subtopicosVistos.contains(subtopico)) {
                continue;
            }
            subtopicosVistos.add(subtopico);
            result.add(new Map<String, Object>{
                'id' => subtopico,
                'name' => subtopico,
                'ordem' => ordem++
            });
        }

        return result;
    }
}