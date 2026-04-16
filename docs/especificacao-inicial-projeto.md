# Especificação inicial do projeto de estudos Salesforce / Data Cloud

## 1. Visão geral

Este projeto terá como objetivo central apoiar meus estudos para a certificação **Salesforce Data Cloud** e, futuramente, outras certificações do ecossistema Salesforce.

A proposta é construir uma solução dentro da própria plataforma Salesforce, com uma experiência de uso via **Digital Experience**, permitindo estudar questões, revisar conteúdo e acompanhar a evolução com base em **memorização espaçada**, inspirada na metodologia do **Anki**.

---

## 2. Objetivo final

Construir um **site no Digital Experience** para estudo de questões e revisão de conteúdo, com as seguintes características iniciais:

- acesso inicialmente restrito apenas a mim;
- autenticação obrigatória para entrar na experiência;
- ambiente privado, sem exposição pública de conteúdo;
- foco em estudo recorrente de questões e revisão inteligente;
- estrutura preparada para evoluir depois para outras certificações Salesforce.

---

## 3. Escopo inicial (MVP)

A primeira versão do projeto deve contemplar:

- cadastro e organização de questões de estudo;
- categorização por certificação, tema e nível de dificuldade;
- registro das respostas e revisões;
- fila de revisão diária baseada em repetição espaçada;
- visualização simples das questões dentro do site;
- controle de acesso restrito a um único usuário inicial.

### Fora do escopo neste primeiro momento

- acesso aberto para múltiplos usuários;
- gamificação avançada;
- ranking;
- importação automatizada em massa;
- IA generativa para criação de questões;
- dashboards analíticos complexos.

---

## 4. Premissas do produto

- O projeto será usado inicialmente como **ambiente pessoal de estudos**.
- A arquitetura deve nascer simples, mas preparada para expansão.
- Mesmo com apenas um usuário inicial, a modelagem deve considerar crescimento futuro para múltiplos usuários.
- O conteúdo precisa ser organizado de forma a permitir estudo por:
  - certificação;
  - assunto;
  - domínio do exame;
  - nível de dificuldade;
  - histórico de revisão.

---

## 5. Estratégia de acesso no Digital Experience

### Regra inicial

A experiência deverá ser **privada**, com acesso permitido somente ao meu usuário.

### Diretrizes iniciais

- desabilitar auto cadastro;
- restringir publicação de páginas e conteúdo para usuários autenticados;
- permitir login apenas para o usuário configurado para o projeto;
- manter o site preparado para futura expansão para outros perfis/usuários.

### Evolução futura possível

No futuro, o projeto poderá evoluir para:

- múltiplos usuários;
- trilhas de estudo por perfil;
- áreas específicas por certificação;
- relatórios comparativos por usuário.

---

## 6. Proposta de modelagem de dados inicial

A seguir está uma proposta inicial de modelagem de dados orientada ao cenário de estudo de questões com repetição espaçada.

## 6.1 Entidades principais

### `Certificacao__c`
Representa a certificação alvo de estudo.

**Campos sugeridos:**
- `Name`
- `Codigo__c`
- `Descricao__c`
- `Ativa__c`
- `Nivel__c`

**Exemplos:**
- Data Cloud Consultant
- AI Associate
- Administrator

### `Topico__c`
Representa um assunto ou domínio dentro de uma certificação.

**Campos sugeridos:**
- `Name`
- `Certificacao__c` (Lookup)
- `Descricao__c`
- `PesoRelativo__c`
- `Ativo__c`

**Exemplos para Data Cloud:**
- Data Ingestion
- Identity Resolution
- Segmentation
- Activation
- Insights

### `Questao__c`
Representa a questão de estudo.

