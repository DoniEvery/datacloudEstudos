# Modelagem de dados refinada — plataforma de estudos Salesforce

## Objetivo deste documento

Este documento detalha a modelagem de dados recomendada para a primeira fase do projeto, com foco em:

- estudo de questões de certificação Salesforce;
- uso em **Digital Experience**;
- acesso inicialmente por um único usuário;
- suporte futuro para múltiplos usuários;
- revisão com **memorização espaçada** inspirada no **Anki / SM-2**.

A ideia aqui é sair de uma visão conceitual para uma modelagem mais próxima da implementação real em Salesforce.

---

## Ajuste da modelagem com base no fluxo real desejado

Com base no fluxo informado, o comportamento esperado do sistema é este:

1. o usuário entra no site;
2. escolhe a certificação que deseja estudar;
3. o sistema busca o histórico daquele usuário naquela certificação;
4. o sistema monta a lista de estudo do dia considerando:
   - dificuldade da questão;
   - tópico da certificação;
   - quantidade de erros anteriores na questão;
   - percepção do usuário sobre facilidade ou dificuldade;
5. as questões devem ser apresentadas em ordem aleatória;
6. as alternativas também devem poder ser embaralhadas para evitar decorar posição;
7. ao responder, o sistema precisa guardar:
   - se acertou ou errou;
   - qual alternativa ou quais alternativas marcou;
   - se ele classificou a questão como fácil, média ou difícil;
   - o histórico acumulado de erros/acertos;
8. se o usuário errar constantemente uma questão, o sistema deve elevar o peso de dificuldade dela para aquele usuário.

Esse fluxo muda uma recomendação importante:

- faz sentido existir um objeto de junção entre **usuário e questão**;
- mas não recomendo um objeto direto de junção entre **alternativa e usuário** sem passar por uma tentativa.

O motivo é simples: o usuário pode marcar a mesma alternativa várias vezes ao longo do tempo, em tentativas diferentes. Então o histórico correto não é `Alternativa <-> Usuário`, e sim:

`TentativaQuestao__c` -> `TentativaAlternativa__c` -> `AlternativaQuestao__c`

Isso preserva o tempo, a sessão e o contexto de cada resposta.

---

## Princípios de modelagem

Para este projeto, a modelagem deve seguir estes princípios:

1. **Separar conteúdo de desempenho do usuário**  
   Questão, alternativa, tópico e certificação pertencem ao catálogo. Já tentativas, progresso e revisões pertencem ao histórico individual do usuário.

2. **Manter um histórico append-only de tentativas**  
   O estado atual da revisão pode mudar, mas o histórico de respostas não deve ser sobrescrito.

3. **Evitar duplicação de estado quando possível**  
   A fila de revisão deve vir do estado atual da questão para o usuário, e não de uma fila física redundante.

4. **Modelar pensando em multiusuário desde o início**  
   Mesmo começando com um usuário só, a estrutura deve suportar expansão sem retrabalho estrutural.

5. **Nascer simples no MVP**  
   Nem tudo que é possível precisa existir já na primeira versão. O objetivo é começar com o núcleo certo.

---

## Visão em camadas

A modelagem fica mais clara se separarmos em 3 blocos:

### 1. Catálogo de conteúdo
Define o que será estudado.

### 2. Estado de aprendizagem
Define como cada usuário está em relação a cada questão.

### 3. Histórico de interação
Registra cada resposta e revisão feita.

---

## Modelo recomendado

## Modelo recomendado para o seu caso

Se eu alinhar a modelagem ao que você descreveu literalmente, os objetos-base ficam assim:

### Núcleo mínimo
- `Certificacao__c`
- `Topico__c`
- `Questao__c`
- `AlternativaQuestao__c`
- `ProgressoQuestaoUsuario__c`
- `TentativaQuestao__c`
- `TentativaAlternativa__c`

### Complementares recomendados
- `DominioCertificacao__c` *(se quiser espelhar os domínios oficiais da prova)*
- `SessaoEstudo__c`

### Tradução da sua ideia para a modelagem

O que você chamou de:

- **questao-contact** -> eu recomendo modelar como `ProgressoQuestaoUsuario__c`
- **resposta-contact** -> eu recomendo modelar como `TentativaQuestao__c` + `TentativaAlternativa__c`

Essa pequena mudança evita um problema clássico: perder o histórico de múltiplas respostas do mesmo usuário para a mesma questão.

## 1. Catálogo de conteúdo

### `Certificacao__c`
Representa a certificação alvo.

**Papel no domínio:**
- agrupa conteúdos;
- organiza filtros;
- permite separar trilhas de estudo por exame.

