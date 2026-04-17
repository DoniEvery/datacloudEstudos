public with sharing class QuestaoEstudoController {
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
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getQuestoes(Id topicoId) {
        List<Map<String, Object>> result = new List<Map<String, Object>>();

        Map<String, Schema.SObjectField> questaoFields = Schema.SObjectType.Questao__c.fields.getMap();
        String qTextoField = pickField(questaoFields, new List<String>{ 'Enunciado__c', 'TextoQuestao__c', 'Pergunta__c', 'Name' });
        String qNivelField = pickField(questaoFields, new List<String>{ 'NivelDificuldade__c' });
        String qExplicacaoField = pickField(questaoFields, new List<String>{ 'ExplicacaoResposta__c', 'Explicacao__c' });
        String qAtivaField = pickField(questaoFields, new List<String>{ 'Ativa__c', 'Ativo__c' });

        List<String> qSelectFields = new List<String>{ 'Id', 'Name' };
        if (!String.isBlank(qTextoField) && !qSelectFields.contains(qTextoField)) qSelectFields.add(qTextoField);
        if (!String.isBlank(qNivelField) && !qSelectFields.contains(qNivelField)) qSelectFields.add(qNivelField);
        if (!String.isBlank(qExplicacaoField) && !qSelectFields.contains(qExplicacaoField)) qSelectFields.add(qExplicacaoField);
        if (!String.isBlank(qAtivaField) && !qSelectFields.contains(qAtivaField)) qSelectFields.add(qAtivaField);

        String qSoql = 'SELECT ' + String.join(qSelectFields, ', ')
            + ' FROM Questao__c WHERE TopicoPrincipal__c = :topicoId';
        qSoql += ' ORDER BY CreatedDate ASC';

        List<SObject> questoes = Database.query(qSoql);

        Map<String, Schema.SObjectField> alternativaFields = Schema.SObjectType.AlternativaQuestao__c.fields.getMap();
        String aTextoField = pickField(alternativaFields, new List<String>{ 'TextoAlternativa__c', 'Texto__c', 'Descricao__c', 'Name' });
        List<String> aCorretaCandidates = new List<String>{ 'Correta__c', 'AlternativaCorreta__c', 'Correto__c' };
        String aCorretaField = pickField(alternativaFields, aCorretaCandidates);
        String aOrdemField = pickField(alternativaFields, new List<String>{ 'OrdemExibicao__c', 'Ordem__c' });
        String aAtivaField = pickField(alternativaFields, new List<String>{ 'Ativa__c', 'Ativo__c' });

        List<String> aSelectFields = new List<String>{ 'Id', 'Name', 'Questao__c' };
        if (!String.isBlank(aTextoField) && !aSelectFields.contains(aTextoField)) aSelectFields.add(aTextoField);
        for (String aCorretaCandidate : aCorretaCandidates) {
            if (alternativaFields.containsKey(aCorretaCandidate) && !aSelectFields.contains(aCorretaCandidate)) {
                aSelectFields.add(aCorretaCandidate);
            }
        }
        if (!String.isBlank(aOrdemField) && !aSelectFields.contains(aOrdemField)) aSelectFields.add(aOrdemField);
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

                alternativasPorQuestao.get(qId).add(altMap);
            }
        }

        for (SObject q : questoes) {
            Map<String, Object> qMap = new Map<String, Object>();
            Id qId = (Id) q.get('Id');
            qMap.put('id', qId);

            String enunciado = getStringValue(q, qTextoField);
            if (String.isBlank(enunciado)) {
                enunciado = getStringValue(q, 'Name');
            }
            qMap.put('enunciado', enunciado);
            qMap.put('nivel', getStringValue(q, qNivelField));
            qMap.put('explicacao', getStringValue(q, qExplicacaoField));
            qMap.put('alternativas', alternativasPorQuestao.containsKey(qId) ? alternativasPorQuestao.get(qId) : new List<Map<String, Object>>());
            result.add(qMap);
        }

        return result;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getTopicos() {
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        
        for (Topico__c t : [
            SELECT Id, Name, DominioCertificacao__c, DominioCertificacao__r.Name
            FROM Topico__c
            WHERE Ativo__c = true
            ORDER BY OrdemExibicao__c ASC
        ]) {
            Map<String, Object> tMap = new Map<String, Object>();
            tMap.put('id', t.Id);
            tMap.put('name', t.Name);
            tMap.put('dominio', t.DominioCertificacao__r.Name);
            result.add(tMap);
        }
        
        return result;
    }
}
