# Especificação de objetos e campos — MVP

Este documento detalha, campo por campo, a estrutura de dados do MVP da plataforma de estudos.

---

## 1. `Certificacao__c`

**Descrição:** Certificação alvo de estudo (ex: Data Cloud, Administrator, etc)

**Tipo:** Objeto customizado

| Campo | Tipo | Obrigatório | Padrão | Descrição |
|-------|------|-------------|--------|-----------|
| `Name` | Text | Sim | — | Nome da certificação (ex: "Data Cloud Consultant") |
| `Codigo__c` | Text | Não | — | Código interno (ex: "DC-001") |
| `Descricao__c` | Long Text Area | Não | — | Descrição detalhada |
| `Nivel__c` | Picklist | Não | — | Valores: `Associate`, `Professional`, `Architect` |
| `Ativa__c` | Checkbox | Não | true | Se está ativa para estudo |
| `OrdemExibicao__c` | Number(3,0) | Não | 999 | Ordem de exibição no seletor |

**Relacionamentos:** Parent em `DominioCertificacao__c`, `Topico__c`, `Questao__c`

---

## 2. `DominioCertificacao__c`

**Descrição:** Domínios ou macro áreas da certificação (ex: Data Ingestion, Identity Resolution)

**Tipo:** Objeto customizado

**Relacionamento com `Certificacao__c`:** Master-Detail (obrigatório)

| Campo | Tipo | Obrigatório | Padrão | Descrição |
|-------|------|-------------|--------|-----------|
| `Name` | Text | Sim | — | Nome do domínio |
| `Certificacao__c` | Master-Detail | Sim | — | Vinculação à certificação (master) |
| `Codigo__c` | Text | Não | — | Código do domínio |
| `Descricao__c` | Long Text Area | Não | — | Descrição do domínio |
| `PesoProva__c` | Number(5,2) | Não | — | Percentual de peso na prova (ex: 20.5) |
| `Ativo__c` | Checkbox | Não | true | Se está ativo |
| `OrdemExibicao__c` | Number(3,0) | Não | 999 | Ordem de exibição |

**Relacionamentos:** Child de `Certificacao__c`, Parent em `Topico__c`, `Questao__c`

---

## 3. `Topico__c`

**Descrição:** Tópicos granulares dentro de um domínio

**Tipo:** Objeto customizado

**Relacionamento com `DominioCertificacao__c`:** Lookup (obrigatório)

| Campo | Tipo | Obrigatório | Padrão | Descrição |
|-------|------|-------------|--------|-----------|
| `Name` | Text | Sim | — | Nome do tópico |
| `DominioCertificacao__c` | Lookup | Sim | — | Vinculação ao domínio |
| `Descricao__c` | Long Text Area | Não | — | Descrição do tópico |
| `EhTopicoCritico__c` | Checkbox | Não | false | Marca tópicos de importância crítica |
| `Ativo__c` | Checkbox | Não | true | Se está ativo |
| `OrdemExibicao__c` | Number(3,0) | Não | 999 | Ordem de exibição |

**Relacionamentos:** Child de `DominioCertificacao__c`, Parent em `Questao__c`

---

## 4. `Questao__c`

**Descrição:** Questão de estudo (unidade principal)

**Tipo:** Objeto customizado