**Campos recomendados:**
- `Name`
- `Codigo__c` — texto curto
- `Descricao__c` — Long Text Area
- `Fornecedor__c` — Picklist (`Salesforce`, `Trailhead`, etc., se fizer sentido)
- `Nivel__c` — Picklist
- `Ativa__c` — Checkbox
- `OrdemExibicao__c` — Number

**Observação:**
Mesmo que o foco inicial seja Data Cloud, vale manter este objeto genérico.

---

### `DominioCertificacao__c`
Representa os domínios oficiais ou macro áreas de uma certificação.

**Exemplo:**
Para Data Cloud, poderia haver domínios como ingestão, modelagem, identity resolution, segmentação, insights, activation.

**Relacionamento recomendado:**
- `Certificacao__c` → `DominioCertificacao__c` = **Master-Detail**

**Campos recomendados:**
- `Name`
- `Certificacao__c`
- `Descricao__c`
- `PesoProva__c` — Percentual ou Number
- `Codigo__c`
- `Ativo__c`
- `OrdemExibicao__c`

**Por que manter este objeto?**
Porque ele aproxima a base de estudo da estrutura real da prova.

---

### `Topico__c`
Representa um tópico granular de estudo.

**Exemplo:**
- Data Streams
- Identity Resolution Rules
- Calculated Insights
- Activation Targets

**Relacionamento recomendado:**
- `DominioCertificacao__c` → `Topico__c` = **Lookup obrigatório**

**Campos recomendados:**
- `Name`
- `DominioCertificacao__c`
- `Descricao__c`
- `Ativo__c`
- `OrdemExibicao__c`
- `EhTopicoCritico__c` — Checkbox

**Decisão importante:**
Aqui estou assumindo um tópico vinculado a um domínio específico. Isso simplifica o filtro e reduz ambiguidade no MVP.

**Observação para o seu caso:**
Se quiser simplificar ainda mais a V1, `Topico__c` pode ser vinculado diretamente a `Certificacao__c`, sem passar por `DominioCertificacao__c` na primeira entrega.

---

### `Questao__c`
Representa a unidade principal de estudo.

**Esta é a entidade central do catálogo.**

**Campos recomendados:**
- `Name` — usar um identificador curto e amigável
- `CodigoInterno__c` — texto único opcional
- `Certificacao__c` — Lookup obrigatório
- `DominioPrincipal__c` — Lookup obrigatório
- `TopicoPrincipal__c` — Lookup obrigatório
- `Enunciado__c` — Long Text Area ou Rich Text
- `TipoQuestao__c` — Picklist (`MultiplaEscolha`, `MultiplaResposta`, `VerdadeiroFalso`, `Flashcard`)
- `NivelDificuldade__c` — Picklist (`Muito Facil`, `Facil`, `Media`, `Dificil`, `Muito Dificil`)
- `ExplicacaoResposta__c` — Long Text Area
- `JustificativaOficial__c` — Long Text Area opcional
- `Fonte__c` — texto curto
- `FonteURL__c` — URL
- `OrigemConteudo__c` — Picklist (`Autoral`, `Adaptado`, `Resumo`, `Referencia`)
- `StatusPublicacao__c` — Picklist (`Rascunho`, `Publicado`, `Arquivado`)
- `Ativa__c` — Checkbox
- `PossuiMidia__c` — Checkbox
- `DataUltimaRevisaoConteudo__c` — Date

**Por que manter `Certificacao__c`, `DominioPrincipal__c` e `TopicoPrincipal__c` na própria questão?**
Porque melhora filtros, relatórios e performance no uso diário.

**Decisão de MVP:**
No início, cada questão terá:
- uma certificação principal;
- um domínio principal;
- um tópico principal.

Isso evita começar com muitos relacionamentos N:N logo de cara.

**Ajuste importante para sua regra de estudo:**

Esta entidade deve guardar a **dificuldade base da questão**, ou seja, a dificuldade editorial do conteúdo.

Exemplo:
- uma questão pode nascer como `Media` no catálogo;
- para um usuário específico, ela pode se tornar `Dificil` no progresso individual.

Por isso, a dificuldade da questão deve ser tratada em dois níveis:

- dificuldade da questão no catálogo (`Questao__c`);
- dificuldade percebida / recalculada para o usuário (`ProgressoQuestaoUsuario__c`).

---

### `AlternativaQuestao__c`
Representa cada alternativa da questão.

**Relacionamento recomendado:**
- `Questao__c` → `AlternativaQuestao__c` = **Master-Detail**

