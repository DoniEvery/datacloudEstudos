// =============================================================
// TEMPLATE — CRIAR QUESTÃO
// Preencha os valores marcados com ← e rode no Apex Execute
// =============================================================

// ------------------------------------------------------------------
// 1. IDs de contexto  (copie da org: Setup > Object Manager ou SOQL)
// ------------------------------------------------------------------
Id certificacaoId     = 'a00XX000000XXXXX';   // ← Certificacao__c.Id
Id dominioId          = 'a01XX000000XXXXX';   // ← DominioCertificacao__c.Id
Id topicoId           = 'a02XX000000XXXXX';   // ← Topico__c.Id

// ------------------------------------------------------------------
// 2. Questão principal
// ------------------------------------------------------------------
Questao__c q = new Questao__c(
    // Obrigatórios
    Name               = 'Q-001',              // ← código/identificador (único)
    Enunciado__c       = 'Qual opção descreve corretamente o conceito X?', // ← texto da pergunta
    Certificacao__c    = certificacaoId,
    DominioPrincipal__c = dominioId,
    TopicoPrincipal__c = topicoId,
    TipoQuestao__c     = 'MultiplaEscolha',    // MultiplaEscolha | MultiplaResposta | VerdadeiroFalso | Flashcard
    NivelDificuldade__c = 'Media',             // MuitoFacil | Facil | Media | Dificil | MuitoDificil

    // Opcionais mas recomendados
    Subtopico__c       = 'Conceito fundamental X', // ← subtópico dentro do subtema (Topico)
    ExplicacaoResposta__c = 'A opção A está correta porque X define Y de forma direta, conforme documentação oficial Z.', // ← explicação geral (fallback se alternativa não tiver explicação própria)
    Ativa__c           = true
);
insert q;
System.debug('Questao criada: ' + q.Id);

// ------------------------------------------------------------------
// 3. Alternativas  (1 correta + 3 erradas, ordem 1-4)
// ------------------------------------------------------------------

// Alternativa A — CORRETA
AlternativaQuestao__c a1 = new AlternativaQuestao__c(
    Questao__c           = q.Id,
    TextoAlternativa__c  = 'Texto da alternativa correta.',   // ← texto da opção
    Correta__c           = true,
    OrdemExibicao__c     = 1,
    ExplicacaoAlternativa__c = 'Esta é a correta porque...'  // ← (opcional) aparece ao clicar
);

// Alternativa B — ERRADA
AlternativaQuestao__c a2 = new AlternativaQuestao__c(
    Questao__c           = q.Id,
    TextoAlternativa__c  = 'Texto da primeira alternativa errada.',
    Correta__c           = false,
    OrdemExibicao__c     = 2,
    ExplicacaoAlternativa__c = 'Esta está errada porque...'  // ← (opcional)
);

// Alternativa C — ERRADA
AlternativaQuestao__c a3 = new AlternativaQuestao__c(
    Questao__c           = q.Id,
    TextoAlternativa__c  = 'Texto da segunda alternativa errada.',
    Correta__c           = false,
    OrdemExibicao__c     = 3,
    ExplicacaoAlternativa__c = 'Esta está errada porque...'  // ← (opcional)
);

// Alternativa D — ERRADA
AlternativaQuestao__c a4 = new AlternativaQuestao__c(
    Questao__c           = q.Id,
    TextoAlternativa__c  = 'Texto da terceira alternativa errada.',
    Correta__c           = false,
    OrdemExibicao__c     = 4,
    ExplicacaoAlternativa__c = 'Esta está errada porque...'  // ← (opcional)
);

insert new List<AlternativaQuestao__c>{ a1, a2, a3, a4 };
System.debug('Alternativas criadas. Questao: ' + q.Id);

// =============================================================
// REFERÊNCIA RÁPIDA
// =============================================================
// TipoQuestao__c    → MultiplaEscolha | MultiplaResposta | VerdadeiroFalso | Flashcard
// NivelDificuldade__c → MuitoFacil | Facil | Media | Dificil | MuitoDificil
//
// Regras de exibição no componente:
//   - ExplicacaoAlternativa__c  → aparece ao clicar na alternativa (1ª prioridade)
//   - ExplicacaoResposta__c     → aparece como fallback se alternativa não tiver explicação própria
//   - Se errou: mostra também a explicação da alternativa correta (se diferente)
//
// Onde achar os IDs:
//   SELECT Id, Name FROM Certificacao__c
//   SELECT Id, Name FROM DominioCertificacao__c WHERE Certificacao__c = '<certId>'
//   SELECT Id, Name FROM Topico__c WHERE DominioCertificacao__c = '<dominioId>'
// =============================================================