| Campo | Tipo | Obrigatório | Padrão | Descrição |
|-------|------|-------------|--------|-----------|
| `Name` | Text | Sim | — | Identificador curto (ex: "Q-001", "DC-001") |
| `CodigoInterno__c` | Text | Não | — | Código único interno (único ao longo do objeto) |
| `Certificacao__c` | Lookup | Sim | — | Certificação principal |
| `DominioPrincipal__c` | Lookup | Sim | — | Domínio principal |
| `TopicoPrincipal__c` | Lookup | Sim | — | Tópico principal |
| `Enunciado__c` | Long Text Area | Sim | — | Enunciado da questão |
| `TipoQuestao__c` | Picklist | Sim | — | Valores: `MultiplaEscolha`, `MultiplaResposta`, `VerdadeiroFalso`, `Flashcard` |
| `NivelDificuldade__c` | Picklist | Sim | `Media` | Valores: `Muito Facil`, `Facil`, `Media`, `Dificil`, `Muito Dificil` |
| `ExplicacaoResposta__c` | Long Text Area | Sim | — | Explicação detalhada da resposta correta |
| `JustificativaOficial__c` | Long Text Area | Não | — | Justificativa oficial (se aplicável) |
| `Fonte__c` | Text | Não | — | Origem da questão (ex: "Prova Oficial", "Estudo Pessoal") |
| `FonteURL__c` | Url | Não | — | URL de referência |
| `OrigemConteudo__c` | Picklist | Não | `Autoral` | Valores: `Autoral`, `Adaptado`, `Resumo`, `Referencia` |
| `StatusPublicacao__c` | Picklist | Não | `Rascunho` | Valores: `Rascunho`, `Publicado`, `Arquivado` |
| `Ativa__c` | Checkbox | Não | true | Se está ativa para estudo |
| `PossuiMidia__c` | Checkbox | Não | false | Se possui imagem ou outro media |
| `DataUltimaRevisaoConteudo__c` | Date | Não | — | Data da última revisão do conteúdo |
| `DataCriacao__c` | DateTime | Não | NOW() | Data de criação |

**Relacionamentos:** Child de `Certificacao__c`, `DominioCertificacao__c`, `Topico__c`, Parent em `AlternativaQuestao__c`, `ProgressoQuestaoUsuario__c`, `TentativaQuestao__c`

**Regras de validação esperadas:**
- `StatusPublicacao__c` só pode ser "Publicado" se `Ativa__c` = true
- Se `TipoQuestao__c` = "MultiplaEscolha", deve ter exatamente 1 alternativa com `Correta__c` = true
- Se `TipoQuestao__c` = "MultiplaResposta", deve ter pelo menos 2 alternativas com `Correta__c` = true

---

## 5. `AlternativaQuestao__c`

**Descrição:** Alternativas de resposta de uma questão

**Tipo:** Objeto customizado

**Relacionamento com `Questao__c`:** Master-Detail (obrigatório)

| Campo | Tipo | Obrigatório | Padrão | Descrição |
|-------|------|-------------|--------|-----------|
| `Name` | Text | Sim | — | Identificador (ex: "A", "B", "C" ou auto-gerado) |
| `Questao__c` | Master-Detail | Sim | — | Vinculação à questão (master) |
| `TextoAlternativa__c` | Long Text Area | Sim | — | Texto da alternativa |
| `Correta__c` | Checkbox | Sim | false | Marca se é uma resposta correta |
| `ExplicacaoAlternativa__c` | Long Text Area | Não | — | Explicação do porquê essa alternativa é certa/errada |
| `OrdemExibicao__c` | Number(3,0) | Sim | — | Ordem original (para embaralhamento) |
| `Ativa__c` | Checkbox | Não | true | Se está ativa |

**Relacionamentos:** Child de `Questao__c`, Parent em `TentativaAlternativa__c`

**Regras de validação esperadas:**
- Para múltipla escolha: exatamente 1 alternativa com `Correta__c` = true
- Para múltipla resposta: pelo menos 2 alternativas com `Correta__c` = true
- `OrdemExibicao__c` deve ser único dentro da questão

---

## 6. `ProgressoQuestaoUsuario__c`

**Descrição:** Estado de aprendizagem de uma questão para um usuário (o "questao-contact")

**Tipo:** Objeto customizado