**Campos recomendados:**
- `Name`
- `Questao__c`
- `TextoAlternativa__c` — Long Text Area
- `Correta__c` — Checkbox
- `OrdemExibicao__c` — Number
- `ExplicacaoAlternativa__c` — Long Text Area opcional
- `Ativa__c` — Checkbox

**Regras importantes:**
- múltipla escolha: exatamente 1 correta;
- múltipla resposta: 2 ou mais corretas quando aplicável;
- verdadeiro/falso: preferencialmente duas alternativas fixas;
- flashcard: pode não exigir alternativas.

**Regra adicional importante para UX:**
As alternativas podem ser exibidas em ordem aleatória na tela, mas a ordem original deve continuar salva no banco por `OrdemExibicao__c`.

---

### `Tag__c` *(opcional na fase 1, recomendada na fase 2)*
Representa marcadores livres para facilitar busca e agrupamento.

**Exemplos:**
- arquitetura
- identity
- ingestão
- activation
- prova oficial

**Campos recomendados:**
- `Name`
- `CategoriaTag__c`
- `Ativa__c`

---

### `QuestaoTag__c` *(opcional na fase 2)*
Objeto de junção entre questão e tag.

**Relacionamentos recomendados:**
- `Questao__c` — Master-Detail
- `Tag__c` — Lookup ou Master-Detail, conforme estratégia futura

**Quando criar este objeto?**
Quando os filtros por tópico principal deixarem de ser suficientes.

---

## 2. Estado de aprendizagem

### `ProgressoQuestaoUsuario__c`
Representa o estado atual de aprendizagem de **uma questão para um usuário**.

Este é o objeto mais importante da revisão espaçada.

**Cardinalidade desejada:**
- 1 usuário + 1 questão = 1 registro de progresso

**Relacionamentos recomendados:**
- `User` → `ProgressoQuestaoUsuario__c` = Lookup obrigatório
- `Questao__c` → `ProgressoQuestaoUsuario__c` = Lookup obrigatório

**Campos recomendados:**
- `Name`
- `Usuario__c` — Lookup para `User`
- `Questao__c`
- `StatusAprendizagem__c` — Picklist (`Nova`, `Aprendendo`, `Revisando`, `Dominada`, `Suspensa`)
- `DificuldadePercebida__c` — Picklist (`Muito Facil`, `Facil`, `Media`, `Dificil`, `Muito Dificil`)
- `PesoPrioridade__c` — Number(8,2)
- `TotalErrosConsecutivos__c` — Number
- `DataPrimeiroContato__c` — DateTime
- `DataUltimaRevisao__c` — DateTime
- `DataProximaRevisao__c` — DateTime
- `IntervaloAtualDias__c` — Number(8,2)
- `FatorFacilidade__c` — Number(8,2)
- `RepeticoesConsecutivas__c` — Number
- `TotalTentativas__c` — Number
- `TotalAcertos__c` — Number
- `TotalErros__c` — Number
- `MaiorIntervaloDias__c` — Number(8,2)
- `UltimaNotaQualidade__c` — Number
- `UltimoResultadoCorreto__c` — Checkbox
- `PrioridadeManual__c` — Picklist (`Alta`, `Normal`, `Baixa`)
- `Suspensa__c` — Checkbox
- `ObservacaoPessoal__c` — Long Text Area

**Por que este objeto deve existir?**
Porque ele centraliza o estado atual da questão para o usuário sem depender de recalcular tudo a partir do histórico a cada tela.

**Por que ele é o equivalente correto do seu `questao-contact`?**
Porque a ideia dele é exatamente ligar **um usuário** a **uma questão**, guardando o comportamento daquela questão para aquela pessoa.

Aqui entram regras como:

- quantas vezes o usuário errou;
- se ele está dominando ou não a questão;
- se considera a questão difícil ou fácil;
- quando a questão deve voltar no estudo;
- qual prioridade ela terá na montagem do estudo diário.

**Observação importante:**
A fila do dia pode ser montada consultando os registros em que `DataProximaRevisao__c <= NOW()` e `Suspensa__c = false`.

Além disso, a seleção pode ser refinada por:

- `Certificacao__c` da questão;
- tópico;
- peso de prioridade;
- quantidade de erros;
- dificuldade percebida.

**Conclusão prática:**
Não recomendo criar uma `FilaRevisao__c` física no MVP.

---

### `SessaoEstudo__c` *(opcional, mas muito útil)*
Representa uma sessão de estudo iniciada pelo usuário.

**Exemplos de uso:**
- agrupar tentativas de um mesmo período;
- medir duração da sessão;
- comparar sessões de estudo;
- separar revisão diária de treino livre.

