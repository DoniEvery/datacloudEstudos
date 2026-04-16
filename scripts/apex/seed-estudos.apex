String suffix = String.valueOf(DateTime.now().getTime());
Id currentUserId = UserInfo.getUserId();

Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

void putIfExists(SObject rec, String fieldApi, Object value) {
    Map<String, Schema.SObjectField> fm = rec.getSObjectType().getDescribe().fields.getMap();
    if (fm.containsKey(fieldApi) && value != null) {
        rec.put(fieldApi, value);
    }
}

SObject cert = gd.get('Certificacao__c').newSObject();
putIfExists(cert, 'Name', 'Data Cloud Consultant ' + suffix);
putIfExists(cert, 'Codigo__c', 'DC-' + suffix.right(6));
putIfExists(cert, 'Descricao__c', 'Certificação de teste criada via seed');
putIfExists(cert, 'Nivel__c', 'Professional');
putIfExists(cert, 'Ativa__c', true);
putIfExists(cert, 'OrdemExibicao__c', 1);
insert cert;

SObject dominio = gd.get('DominioCertificacao__c').newSObject();
putIfExists(dominio, 'Name', 'Identity Resolution ' + suffix);
putIfExists(dominio, 'Certificacao__c', cert.Id);
putIfExists(dominio, 'Codigo__c', 'DOM-' + suffix.right(5));
putIfExists(dominio, 'Descricao__c', 'Domínio de teste');
putIfExists(dominio, 'PesoProva__c', 20);
putIfExists(dominio, 'Ativo__c', true);
putIfExists(dominio, 'OrdemExibicao__c', 1);
insert dominio;

SObject topico = gd.get('Topico__c').newSObject();
putIfExists(topico, 'Name', 'Regras de Identidade ' + suffix);
putIfExists(topico, 'DominioCertificacao__c', dominio.Id);
putIfExists(topico, 'Descricao__c', 'Tópico de teste');
putIfExists(topico, 'EhTopicoCritico__c', true);
putIfExists(topico, 'Ativo__c', true);
putIfExists(topico, 'OrdemExibicao__c', 1);
insert topico;

SObject questao = gd.get('Questao__c').newSObject();
putIfExists(questao, 'Name', 'Q-' + suffix.right(8));
putIfExists(questao, 'CodigoInterno__c', 'QINT-' + suffix);
putIfExists(questao, 'Certificacao__c', cert.Id);
putIfExists(questao, 'DominioPrincipal__c', dominio.Id);
putIfExists(questao, 'TopicoPrincipal__c', topico.Id);
putIfExists(questao, 'Enunciado__c', 'Qual opção descreve melhor identity resolution no Data Cloud?');
putIfExists(questao, 'TipoQuestao__c', 'MultiplaEscolha');
putIfExists(questao, 'NivelDificuldade__c', 'Media');
putIfExists(questao, 'ExplicacaoResposta__c', 'Identity resolution unifica perfis a partir de regras e matching.');
putIfExists(questao, 'JustificativaOficial__c', 'Justificativa de teste');
putIfExists(questao, 'Fonte__c', 'Seed Apex');
putIfExists(questao, 'FonteURL__c', 'https://example.com');
putIfExists(questao, 'OrigemConteudo__c', 'Autoral');
putIfExists(questao, 'StatusPublicacao__c', 'Publicado');
putIfExists(questao, 'Ativa__c', true);
putIfExists(questao, 'PossuiMidia__c', false);
putIfExists(questao, 'DataUltimaRevisaoConteudo__c', Date.today());
putIfExists(questao, 'DataCriacao__c', System.now());
insert questao;

SObject altA = gd.get('AlternativaQuestao__c').newSObject();
putIfExists(altA, 'Name', 'A');
putIfExists(altA, 'Questao__c', questao.Id);
putIfExists(altA, 'TextoAlternativa__c', 'Unifica dados de perfil com regras de matching');
putIfExists(altA, 'Correta__c', true);
putIfExists(altA, 'ExplicacaoAlternativa__c', 'Correta');
putIfExists(altA, 'OrdemExibicao__c', 1);
putIfExists(altA, 'Ativa__c', true);
insert altA;