| Campo | Tipo | Obrigatório | Padrão | Descrição |
|-------|------|-------------|--------|-----------|
| `Name` | Text | Sim | — | Auto-gerado (User + Questão) |
| `Usuario__c` | Lookup para User | Sim | — | Usuário proprietário do progresso |
| `Questao__c` | Lookup | Sim | — | Questão alvo |
| `StatusAprendizagem__c` | Picklist | Não | `Nova` | Valores: `Nova`, `Aprendendo`, `Revisando`, `Dominada`, `Suspensa` |
| `DificuldadePercebida__c` | Picklist | Não | — | Dificuldade conforme o usuário percebe: `Muito Facil`, `Facil`, `Media`, `Dificil`, `Muito Dificil` |
| `PesoPrioridade__c` | Number(8,2) | Não | 1.0 | Peso de prioridade para montagem da fila (afetado por erros) |
| `TotalErrosConsecutivos__c` | Number(3,0) | Não | 0 | Contador de erros consecutivos |
| `TotalTentativas__c` | Number(5,0) | Não | 0 | Total de tentativas (acertos + erros) |
| `TotalAcertos__c` | Number(5,0) | Não | 0 | Total de acertos |
| `TotalErros__c` | Number(5,0) | Não | 0 | Total de erros |
| `MaiorIntervaloDias__c` | Number(8,2) | Não | 0 | Maior intervalo alcançado |
| `DataPrimeiroContato__c` | DateTime | Não | — | Data do primeiro contato com a questão |
| `DataUltimaRevisao__c` | DateTime | Não | — | Data da última revisão |
| `DataProximaRevisao__c` | DateTime | Não | — | Data agendada para próxima revisão |
| `IntervaloAtualDias__c` | Number(8,2) | Não | 0 | Intervalo atual em dias |
| `FatorFacilidade__c` | Number(8,2) | Não | 2.5 | Fator de facilidade (SM-2) |
| `RepeticoesConsecutivas__c` | Number(3,0) | Não | 0 | Número de repetições bem-sucedidas consecutivas |
| `UltimaNotaQualidade__c` | Number(1,0) | Não | — | Última nota de qualidade (0-5) |
| `UltimoResultadoCorreto__c` | Checkbox | Não | false | Se a última tentativa foi correta |
| `PrioridadeManual__c` | Picklist | Não | `Normal` | Valores: `Alta`, `Normal`, `Baixa` (sobrescreve cálculo) |
| `Suspensa__c` | Checkbox | Não | false | Se a questão está suspensa do estudo |
| `ObservacaoPessoal__c` | Long Text Area | Não | — | Anotações pessoais sobre a questão |

**Relacionamentos:** Parent em `TentativaQuestao__c`

**Índices únicos recomendados:**
- `Usuario__c` + `Questao__c` (garantir 1:1)

**Regras de validação esperadas:**
- Cada combinação `Usuario__c` + `Questao__c` deve ser única
- `DataProximaRevisao__c` ≥ `DataUltimaRevisao__c`
- `FatorFacilidade__c` ≥ 1.3
- `UltimaNotaQualidade__c` deve estar entre 0 e 5

---

## 7. `TentativaQuestao__c`

**Descrição:** Cada tentativa/resposta do usuário a uma questão

**Tipo:** Objeto customizado

| Campo | Tipo | Obrigatório | Padrão | Descrição |
|-------|------|-------------|--------|-----------|
| `Name` | Text | Sim | — | Auto-gerado (ex: "T-001", "Q-001-001") |
| `Usuario__c` | Lookup para User | Sim | — | Usuário que respondeu |
| `Questao__c` | Lookup | Sim | — | Questão respondida |
| `ProgressoQuestaoUsuario__c` | Lookup | Sim | — | Vinculação ao progresso (para facilitação) |
| `SessaoEstudo__c` | Lookup | Não | — | Sessão de estudo (se aplicável) |
| `RespondidaEm__c` | DateTime | Sim | NOW() | Data e hora da resposta |
| `Acertou__c` | Checkbox | Sim | — | Se a resposta foi correta |
| `NotaQualidade__c` | Number(1,0) | Sim | — | Nota de qualidade dada (0-5) |
| `AutoClassificacaoDificuldade__c` | Picklist | Não | — | Como o usuário classificou: `Muito Facil`, `Facil`, `Media`, `Dificil`, `Muito Dificil` |
| `TempoRespostaSegundos__c` | Number(5,0) | Não | — | Tempo gasto em segundos |
| `IntervaloAntesDias__c` | Number(8,2) | Não | — | Intervalo em dias antes desta tentativa |
| `IntervaloDepoisDias__c` | Number(8,2) | Não | — | Intervalo calculado após esta tentativa |
| `FatorAntes__c` | Number(8,2) | Não | — | Fator de facilidade antes |
| `FatorDepois__c` | Number(8,2) | Não | — | Fator de facilidade depois |
| `StatusAntes__c` | Text | Não | — | Status do progresso antes da tentativa |
| `StatusDepois__c` | Text | Não | — | Status do progresso depois da tentativa |
| `Observacoes__c` | Long Text Area | Não | — | Observações livres do usuário |