**Campos sugeridos:**
- `Name`
- `Certificacao__c` (Lookup)
- `Topico__c` (Lookup)
- `Enunciado__c` (Long Text Area ou Rich Text)
- `TipoQuestao__c` (Picklist: múltipla escolha, verdadeiro/falso, múltipla resposta)
- `NivelDificuldade__c` (Picklist)
- `Fonte__c`
- `Explicacao__c` (Long Text Area)
- `Ativa__c`
- `PossuiMidia__c`

### `Alternativa__c`
Representa as alternativas vinculadas a uma questão.

**Campos sugeridos:**
- `Name`
- `Questao__c` (Master-Detail ou Lookup)
- `Texto__c`
- `Correta__c`
- `Ordem__c`

### `RevisaoQuestao__c`
Representa o estado de revisão de uma questão para um usuário.

> Mesmo com apenas um usuário no início, esta entidade já deve nascer preparada para suportar revisão por usuário.

**Campos sugeridos:**
- `Name`
- `Questao__c` (Lookup)
- `User__c` ou referência equivalente ao usuário/contato
- `DataUltimaRevisao__c`
- `DataProximaRevisao__c`
- `IntervaloDias__c`
- `FatorFacilidade__c`
- `RepeticoesConsecutivas__c`
- `Status__c` (Nova, Aprendendo, Revisando, Em Reforco)
- `AcertosConsecutivos__c`
- `ErrosConsecutivos__c`

### `TentativaQuestao__c`
Representa cada resposta dada pelo usuário durante o estudo.

**Campos sugeridos:**
- `Name`
- `Questao__c` (Lookup)
- `RevisaoQuestao__c` (Lookup)
- `RespondidaEm__c`
- `RespostaUsuario__c`
- `Acertou__c`
- `NotaQualidade__c` (0 a 5)
- `TempoRespostaSegundos__c`
- `Observacoes__c`

### `TagQuestao__c` (opcional)
Permite rotular questões com palavras-chave.

**Campos sugeridos:**
- `Name`
- `Questao__c` (Lookup)
- `Tag__c`

---

## 6.2 Relacionamentos principais

- Uma **Certificação** possui vários **Tópicos**.
- Uma **Certificação** possui várias **Questões**.
- Um **Tópico** possui várias **Questões**.
- Uma **Questão** possui várias **Alternativas**.
- Uma **Questão** possui vários registros de **Revisão** ao longo do tempo, considerando usuários diferentes.
- Uma **Revisão** possui várias **Tentativas**.

---

## 7. Metodologia de revisão baseada no Anki

A lógica de memorização espaçada será inspirada no **Anki**, com adaptação para o contexto do projeto.

## 7.1 Princípio

Em vez de revisar todas as questões sempre, o sistema apresentará com maior frequência:

- questões novas;
- questões respondidas incorretamente;
- questões com menor estabilidade de memorização.

Questões já consolidadas aparecerão em intervalos maiores.

## 7.2 Conceitos que devem ser armazenados

Para cada questão por usuário, o sistema deverá controlar:

- data da última revisão;
- data da próxima revisão;
- intervalo atual em dias;
- fator de facilidade;
- número de repetições consecutivas;
- qualidade da resposta na revisão.

## 7.3 Escala de qualidade sugerida

Inspirada no modelo do Anki/SM-2, cada revisão pode receber uma nota de qualidade de `0` a `5`:

- `0` = branco total;
- `1` = errou completamente;
- `2` = grande dificuldade;
- `3` = acertou com dificuldade;
- `4` = acertou com boa segurança;
- `5` = acertou com facilidade.

## 7.4 Regras iniciais sugeridas

### Quando a nota for menor que 3
- reiniciar a repetição;
- reduzir o intervalo;
- reagendar a questão para revisão em curto prazo.

### Quando a nota for 3 ou maior
- aumentar a contagem de repetições;
- recalcular o intervalo;
- recalcular o fator de facilidade;
- reagendar a próxima revisão para uma data futura maior.

## 7.5 Fórmula de referência

Pode-se adotar inicialmente uma variação do algoritmo **SM-2**:

- fator de facilidade inicial: `2.5`
- primeira repetição bem-sucedida: `1` dia
- segunda repetição bem-sucedida: `6` dias
- próximas: `intervalo anterior * fator de facilidade`

Atualização sugerida do fator de facilidade:

$$
EF' = EF + (0.1 - (5 - q) \times (0.08 + (5 - q) \times 0.02))
$$

Onde:

- $EF$ = fator de facilidade atual
- $EF'$ = novo fator de facilidade
- $q$ = nota da qualidade da resposta

Regra mínima:

$$
EF' \ge 1.3
$$

---

## 8. Fluxos funcionais iniciais

## 8.1 Fluxo de estudo diário

1. O usuário acessa o site.
2. O sistema exibe as questões vencidas para revisão no dia.
3. O usuário responde a questão.
4. O sistema registra a tentativa.
5. O sistema calcula a nota/qualidade da resposta.
6. O sistema recalcula a próxima revisão.
7. O usuário segue para a próxima questão da fila.

## 8.2 Fluxo de cadastro de questão

1. Criar a certificação, caso ainda não exista.
2. Criar ou selecionar o tópico.
3. Cadastrar a questão.
4. Cadastrar as alternativas.
5. Definir explicação/comentário de apoio.
6. Publicar a questão para uso na revisão.

---

## 9. Telas iniciais sugeridas para o Digital Experience

### Área autenticada
- **Home do estudo**
  - resumo do dia
  - quantidade de revisões pendentes
  - questões novas disponíveis

- **Fila de revisão**
  - enunciado
  - alternativas
  - resposta
  - feedback
  - próxima questão

- **Banco de questões**
  - filtros por certificação, tópico e dificuldade

- **Estatísticas básicas**
  - acertos e erros
  - revisões do dia
  - tópicos com mais dificuldade

- **Administração do conteúdo**
  - cadastro e manutenção de certificações
  - cadastro de tópicos
  - cadastro de questões e alternativas

---

## 10. Requisitos não funcionais iniciais

- solução simples de manter;
- modelagem preparada para crescimento futuro;
- performance adequada para uso individual;
- experiência de uso clara em desktop;
- segurança e privacidade do conteúdo;
- possibilidade de expansão para automações futuras.

---

## 11. Roadmap inicial sugerido

### Fase 1 — Fundação
- definir modelagem de dados;
- criar objetos e campos principais;
- preparar controle de acesso inicial;
- estruturar o Digital Experience privado.

### Fase 2 — Conteúdo
- cadastrar certificações e tópicos;
- cadastrar questões e alternativas;
- disponibilizar listagem e consulta.

### Fase 3 — Revisão espaçada
- implementar lógica de revisão baseada no Anki;
- calcular próxima revisão;
- criar fila diária de estudo.

### Fase 4 — Evolução
- métricas de desempenho;
- refinamento da experiência;
- expansão para novas certificações;
- eventual suporte a múltiplos usuários.

---

## 12. Decisões iniciais registradas

- O projeto será um **ambiente pessoal de estudos**.
- O canal principal de acesso será um **site em Digital Experience**.
- Inicialmente, **somente eu terei acesso** ao sistema.
- O domínio funcional inicial será **questões de certificação Salesforce**, começando por **Data Cloud**.
- A mecânica principal de revisão será baseada em **memorização espaçada no estilo Anki**.
- A modelagem deve nascer simples, porém já preparada para expansão futura.

---

## 13. Próximos passos recomendados

1. Validar esta especificação inicial.
2. Definir a modelagem final dos objetos customizados.
  - detalhamento refinado em `docs/modelagem-dados-estudo.md`
3. Criar os metadados base dos objetos e campos.
4. Definir como o usuário autenticado será representado no site.
5. Desenhar o primeiro fluxo de revisão diária.
6. Criar uma primeira massa de questões para Data Cloud.