SObject progresso = gd.get('ProgressoQuestaoUsuario__c').newSObject();
putIfExists(progresso, 'Name', 'P-' + suffix.right(8));
putIfExists(progresso, 'Usuario__c', currentUserId);
putIfExists(progresso, 'Questao__c', questao.Id);
putIfExists(progresso, 'StatusAprendizagem__c', 'Aprendendo');
putIfExists(progresso, 'DificuldadePercebida__c', 'Media');
putIfExists(progresso, 'PesoPrioridade__c', 1.20);
putIfExists(progresso, 'TotalErrosConsecutivos__c', 0);
putIfExists(progresso, 'TotalTentativas__c', 1);
putIfExists(progresso, 'TotalAcertos__c', 1);
putIfExists(progresso, 'TotalErros__c', 0);
putIfExists(progresso, 'MaiorIntervaloDias__c', 1);
putIfExists(progresso, 'DataPrimeiroContato__c', System.now().addDays(-1));
putIfExists(progresso, 'DataUltimaRevisao__c', System.now());
putIfExists(progresso, 'DataProximaRevisao__c', System.now().addDays(1));
putIfExists(progresso, 'IntervaloAtualDias__c', 1);
putIfExists(progresso, 'FatorFacilidade__c', 2.50);
putIfExists(progresso, 'RepeticoesConsecutivas__c', 1);
putIfExists(progresso, 'UltimaNotaQualidade__c', 4);
putIfExists(progresso, 'UltimoResultadoCorreto__c', true);
putIfExists(progresso, 'PrioridadeManual__c', 'Normal');
putIfExists(progresso, 'Suspensa__c', false);
putIfExists(progresso, 'ObservacaoPessoal__c', 'Registro seed');
insert progresso;

SObject sessao = gd.get('SessaoEstudo__c').newSObject();
putIfExists(sessao, 'Name', 'Sessao-' + suffix.right(8));
putIfExists(sessao, 'Usuario__c', currentUserId);
putIfExists(sessao, 'Certificacao__c', cert.Id);
putIfExists(sessao, 'IniciadaEm__c', System.now().addMinutes(-10));
putIfExists(sessao, 'FinalizadaEm__c', System.now());
putIfExists(sessao, 'TipoSessao__c', 'RevisaoDiaria');
putIfExists(sessao, 'QuantidadeQuestoes__c', 1);
putIfExists(sessao, 'QuantidadeAcertos__c', 1);
putIfExists(sessao, 'QuantidadeErros__c', 0);
putIfExists(sessao, 'DuracaoMinutos__c', 10);
putIfExists(sessao, 'Ativa__c', false);
insert sessao;

SObject tentativa = gd.get('TentativaQuestao__c').newSObject();
putIfExists(tentativa, 'Name', 'T-' + suffix.right(8));
putIfExists(tentativa, 'Usuario__c', currentUserId);
putIfExists(tentativa, 'Questao__c', questao.Id);
putIfExists(tentativa, 'ProgressoQuestaoUsuario__c', progresso.Id);
putIfExists(tentativa, 'SessaoEstudo__c', sessao.Id);
putIfExists(tentativa, 'RespondidaEm__c', System.now());
putIfExists(tentativa, 'Acertou__c', true);
putIfExists(tentativa, 'NotaQualidade__c', 4);
putIfExists(tentativa, 'AutoClassificacaoDificuldade__c', 'Media');
putIfExists(tentativa, 'TempoRespostaSegundos__c', 42);
putIfExists(tentativa, 'IntervaloAntesDias__c', 0);
putIfExists(tentativa, 'IntervaloDepoisDias__c', 1);
putIfExists(tentativa, 'FatorAntes__c', 2.5);
putIfExists(tentativa, 'FatorDepois__c', 2.6);
putIfExists(tentativa, 'StatusAntes__c', 'Nova');
putIfExists(tentativa, 'StatusDepois__c', 'Aprendendo');
putIfExists(tentativa, 'Observacoes__c', 'Tentativa criada via seed');
insert tentativa;

SObject tentativaAlt = gd.get('TentativaAlternativa__c').newSObject();
putIfExists(tentativaAlt, 'Name', 'TA-' + suffix.right(8));
putIfExists(tentativaAlt, 'TentativaQuestao__c', tentativa.Id);
putIfExists(tentativaAlt, 'AlternativaQuestao__c', altA.Id);
putIfExists(tentativaAlt, 'Selecionada__c', true);
putIfExists(tentativaAlt, 'CorretaNoMomento__c', true);
insert tentativaAlt;

System.debug('SEED OK => Certificacao: ' + cert.Id + ', Dominio: ' + dominio.Id + ', Topico: ' + topico.Id + ', Questao: ' + questao.Id + ', Alternativa: ' + altA.Id + ', Progresso: ' + progresso.Id + ', Sessao: ' + sessao.Id + ', Tentativa: ' + tentativa.Id + ', TentativaAlt: ' + tentativaAlt.Id);