**Relacionamentos:** Child de `ProgressoQuestaoUsuario__c`, Parent em `TentativaAlternativa__c`

**Regras de validação esperadas:**
- `NotaQualidade__c` deve estar entre 0 e 5
- Se `Questao__c.TipoQuestao__c` = "Flashcard", permite não ter alternativas

---

## 8. `TentativaAlternativa__c`

**Descrição:** Alternativas marcadas pelo usuário em uma tentativa específica

**Tipo:** Objeto customizado

**Relacionamento com `TentativaQuestao__c`:** Master-Detail (obrigatório)

| Campo | Tipo | Obrigatório | Padrão | Descrição |
|-------|------|-------------|--------|-----------|
| `Name` | Text | Sim | — | Auto-gerado |
| `TentativaQuestao__c` | Master-Detail | Sim | — | Vinculação à tentativa (master) |
| `AlternativaQuestao__c` | Lookup | Sim | — | Alternativa marcada |
| `Selecionada__c` | Checkbox | Sim | true | Registra que foi selecionada |
| `CorretaNoMomento__c` | Checkbox | Não | — | Se a alternativa é correta segundo o banco |

**Relacionamentos:** Child de `TentativaQuestao__c`

**Regras de validação esperadas:**
- Toda `TentativaQuestao__c` deve ter ao menos uma `TentativaAlternativa__c` (exceto Flashcard)
- `AlternativaQuestao__c` deve pertencer à mesma `Questao__c` da tentativa

---

## 9. `SessaoEstudo__c` *(Recomendado para MVP)*

**Descrição:** Sessão de estudo iniciada pelo usuário

**Tipo:** Objeto customizado

| Campo | Tipo | Obrigatório | Padrão | Descrição |
|-------|------|-------------|--------|-----------|
| `Name` | Text | Sim | — | Auto-gerado (ex: "Sessão-2026-04-16-10:30") |
| `Usuario__c` | Lookup para User | Sim | — | Usuário da sessão |
| `Certificacao__c` | Lookup | Não | — | Certificação estudada nesta sessão |
| `IniciadaEm__c` | DateTime | Sim | NOW() | Momento de início |
| `FinalizadaEm__c` | DateTime | Não | — | Momento de término |
| `TipoSessao__c` | Picklist | Não | `RevisaoDiaria` | Valores: `RevisaoDiaria`, `TreinoLivre`, `Simulado`, `Reforco` |
| `QuantidadeQuestoes__c` | Number(4,0) | Não | 0 | Total de questões respondidas |
| `QuantidadeAcertos__c` | Number(4,0) | Não | 0 | Total de acertos |
| `QuantidadeErros__c` | Number(4,0) | Não | 0 | Total de erros |
| `DuracaoMinutos__c` | Number(5,0) | Não | — | Duração calculada em minutos |
| `Ativa__c` | Checkbox | Não | true | Se a sessão está em andamento |

**Relacionamentos:** Parent em `TentativaQuestao__c`

---

## Resumo de objetos do MVP