**Campos recomendados:**
- `Name`
- `Usuario__c` — Lookup para `User`
- `IniciadaEm__c` — DateTime
- `FinalizadaEm__c` — DateTime
- `TipoSessao__c` — Picklist (`RevisaoDiaria`, `TreinoLivre`, `Simulado`, `Reforco`)
- `Certificacao__c` — Lookup opcional
- `QuantidadeQuestoes__c` — Number
- `QuantidadeAcertos__c` — Number
- `QuantidadeErros__c` — Number

**Decisão recomendada:**
Se quiser relatórios melhores desde cedo, este objeto vale muito a pena já no MVP.

---

## 3. Histórico de interação

### `TentativaQuestao__c`
Representa cada resposta do usuário a uma questão.

**Relacionamentos recomendados:**
- `Questao__c` — Lookup obrigatório
- `Usuario__c` — Lookup obrigatório para `User`
- `ProgressoQuestaoUsuario__c` — Lookup obrigatório
- `SessaoEstudo__c` — Lookup opcional

**Campos recomendados:**
- `Name`
- `Questao__c`
- `Usuario__c`
- `ProgressoQuestaoUsuario__c`
- `SessaoEstudo__c`
- `RespondidaEm__c` — DateTime
- `RespostaBruta__c` — Long Text Area
- `Acertou__c` — Checkbox
- `NotaQualidade__c` — Number
- `AutoClassificacaoDificuldade__c` — Picklist (`Muito Facil`, `Facil`, `Media`, `Dificil`, `Muito Dificil`)
- `TempoRespostaSegundos__c` — Number
- `IntervaloAntesDias__c` — Number(8,2)
- `IntervaloDepoisDias__c` — Number(8,2)
- `FatorAntes__c` — Number(8,2)
- `FatorDepois__c` — Number(8,2)
- `StatusAntes__c` — Text ou Picklist
- `StatusDepois__c` — Text ou Picklist
- `Observacoes__c` — Long Text Area

**Por que guardar os snapshots antes/depois?**
Porque isso facilita auditoria, debugging e análise da evolução do algoritmo sem depender apenas do estado atual.

**Papel deste objeto na sua ideia:**
Este objeto substitui a ideia de uma junção direta `resposta-contact` quando o objetivo é registrar o ato de responder.

Ele responde perguntas como:

- o usuário acertou ou errou?
- quando respondeu?
- como classificou a dificuldade?
- qual era o estado antes?
- como o estado ficou depois?

---

### `TentativaAlternativa__c`
Representa cada alternativa marcada pelo usuário dentro de uma tentativa.

Este objeto é especialmente importante para questões de múltipla resposta.

**Relacionamentos recomendados:**
- `TentativaQuestao__c` — Master-Detail obrigatório
- `AlternativaQuestao__c` — Lookup obrigatório

**Campos recomendados:**
- `Name`
- `TentativaQuestao__c`
- `AlternativaQuestao__c`
- `Selecionada__c` — Checkbox
- `CorretaNoMomento__c` — Checkbox

**Por que este objeto é melhor do que `resposta-contact` direto?**
Porque ele registra a alternativa escolhida em um contexto específico de tentativa.

Exemplo:

- hoje você marcou a alternativa A;
- amanhã marcou a C;
- depois marcou A e D numa questão de múltipla resposta.

Tudo isso fica historicamente preservado, sem sobrescrever relação entre usuário e resposta.

---

## Estrutura mínima recomendada para o MVP

Se o objetivo agora é acertar a estrutura sem inflar demais, eu recomendo começar com estes objetos:

### Essenciais
- `Certificacao__c`
- `Topico__c`
- `Questao__c`
- `AlternativaQuestao__c`
- `ProgressoQuestaoUsuario__c`
- `TentativaQuestao__c`
- `TentativaAlternativa__c`

### Fortemente recomendados
- `DominioCertificacao__c`
- `SessaoEstudo__c`

### Opcionais para depois
- `Tag__c`
- `QuestaoTag__c`

---

## O que eu recomendo evitar agora

Para o início, eu evitaria:

- criar uma tabela física de fila diária;
- criar N:N para tudo desde o dia 1;
- amarrar a questão a muitos tópicos antes de validar a operação real;
- armazenar cálculo de revisão em múltiplos objetos diferentes;
- criar objetos separados para acerto e erro quando uma tentativa já resolve isso.

Em resumo: **catálogo limpo + progresso atual + histórico detalhado**.

---

## Regras de integridade recomendadas

Estas regras devem existir, nem que inicialmente algumas sejam implementadas depois via validation rules ou automação:

1. `Questao__c` só pode ser publicada se estiver ativa.
2. `Questao__c` de múltipla escolha deve possuir exatamente 1 alternativa correta.
3. `Questao__c` de múltipla resposta deve possuir pelo menos 2 alternativas quando aplicável.
4. Cada combinação `Usuario__c + Questao__c` deve possuir apenas 1 `ProgressoQuestaoUsuario__c` ativo.
5. `DataProximaRevisao__c` não pode ser anterior à `DataUltimaRevisao__c`, salvo tratamento inicial para questões novas.
6. `FatorFacilidade__c` não deve ser menor que `1.3`.
7. `NotaQualidade__c` deve ficar entre `0` e `5`.
8. Cada `TentativaQuestao__c` deve possuir ao menos uma `TentativaAlternativa__c` quando o tipo da questão exigir alternativas.
9. `DificuldadePercebida__c` pode divergir da dificuldade base da questão.

---

## Estratégia de relacionamento: escolha recomendada

Se o objetivo é ter uma modelagem bem alinhada ao que você quer **sem complicar cedo demais**, esta é a escolha que eu considero mais equilibrada:

- `Questao__c` com **um domínio principal** e **um tópico principal**;
- `AlternativaQuestao__c` como filho direto da questão;
- `ProgressoQuestaoUsuario__c` como estado atual por usuário e questão;
- `TentativaQuestao__c` como trilha histórica da resposta;
- `TentativaAlternativa__c` como detalhamento das alternativas marcadas;
- `SessaoEstudo__c` para agrupamento e análise;
- `Tag__c` apenas quando sentir falta de filtros mais flexíveis.

Essa estrutura é simples, extensível e combina muito bem com Salesforce.

---

## Modelo lógico resumido

### Conteúdo
- `Certificacao__c` 1:N `DominioCertificacao__c`
- `DominioCertificacao__c` 1:N `Topico__c`
- `Certificacao__c` 1:N `Questao__c`
- `DominioCertificacao__c` 1:N `Questao__c` *(domínio principal)*
- `Topico__c` 1:N `Questao__c` *(tópico principal)*
- `Questao__c` 1:N `AlternativaQuestao__c`

### Aprendizagem
- `User` 1:N `ProgressoQuestaoUsuario__c`
- `Questao__c` 1:N `ProgressoQuestaoUsuario__c`

### Histórico
- `User` 1:N `TentativaQuestao__c`
- `Questao__c` 1:N `TentativaQuestao__c`
- `ProgressoQuestaoUsuario__c` 1:N `TentativaQuestao__c`
- `SessaoEstudo__c` 1:N `TentativaQuestao__c`
- `TentativaQuestao__c` 1:N `TentativaAlternativa__c`
- `AlternativaQuestao__c` 1:N `TentativaAlternativa__c`

---

## Decisões de implementação que já podem ser assumidas

### 1. Separar objetos de catálogo e objetos de uso
Sim, isso deve ser mantido.

### 2. Ter um objeto próprio para progresso
Sim, fortemente recomendado.

### 3. Ter um objeto próprio para tentativas
Sim, obrigatório se você quiser histórico confiável.

### 3.1 Ter um objeto para alternativas marcadas na tentativa
Sim, recomendado se houver múltipla resposta ou se você quiser rastrear exatamente o que foi selecionado.

### 4. Ter vários tópicos por questão logo no início
Não recomendo no MVP.

### 5. Criar fila materializada de revisão
Não recomendo no MVP.

### 6. Modelar já para múltiplos usuários
Sim, mas sem exagerar na complexidade inicial.

---

## Próximos passos ideais na construção da modelagem

1. Validar estes objetos-base.
2. Confirmar quais campos devem existir já na primeira entrega.
3. Definir quais objetos entram no MVP e quais ficam para fase 2.
4. Converter esta modelagem em metadata Salesforce.
5. Só então criar automações da repetição espaçada.

---

## Minha recomendação objetiva

Se eu fosse congelar a versão 1 da modelagem hoje, eu seguiria com:

- `Certificacao__c`
- `DominioCertificacao__c`
- `Topico__c`
- `Questao__c`
- `AlternativaQuestao__c`
- `ProgressoQuestaoUsuario__c`
- `TentativaQuestao__c`
- `TentativaAlternativa__c`
- `SessaoEstudo__c` *(se quiser analytics melhores desde o começo)*

Esse desenho te dá:

- catálogo bem organizado;
- trilha clara por certificação/domínio/tópico;
- revisão espaçada com estado atual consistente;
- histórico completo de aprendizagem;
- registro exato das alternativas marcadas;
- espaço para evoluir depois sem retrabalho pesado.
