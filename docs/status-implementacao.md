# Status de implementação — Doni APP (Salesforce)

## Resumo

Este documento consolida o que foi implementado até agora no projeto de estudos para certificações Salesforce.

---

## 1) Modelagem criada

Foram criados os objetos customizados abaixo:

- `Certificacao__c`
- `DominioCertificacao__c`
- `Topico__c`
- `Questao__c`
- `AlternativaQuestao__c`
- `ProgressoQuestaoUsuario__c`
- `SessaoEstudo__c`
- `TentativaQuestao__c`
- `TentativaAlternativa__c`

Com relacionamentos entre si para suportar:

- catálogo de conteúdo (certificação/domínio/tópico/questão/alternativa)
- progresso por usuário
- histórico de tentativas e alternativas marcadas

---

## 2) Tabs criadas

Foi criada 1 tab para cada objeto customizado:

- `Certificacao__c`
- `DominioCertificacao__c`
- `Topico__c`
- `Questao__c`
- `AlternativaQuestao__c`
- `ProgressoQuestaoUsuario__c`
- `SessaoEstudo__c`
- `TentativaQuestao__c`
- `TentativaAlternativa__c`

---

## 3) Custom App criado

App criado:

- **Label:** `Doni APP`
- **API Name:** `Doni_APP`

Tabs incluídas no app:

- `Account`
- `Contact`
- todas as 9 tabs custom acima

Status de deploy do app: **Succeeded**.

---

## 4) Permission Set de acesso

Permission Set criado/ajustado:

- **Label:** `Doni APP Access`
- **API Name:** `Doni_APP_Access`

Inclui:

- visibilidade do app `Doni_APP`
- tabs como `Visible`
- permissões de objeto com `allowRead=true` e `viewAllRecords=true` para:
  - `Account`
  - `Contact`
  - `Certificacao__c`
  - `DominioCertificacao__c`
  - `Topico__c`
  - `Questao__c`
  - `AlternativaQuestao__c`
  - `ProgressoQuestaoUsuario__c`
  - `SessaoEstudo__c`
  - `TentativaQuestao__c`
  - `TentativaAlternativa__c`

---

## 5) Atribuição de acesso

Atribuição realizada para usuários ativos internos (`UserType = Standard`) com sucesso.

Observação:

- ao tentar atribuir para **todos os tipos de usuário**, houve falhas esperadas por licença (`The user license doesn't allow Assigned Apps`), então foi aplicada atribuição segura por tipo elegível.

---

## 6) Dados de teste criados

Seed executado e validado com registros conectados entre si para todos os objetos:

- `Certificacao__c`
- `DominioCertificacao__c`
- `Topico__c`
- `Questao__c`
- `AlternativaQuestao__c`
- `ProgressoQuestaoUsuario__c`
- `SessaoEstudo__c`
- `TentativaQuestao__c`
- `TentativaAlternativa__c`

Validação final por IDs: **PASS**.

---

## 7) Arquivos principais gerados/alterados

- `force-app/main/default/objects/*`
- `force-app/main/default/tabs/*`
- `force-app/main/default/applications/Doni_APP.app-meta.xml`
- `force-app/main/default/permissionsets/Doni_APP_Access.permissionset-meta.xml`
- `scripts/apex/seed-estudos.apex`

---

## 8) Observações operacionais

Se algo não aparecer no App Launcher imediatamente:

- fazer refresh forte na UI (`Ctrl+F5`)
- buscar por `Doni APP`

Em caso de usuário específico sem visão de registros, validar:

- assignment do `Doni_APP_Access`
- tipo de licença do usuário
- perfil/permissões adicionais da org