| Objeto | Tipo | Essencial | Observação |
|--------|------|-----------|-----------|
| `Certificacao__c` | Custom | ✅ | Base para classificação |
| `DominioCertificacao__c` | Custom | ✅ | Estrutura da prova |
| `Topico__c` | Custom | ✅ | Granularidade de estudo |
| `Questao__c` | Custom | ✅ | Núcleo de conteúdo |
| `AlternativaQuestao__c` | Custom | ✅ | Respostas da questão |
| `ProgressoQuestaoUsuario__c` | Custom | ✅ | Estado do usuário (questao-contact) |
| `TentativaQuestao__c` | Custom | ✅ | Histórico de respostas |
| `TentativaAlternativa__c` | Custom | ✅ | Detalhe de cada resposta |
| `SessaoEstudo__c` | Custom | ⭐ | Recomendado para analytics |

---

## Relacionamentos em diagrama

```
Certificacao__c
├── 1:N DominioCertificacao__c (Master-Detail)
│   └── 1:N Topico__c (Lookup)
│       └── 1:N Questao__c
├── 1:N Questao__c (Lookup direto)
└── 1:N ProgressoQuestaoUsuario__c (via Questao)

Questao__c
├── 1:N AlternativaQuestao__c (Master-Detail)
│   └── 1:N TentativaAlternativa__c (Lookup)
├── 1:N ProgressoQuestaoUsuario__c (Lookup)
│   └── 1:N TentativaQuestao__c (Lookup)
└── 1:N TentativaQuestao__c (Lookup)

User
├── 1:N ProgressoQuestaoUsuario__c (Lookup)
├── 1:N TentativaQuestao__c (Lookup)
└── 1:N SessaoEstudo__c (Lookup)

SessaoEstudo__c
└── 1:N TentativaQuestao__c (Lookup)
```

---

## Campos computados / fórmulas recomendadas

### Em `ProgressoQuestaoUsuario__c`

- `TaxaAcerto__c` = `TotalAcertos__c` / `TotalTentativas__c` (em %)
- `ProximoRevisaoEhOjeBool__c` = IF(`DataProximaRevisao__c` <= TODAY(), true, false)

### Em `SessaoEstudo__c`

- `TaxaAcertoSessao__c` = `QuantidadeAcertos__c` / `QuantidadeQuestoes__c` (em %)
- `DuracaoMinutos__c` = (FinalizadaEm__c - IniciadaEm__c) / 60

---

## Regras de acesso recomendadas

### Profile: "Estudante"
- Ler: `Certificacao__c`, `DominioCertificacao__c`, `Topico__c`, `Questao__c`, `AlternativaQuestao__c`
- Criar/Editar: `ProgressoQuestaoUsuario__c` (próprio), `TentativaQuestao__c` (próprio), `TentativaAlternativa__c` (próprio), `SessaoEstudo__c` (próprio)

### Profile: "Administrador de Conteúdo"
- CRUD completo em: `Certificacao__c`, `DominioCertificacao__c`, `Topico__c`, `Questao__c`, `AlternativaQuestao__c`
- Ler/Editar: `ProgressoQuestaoUsuario__c`, `TentativaQuestao__c`, `TentativaAlternativa__c`

---

## Índices recomendados

Para melhorar a performance das queries de estudo:

- `ProgressoQuestaoUsuario__c`: índice em (`Usuario__c`, `DataProximaRevisao__c`)
- `ProgressoQuestaoUsuario__c`: índice em (`Usuario__c`, `Certificacao__c`)
- `TentativaQuestao__c`: índice em (`Usuario__c`, `RespondidaEm__c`)
- `TentativaQuestao__c`: índice em (`ProgressoQuestaoUsuario__c`)

---

## Próximos passos

1. ✅ Modelagem validada
2. ⏳ Criar objetos customizados no Salesforce
3. ⏳ Criar campos em cada objeto
4. ⏳ Criar relacionamentos
5. ⏳ Criar validation rules
6. ⏳ Criar profiles de acesso
7. ⏳ Criar fórmulas/campos computados
8. ⏳ Criar layout de registros
9. ⏳ Preparar Digital Experience com permissões

Validou? Se tá ok, partimos para criar os objetos no `force-app/main/default/objects/`.
