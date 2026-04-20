// =====================================================================
// SEED — Salesforce Data 360 Consultant Exam
// Cria: 1 Certificação, 6 Domínios, 19 Tópicos, 19 Questões (c/ 4 alternativas cada)
// =====================================================================

// ---- CERTIFICAÇÃO ---------------------------------------------------
Certificacao__c cert = new Certificacao__c(
    Name        = 'Salesforce Data 360 Consultant',
    Codigo__c   = 'DATA-360',
    Descricao__c = 'Certifica conhecimento em Data Cloud (Data 360): ingestão, harmonização, segmentação, ativação e IA sobre dados unificados.',
    Nivel__c    = 'Professional'
);
insert cert;

// ---- DOMÍNIOS -------------------------------------------------------
DominioCertificacao__c d1 = new DominioCertificacao__c(
    Name = 'Solution Positioning', Certificacao__c = cert.Id,
    Codigo__c = 'D1', PesoProva__c = 14, OrdemExibicao__c = 1,
    Descricao__c = 'Terminologia, valor de negócio, papel do Data 360 em IA, casos de uso iniciais e ética de dados.'
);
DominioCertificacao__c d2 = new DominioCertificacao__c(
    Name = 'Data 360 Setup and Administration', Certificacao__c = cert.Id,
    Codigo__c = 'D2', PesoProva__c = 13, OrdemExibicao__c = 2,
    Descricao__c = 'Permissões, configurações organizacionais, governança, ciclo de desenvolvimento e troubleshooting.'
);
DominioCertificacao__c d3 = new DominioCertificacao__c(
    Name = 'Data Source Connection and Ingestion', Certificacao__c = cert.Id,
    Codigo__c = 'D3', PesoProva__c = 18, OrdemExibicao__c = 3,
    Descricao__c = 'Transformação, ingestão de dados de múltiplas fontes e colaboração Zero-Copy.'
);
DominioCertificacao__c d4 = new DominioCertificacao__c(
    Name = 'Harmonization and Unification', Certificacao__c = cert.Id,
    Codigo__c = 'D4', PesoProva__c = 17, OrdemExibicao__c = 4,
    Descricao__c = 'Propósito e processo de unificação de identidade e modelagem de dados no Data 360.'
);
DominioCertificacao__c d5 = new DominioCertificacao__c(
    Name = 'Data Enhancements, Sharing, and Analysis', Certificacao__c = cert.Id,
    Codigo__c = 'D5', PesoProva__c = 18, OrdemExibicao__c = 5,
    Descricao__c = 'Enriquecimento de dados, referenciamento externo, relatórios, dashboards e IA preditiva/generativa.'
);
DominioCertificacao__c d6 = new DominioCertificacao__c(
    Name = 'Data Activations and Utilization', Certificacao__c = cert.Id,
    Codigo__c = 'D6', PesoProva__c = 20, OrdemExibicao__c = 6,
    Descricao__c = 'Segmentação, gerenciamento de segmentos, ativações, ação sobre dados e uso em Flows.'
);
insert new List<DominioCertificacao__c>{ d1, d2, d3, d4, d5, d6 };

// ---- TÓPICOS --------------------------------------------------------
// D1
Topico__c t1_1 = new Topico__c(Name = 'Terminologia e valor de negócio do Data 360',          DominioCertificacao__c = d1.Id, OrdemExibicao__c = 1);
Topico__c t1_2 = new Topico__c(Name = 'Data 360 como base para IA generativa e preditiva',     DominioCertificacao__c = d1.Id, OrdemExibicao__c = 2);
Topico__c t1_3 = new Topico__c(Name = 'Casos de uso iniciais para Data 360',                   DominioCertificacao__c = d1.Id, OrdemExibicao__c = 3);
Topico__c t1_4 = new Topico__c(Name = 'Ética e governança de dados',                           DominioCertificacao__c = d1.Id, OrdemExibicao__c = 4);
// D2
Topico__c t2_1 = new Topico__c(Name = 'Permissões e configurações organizacionais',            DominioCertificacao__c = d2.Id, OrdemExibicao__c = 1);
Topico__c t2_2 = new Topico__c(Name = 'Governança de dados na configuração da plataforma',     DominioCertificacao__c = d2.Id, OrdemExibicao__c = 2);
Topico__c t2_3 = new Topico__c(Name = 'Ciclo de desenvolvimento e ferramentas disponíveis',    DominioCertificacao__c = d2.Id, OrdemExibicao__c = 3);
Topico__c t2_4 = new Topico__c(Name = 'Diagnóstico e solução de problemas comuns',             DominioCertificacao__c = d2.Id, OrdemExibicao__c = 4);
// D3
Topico__c t3_1 = new Topico__c(Name = 'Transformação de dados no Data 360',                    DominioCertificacao__c = d3.Id, OrdemExibicao__c = 1);
Topico__c t3_2 = new Topico__c(Name = 'Ingestão de dados de fontes variadas',                  DominioCertificacao__c = d3.Id, OrdemExibicao__c = 2);
Topico__c t3_3 = new Topico__c(Name = 'Colaboração de dados e Zero-Copy',                      DominioCertificacao__c = d3.Id, OrdemExibicao__c = 3);
// D4
Topico__c t4_1 = new Topico__c(Name = 'Propósito, processo e casos de uso da unificação',      DominioCertificacao__c = d4.Id, OrdemExibicao__c = 1);
Topico__c t4_2 = new Topico__c(Name = 'Modelagem de dados no Data 360',                        DominioCertificacao__c = d4.Id, OrdemExibicao__c = 2);
// D5
Topico__c t5_1 = new Topico__c(Name = 'Enriquecimento de dados e construção de insights',      DominioCertificacao__c = d5.Id, OrdemExibicao__c = 1);
Topico__c t5_2 = new Topico__c(Name = 'Referenciamento de dados do Data 360 em outros sistemas', DominioCertificacao__c = d5.Id, OrdemExibicao__c = 2);
Topico__c t5_3 = new Topico__c(Name = 'Relatórios e dashboards com Data 360',                  DominioCertificacao__c = d5.Id, OrdemExibicao__c = 3);
Topico__c t5_4 = new Topico__c(Name = 'IA preditiva e generativa no Data 360',                 DominioCertificacao__c = d5.Id, OrdemExibicao__c = 4);
// D6
Topico__c t6_1 = new Topico__c(Name = 'Conceitos de segmentação e casos de uso',               DominioCertificacao__c = d6.Id, OrdemExibicao__c = 1);
Topico__c t6_2 = new Topico__c(Name = 'Gerenciamento de segmentos no Data 360',                DominioCertificacao__c = d6.Id, OrdemExibicao__c = 2);
Topico__c t6_3 = new Topico__c(Name = 'Publicação de Activations no Data 360',                 DominioCertificacao__c = d6.Id, OrdemExibicao__c = 3);
Topico__c t6_4 = new Topico__c(Name = 'Ação sobre dados',                                      DominioCertificacao__c = d6.Id, OrdemExibicao__c = 4);
Topico__c t6_5 = new Topico__c(Name = 'Uso do Data 360 em Salesforce Flows',                   DominioCertificacao__c = d6.Id, OrdemExibicao__c = 5);

List<Topico__c> topicos = new List<Topico__c>{
    t1_1, t1_2, t1_3, t1_4,
    t2_1, t2_2, t2_3, t2_4,
    t3_1, t3_2, t3_3,
    t4_1, t4_2,
    t5_1, t5_2, t5_3, t5_4,
    t6_1, t6_2, t6_3, t6_4, t6_5
};
insert topicos;

// ---- QUESTÕES + ALTERNATIVAS ----------------------------------------
List<Questao__c> questoes = new List<Questao__c>();

// Q1 — T1.1 Terminologia
questoes.add(new Questao__c(
    Name = 'DATA360-Q001', Certificacao__c = cert.Id, DominioPrincipal__c = d1.Id, TopicoPrincipal__c = t1_1.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Facil', Ativa__c = true,
    Enunciado__c = 'Qual termo descreve o repositório centralizado de dados unificados no Salesforce Data 360 onde perfis de cliente são construídos a partir de múltiplas fontes?',
    ExplicacaoResposta__c = 'No Data 360 (Data Cloud), o "Data Lake Object" (DLO) armazena dados brutos ingeridos, enquanto o "Data Model Object" (DMO) representa entidades harmonizadas. O perfil unificado é construído sobre o DMO de tipo "Individual" ou "Contact Point". Referência: Salesforce Data Cloud Terminology — help.salesforce.com/s/articleView?id=sf.c360_a_data_cloud_glossary.htm'
));
// Q2 — T1.2 IA
questoes.add(new Questao__c(
    Name = 'DATA360-Q002', Certificacao__c = cert.Id, DominioPrincipal__c = d1.Id, TopicoPrincipal__c = t1_2.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Como o Data 360 suporta modelos de IA generativa como o Einstein Copilot?',
    ExplicacaoResposta__c = 'O Data 360 fornece dados unificados e enriquecidos como contexto para os Large Language Models (LLMs) usados pelo Einstein Copilot. Por meio do Retrieval-Augmented Generation (RAG), os perfis unificados do Data Cloud são recuperados e enviados como contexto para que o modelo gere respostas personalizadas e precisas. Referência: Salesforce Einstein Copilot + Data Cloud — developer.salesforce.com/blogs/2024/05/data-cloud-and-einstein-copilot'
));
// Q3 — T1.3 Casos de uso
questoes.add(new Questao__c(
    Name = 'DATA360-Q003', Certificacao__c = cert.Id, DominioPrincipal__c = d1.Id, TopicoPrincipal__c = t1_3.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Facil', Ativa__c = true,
    Enunciado__c = 'Uma empresa de varejo deseja personalizar comunicações de marketing com base no histórico de compras online e offline. Qual é o caso de uso mais adequado para o Data 360?',
    ExplicacaoResposta__c = 'Unificação de perfil de cliente (Customer 360) é o caso de uso primário do Data 360. Ao consolidar dados transacionais de lojas físicas e e-commerce, a empresa cria um perfil único por cliente, habilitando segmentação precisa e ativação via Marketing Cloud. Referência: Salesforce Data Cloud Use Cases — trailhead.salesforce.com/content/learn/modules/salesforce-data-cloud-quick-look'
));
// Q4 — T1.4 Ética
questoes.add(new Questao__c(
    Name = 'DATA360-Q004', Certificacao__c = cert.Id, DominioPrincipal__c = d1.Id, TopicoPrincipal__c = t1_4.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Qual princípio de ética de dados exige que as organizações coletem apenas os dados estritamente necessários para a finalidade declarada?',
    ExplicacaoResposta__c = 'O princípio de "minimização de dados" (data minimization), parte do GDPR e das diretrizes de ética de dados da Salesforce, determina que organizações não devem coletar mais dados do que o necessário para um propósito legítimo e declarado. Isso reduz riscos de exposição e violações. Referência: Salesforce Data Ethics Guidelines — salesforce.com/company/intentional-innovation/data-ethics'
));
// Q5 — T2.1 Permissões
questoes.add(new Questao__c(
    Name = 'DATA360-Q005', Certificacao__c = cert.Id, DominioPrincipal__c = d2.Id, TopicoPrincipal__c = t2_1.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Qual permission set license (PSL) deve ser atribuída a um usuário que precisa criar e gerenciar Data Streams no Data 360?',
    ExplicacaoResposta__c = 'A permissão "Data Cloud Admin" concede acesso completo à configuração do Data Cloud, incluindo criação de Data Streams, configuração de Data Model Objects e gerenciamento de identidades. A PSL correta é "Salesforce Data Cloud" e o usuário deve ter o perfil ou permission set com "Data Cloud Admin" habilitado. Referência: Salesforce Help — Set Up Data Cloud Permissions: help.salesforce.com/s/articleView?id=sf.c360_a_permissions.htm'
));
// Q6 — T2.2 Governança
questoes.add(new Questao__c(
    Name = 'DATA360-Q006', Certificacao__c = cert.Id, DominioPrincipal__c = d2.Id, TopicoPrincipal__c = t2_2.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Dificil', Ativa__c = true,
    Enunciado__c = 'Um administrador precisa garantir que dados de saúde ingeridos no Data 360 sejam acessíveis apenas a usuários autorizados. Qual recurso de plataforma atende a esse requisito?',
    ExplicacaoResposta__c = 'O Data Space (Espaço de Dados) no Data 360 permite isolar dados por departamento, região ou sensibilidade, controlando quais usuários e processos têm acesso a cada conjunto. Para dados sensíveis como saúde (HIPAA), é recomendado criar um Data Space dedicado com permissões restritas. Referência: Salesforce Help — Data Spaces: help.salesforce.com/s/articleView?id=sf.c360_a_data_spaces.htm'
));
// Q7 — T2.3 DevLifecycle
questoes.add(new Questao__c(
    Name = 'DATA360-Q007', Certificacao__c = cert.Id, DominioPrincipal__c = d2.Id, TopicoPrincipal__c = t2_3.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Qual ferramenta permite migrar configurações do Data 360 entre ambientes (ex.: sandbox para produção)?',
    ExplicacaoResposta__c = 'O Salesforce CLI com o plugin "data-cloud" e os Metadata API types específicos do Data Cloud permitem mover configurações entre orgs. Adicionalmente, o Change Sets pode ser usado para mover alguns artefatos, mas o Salesforce CLI é a abordagem recomendada para CI/CD no contexto do Data Cloud. Referência: Salesforce Data Cloud Developer Guide — developer.salesforce.com/docs/atlas.en-us.c360a_api.meta/c360a_api'
));
// Q8 — T2.4 Troubleshooting
questoes.add(new Questao__c(
    Name = 'DATA360-Q008', Certificacao__c = cert.Id, DominioPrincipal__c = d2.Id, TopicoPrincipal__c = t2_4.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Um Data Stream configurado com uma conexão S3 para do Data 360 não está ingerindo novos arquivos. Qual é o primeiro lugar para verificar a causa do problema?',
    ExplicacaoResposta__c = 'O Data Stream Monitor no Data 360 exibe o status de cada execução de ingestão, incluindo erros detalhados como credenciais inválidas, arquivos malformados ou políticas de IAM no S3. É o ponto de partida padrão para troubleshooting de ingestão. Referência: Salesforce Help — Monitor Data Streams: help.salesforce.com/s/articleView?id=sf.c360_a_monitor_data_streams.htm'
));
// Q9 — T3.1 Transformação
questoes.add(new Questao__c(
    Name = 'DATA360-Q009', Certificacao__c = cert.Id, DominioPrincipal__c = d3.Id, TopicoPrincipal__c = t3_1.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Dificil', Ativa__c = true,
    Enunciado__c = 'Qual recurso do Data 360 permite criar campos calculados e transformar dados durante o mapeamento de um Data Lake Object para um Data Model Object?',
    ExplicacaoResposta__c = 'As "Data Transform Formulas" (Fórmulas de Transformação) no mapeamento DLO → DMO permitem criar campos calculados, concatenar strings, converter tipos e aplicar funções condicionais. Isso ocorre no momento do mapeamento, sem necessidade de transformar os dados na fonte. Referência: Salesforce Help — Data Transforms: help.salesforce.com/s/articleView?id=sf.c360_a_data_transforms.htm'
));
// Q10 — T3.2 Ingestão
questoes.add(new Questao__c(
    Name = 'DATA360-Q010', Certificacao__c = cert.Id, DominioPrincipal__c = d3.Id, TopicoPrincipal__c = t3_2.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Qual tipo de conector deve ser usado para ingerir dados em tempo real de eventos de comportamento web no Data 360?',
    ExplicacaoResposta__c = 'O "Web SDK" (também chamado de Interaction SDK) e o conector de "Streaming Ingestion API" permitem ingerir eventos em tempo real no Data 360, como cliques, page views e eventos de carrinho. São adequados para dados comportamentais com alta frequência. Referência: Salesforce Help — Streaming Ingestion API: help.salesforce.com/s/articleView?id=sf.c360_a_streaming_api.htm'
));
// Q11 — T3.3 Zero-Copy
questoes.add(new Questao__c(
    Name = 'DATA360-Q011', Certificacao__c = cert.Id, DominioPrincipal__c = d3.Id, TopicoPrincipal__c = t3_3.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Dificil', Ativa__c = true,
    Enunciado__c = 'O que o conceito de Zero-Copy no Data 360 significa na prática para a arquitetura de dados?',
    ExplicacaoResposta__c = 'Zero-Copy significa que o Data 360 acessa dados diretamente em seu armazenamento original (ex.: Snowflake, AWS S3 via Data Share) sem mover ou duplicar os dados fisicamente para dentro do Salesforce. Isso reduz custos de armazenamento, latência de sincronização e riscos de desatualização. Referência: Salesforce Data Cloud Zero Copy — help.salesforce.com/s/articleView?id=sf.c360_a_zero_copy.htm'
));
// Q12 — T4.1 Unificação
questoes.add(new Questao__c(
    Name = 'DATA360-Q012', Certificacao__c = cert.Id, DominioPrincipal__c = d4.Id, TopicoPrincipal__c = t4_1.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Qual é o principal objetivo do processo de Identity Resolution (Unificação) no Data 360?',
    ExplicacaoResposta__c = 'O Identity Resolution consolida registros de um mesmo cliente provenientes de múltiplas fontes em um único "Unified Individual", usando regras de matching (match rules) baseadas em email, telefone, nome, endereço etc. O resultado é um perfil 360° único por cliente real. Referência: Salesforce Help — Identity Resolution: help.salesforce.com/s/articleView?id=sf.c360_a_identity_resolution.htm'
));
// Q13 — T4.2 Modelagem
questoes.add(new Questao__c(
    Name = 'DATA360-Q013', Certificacao__c = cert.Id, DominioPrincipal__c = d4.Id, TopicoPrincipal__c = t4_2.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Dificil', Ativa__c = true,
    Enunciado__c = 'Qual é a diferença fundamental entre um Data Lake Object (DLO) e um Data Model Object (DMO) no Data 360?',
    ExplicacaoResposta__c = 'DLO (Data Lake Object) representa os dados brutos exatamente como chegaram da fonte, sem padronização. DMO (Data Model Object) representa entidades harmonizadas seguindo o modelo canônico do Data Cloud (ex.: Individual, Contact Point Email, Sales Order). O mapeamento DLO → DMO transforma e padroniza os dados. Referência: Salesforce Help — Data Model: help.salesforce.com/s/articleView?id=sf.c360_a_data_model.htm'
));
// Q14 — T5.1 Enriquecimento
questoes.add(new Questao__c(
    Name = 'DATA360-Q014', Certificacao__c = cert.Id, DominioPrincipal__c = d5.Id, TopicoPrincipal__c = t5_1.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Qual recurso do Data 360 permite criar métricas calculadas sobre dados unificados, como "total gasto nos últimos 90 dias"?',
    ExplicacaoResposta__c = 'Os "Calculated Insights" permitem criar atributos e métricas derivadas sobre os dados unificados no Data 360, usando SQL. Um Calculated Insight como "total_spend_90d" pode ser criado com uma query agregada e depois usado em segmentação e ativação. Referência: Salesforce Help — Calculated Insights: help.salesforce.com/s/articleView?id=sf.c360_a_calculated_insights.htm'
));
// Q15 — T5.2 Referenciamento externo
questoes.add(new Questao__c(
    Name = 'DATA360-Q015', Certificacao__c = cert.Id, DominioPrincipal__c = d5.Id, TopicoPrincipal__c = t5_2.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Como dados unificados do Data 360 podem ser usados em um registro de Contact no Sales Cloud sem duplicar dados?',
    ExplicacaoResposta__c = 'O Data Cloud for CRM disponibiliza dados unificados do Data Cloud diretamente em registros do Sales/Service Cloud por meio de "Related Lists" e "Data Cloud Insights" na página de layout, sem mover dados. O Salesforce usa o vínculo Contact → Unified Individual para exibir dados em contexto. Referência: Salesforce Help — Use Data Cloud Data in CRM: help.salesforce.com/s/articleView?id=sf.c360_a_use_in_crm.htm'
));
// Q16 — T5.3 Relatórios
questoes.add(new Questao__c(
    Name = 'DATA360-Q016', Certificacao__c = cert.Id, DominioPrincipal__c = d5.Id, TopicoPrincipal__c = t5_3.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Facil', Ativa__c = true,
    Enunciado__c = 'Qual ferramenta de análise nativa está disponível no Data 360 para criar visualizações e dashboards diretamente sobre os dados do Data Cloud?',
    ExplicacaoResposta__c = 'O "Data Cloud Analytics" (anteriormente parte do CRM Analytics / Tableau CRM) fornece dashboards e lentes diretamente sobre conjuntos de dados do Data Cloud. Também é possível usar o Salesforce Reports & Dashboards para objetos expostos via "Data Cloud Salesforce Connector". Referência: Salesforce Help — Analyze Data Cloud Data: help.salesforce.com/s/articleView?id=sf.c360_a_analyze.htm'
));
// Q17 — T5.4 IA
questoes.add(new Questao__c(
    Name = 'DATA360-Q017', Certificacao__c = cert.Id, DominioPrincipal__c = d5.Id, TopicoPrincipal__c = t5_4.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Dificil', Ativa__c = true,
    Enunciado__c = 'O que é necessário configurar no Data 360 para usar um modelo preditivo Einstein para pontuar clientes em risco de churn?',
    ExplicacaoResposta__c = 'No Data 360, modelos preditivos Einstein são configurados em "Einstein Studio" (dentro do Data Cloud). É necessário: (1) definir o target (ex.: campo de churn), (2) selecionar features a partir de DMOs, (3) treinar e publicar o modelo, (4) mapear as pontuações de volta a um DMO para uso em segmentos e ativações. Referência: Salesforce Help — Einstein Studio: help.salesforce.com/s/articleView?id=sf.c360_a_einstein_studio.htm'
));
// Q18 — T6.1 Segmentação
questoes.add(new Questao__c(
    Name = 'DATA360-Q018', Certificacao__c = cert.Id, DominioPrincipal__c = d6.Id, TopicoPrincipal__c = t6_1.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Facil', Ativa__c = true,
    Enunciado__c = 'Qual é a unidade base sobre a qual segmentos são construídos no Data 360?',
    ExplicacaoResposta__c = 'Segmentos no Data 360 são sempre construídos sobre o "Unified Individual" (perfil unificado), que é o resultado do processo de Identity Resolution. Isso garante que cada pessoa seja contada uma única vez, independente de quantas fontes a originaram. Referência: Salesforce Help — Segments: help.salesforce.com/s/articleView?id=sf.c360_a_segments.htm'
));
// Q19 — T6.2 Gerenciamento de segmentos
questoes.add(new Questao__c(
    Name = 'DATA360-Q019', Certificacao__c = cert.Id, DominioPrincipal__c = d6.Id, TopicoPrincipal__c = t6_2.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Um segmento no Data 360 foi publicado para o Marketing Cloud, mas os dados estão desatualizados. Qual configuração deve ser revisada?',
    ExplicacaoResposta__c = 'A frequência de publicação (publish schedule) do segmento define de quanto em quanto tempo o segmento é recalculado e enviado ao destino de ativação. Se configurado como "manual" ou com intervalo longo, os dados ficam desatualizados. Deve-se ajustar o schedule para contínuo ou por hora conforme a necessidade. Referência: Salesforce Help — Publish Segments: help.salesforce.com/s/articleView?id=sf.c360_a_publish_segments.htm'
));
// Q20 — T6.3 Activations
questoes.add(new Questao__c(
    Name = 'DATA360-Q020', Certificacao__c = cert.Id, DominioPrincipal__c = d6.Id, TopicoPrincipal__c = t6_3.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Media', Ativa__c = true,
    Enunciado__c = 'Ao configurar uma Activation para Marketing Cloud no Data 360, qual é o componente que define quais atributos do perfil serão enviados junto com o segmento?',
    ExplicacaoResposta__c = 'O "Activation Target" define o destino (ex.: Marketing Cloud Email Studio) e os "Contact Points" definem como o perfil será identificado no destino (ex.: email). Os "Attributes" selecionados na Activation determinam quais campos do perfil unificado ou Calculated Insights serão incluídos no payload enviado. Referência: Salesforce Help — Activations: help.salesforce.com/s/articleView?id=sf.c360_a_activations.htm'
));
// Q21 — T6.4 Ação sobre dados
questoes.add(new Questao__c(
    Name = 'DATA360-Q021', Certificacao__c = cert.Id, DominioPrincipal__c = d6.Id, TopicoPrincipal__c = t6_4.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Dificil', Ativa__c = true,
    Enunciado__c = 'Qual recurso do Data 360 permite acionar automaticamente uma jornada no Marketing Cloud Journey Builder quando um cliente entra em um segmento?',
    ExplicacaoResposta__c = 'O "Data Action" no Data 360 monitora mudanças em DMOs ou segmentos e pode disparar eventos como entradas em Journey Builder, criar Cases no Service Cloud ou chamar uma plataforma externa via webhook. É a ponte entre dados no Data Cloud e execução em tempo real em outros sistemas. Referência: Salesforce Help — Data Actions: help.salesforce.com/s/articleView?id=sf.c360_a_data_actions.htm'
));
// Q22 — T6.5 Flows
questoes.add(new Questao__c(
    Name = 'DATA360-Q022', Certificacao__c = cert.Id, DominioPrincipal__c = d6.Id, TopicoPrincipal__c = t6_5.Id,
    TipoQuestao__c = 'MultiplaEscolha', NivelDificuldade__c = 'Dificil', Ativa__c = true,
    Enunciado__c = 'Como um Salesforce Flow pode consumir dados unificados do Data 360 em tempo de execução para personalizar uma interação de serviço?',
    ExplicacaoResposta__c = 'O Flow pode usar a ação "Get Data Cloud Records" (disponível como elemento de ação no Flow Builder) para consultar DMOs do Data 360 em tempo real durante a execução. Isso permite que um Flow de Service Cloud, por exemplo, exiba o histórico de compras unificado de um cliente durante um atendimento. Referência: Salesforce Help — Use Data Cloud in Flow: help.salesforce.com/s/articleView?id=sf.c360_a_flow.htm'
));

insert questoes;
System.debug('Questões inseridas: ' + questoes.size());

// ---- ALTERNATIVAS ---------------------------------------------------
List<AlternativaQuestao__c> alts = new List<AlternativaQuestao__c>();

// Q1 — Terminologia
alts.add(new AlternativaQuestao__c(Questao__c=questoes[0].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Data Model Object (DMO)', ExplicacaoAlternativa__c='O DMO representa entidades harmonizadas no modelo canônico do Data Cloud, como Individual e Contact Point, e é onde os perfis unificados residem.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[0].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Data Lake Object (DLO)', ExplicacaoAlternativa__c='O DLO armazena dados brutos como chegaram da fonte, sem harmonização. É a camada anterior ao DMO no pipeline.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[0].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Data Stream', ExplicacaoAlternativa__c='Data Stream é o mecanismo de ingestão/conexão, não o repositório de perfis unificados.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[0].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Unified Profile Object', ExplicacaoAlternativa__c='Este não é um termo técnico oficial do Data Cloud. O perfil unificado é representado pelo DMO "Unified Individual".'));

// Q2 — IA generativa
alts.add(new AlternativaQuestao__c(Questao__c=questoes[1].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Fornecendo dados unificados como contexto para LLMs via Retrieval-Augmented Generation (RAG)', ExplicacaoAlternativa__c='O Data 360 envia o perfil unificado como contexto adicional para o LLM, tornando respostas mais precisas e personalizadas sem precisar retreinar o modelo.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[1].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Treinando modelos de linguagem diretamente com dados de clientes armazenados no Data Lake', ExplicacaoAlternativa__c='O Data 360 não treina LLMs. Ele fornece dados como contexto em tempo de inferência, não no treinamento.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[1].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Substituindo o Einstein AutoML com modelos de IA de terceiros', ExplicacaoAlternativa__c='O Data 360 complementa o Einstein AutoML e suporta modelos externos, mas não os substitui. Esse não é seu papel no contexto de IA generativa.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[1].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Criando prompts automáticos com base em regras de negócio definidas no Flow Builder', ExplicacaoAlternativa__c='Prompts no Prompt Builder podem usar dados do Data Cloud, mas a integração principal de Data 360 com IA generativa é via contexto RAG, não regras de Flow.'));

// Q3 — Casos de uso
alts.add(new AlternativaQuestao__c(Questao__c=questoes[2].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Unificação de perfil de cliente para segmentação e ativação personalizada no Marketing Cloud', ExplicacaoAlternativa__c='Este é o caso de uso central: consolidar dados de múltiplas fontes em um perfil único e usá-lo para campanhas personalizadas.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[2].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Criação de um data warehouse transacional para relatórios financeiros', ExplicacaoAlternativa__c='O Data 360 não é um data warehouse transacional. Seu foco é perfis de cliente e ativação, não relatórios financeiros de back-office.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[2].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Substituição completa do CRM existente por uma plataforma de dados centralizada', ExplicacaoAlternativa__c='O Data 360 complementa o CRM, não o substitui. Ele enriquece registros do Sales/Service Cloud com dados unificados.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[2].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Armazenamento de logs de auditoria de sistema para conformidade regulatória', ExplicacaoAlternativa__c='Logs de auditoria têm ferramentas dedicadas (Shield, Event Monitoring). O Data 360 é para dados de cliente, não logs de sistema.'));

// Q4 — Ética
alts.add(new AlternativaQuestao__c(Questao__c=questoes[3].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Minimização de dados', ExplicacaoAlternativa__c='Data minimization: coletar apenas o que é necessário para o propósito declarado. Princípio central do GDPR e das diretrizes éticas da Salesforce.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[3].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Portabilidade de dados', ExplicacaoAlternativa__c='Portabilidade refere-se ao direito do usuário de receber seus dados em formato estruturado. É um princípio diferente, não relacionado ao escopo da coleta.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[3].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Transparência algorítmica', ExplicacaoAlternativa__c='Transparência algorítmica trata da explicabilidade de modelos de IA, não do escopo de coleta de dados.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[3].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Direito ao esquecimento', ExplicacaoAlternativa__c='O direito ao esquecimento (right to erasure) permite que usuários solicitem a exclusão de seus dados, mas não trata sobre o que deve ser coletado inicialmente.'));

// Q5 — Permissões
alts.add(new AlternativaQuestao__c(Questao__c=questoes[4].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Data Cloud Admin permission set com PSL "Salesforce Data Cloud"', ExplicacaoAlternativa__c='A permission set "Data Cloud Admin" combinada com a PSL "Salesforce Data Cloud" concede acesso completo para criar e gerenciar Data Streams e configurações.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[4].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='System Administrator profile padrão do Salesforce', ExplicacaoAlternativa__c='O perfil Sys Admin dá acesso à org Salesforce, mas não inclui automaticamente o acesso ao Data Cloud, que requer a PSL específica.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[4].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Marketing Cloud Administrator role', ExplicacaoAlternativa__c='O Marketing Cloud Admin é uma função dentro do Marketing Cloud, não no Data Cloud. São sistemas com controle de acesso separados.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[4].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='CRM Analytics Admin permission set', ExplicacaoAlternativa__c='CRM Analytics Admin concede acesso ao produto de analytics, não ao gerenciamento de Data Streams do Data Cloud.'));

// Q6 — Governança
alts.add(new AlternativaQuestao__c(Questao__c=questoes[5].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Data Spaces com permissões restritas por perfil de usuário', ExplicacaoAlternativa__c='Data Spaces isolam dados dentro do Data Cloud e permitem controle granular de acesso, sendo a solução recomendada para segregar dados sensíveis.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[5].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Field-Level Security nos campos do objeto Salesforce Health Cloud', ExplicacaoAlternativa__c='Field-Level Security do CRM não se aplica a DMOs do Data Cloud. São camadas de segurança diferentes.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[5].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Criptografia de campos com Shield Platform Encryption', ExplicacaoAlternativa__c='Shield Encryption protege dados em repouso no CRM, mas não controla o acesso lógico a dados dentro do Data Cloud.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[5].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Configurar sharing rules para o objeto Data Lake Object', ExplicacaoAlternativa__c='Sharing rules são um conceito do CRM Salesforce e não se aplicam diretamente a DLOs no Data Cloud.'));

// Q7 — DevLifecycle
alts.add(new AlternativaQuestao__c(Questao__c=questoes[6].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Salesforce CLI com plugin Data Cloud e Metadata API types específicos', ExplicacaoAlternativa__c='O Salesforce CLI é a abordagem recomendada para CI/CD no Data Cloud, permitindo exportar e importar configurações como Data Streams, mapeamentos e Calculated Insights entre ambientes.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[6].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Export/Import manual via interface do Workbench', ExplicacaoAlternativa__c='Workbench é uma ferramenta auxiliar para exploração de API, não é adequado para gerenciar o ciclo de desenvolvimento de configurações do Data Cloud.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[6].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Copiar manualmente as configurações via interface do Setup', ExplicacaoAlternativa__c='Copiar manualmente não é escalável, não versionável e propenso a erros. Não é uma prática de ciclo de desenvolvimento adequada.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[6].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Usar somente Sandboxes para testar, sem mecanismo de migração', ExplicacaoAlternativa__c='Sandboxes são importantes para testes, mas sem uma ferramenta de migração as configurações precisariam ser recriadas manualmente em produção.'));

// Q8 — Troubleshooting
alts.add(new AlternativaQuestao__c(Questao__c=questoes[7].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Data Stream Monitor no Data Cloud Setup', ExplicacaoAlternativa__c='O Data Stream Monitor exibe o histórico de execuções, status (sucesso/falha) e mensagens de erro detalhadas por ingestão, sendo o ponto de partida padrão para troubleshooting.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[7].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Debug Logs do Apex no Developer Console', ExplicacaoAlternativa__c='Debug Logs do Apex são para código Apex do CRM, não para monitorar ingestões de Data Streams do Data Cloud.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[7].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Logs de acesso da AWS CloudWatch diretamente no bucket S3', ExplicacaoAlternativa__c='CloudWatch pode indicar se o Salesforce acessou o S3, mas não fornece contexto do lado do Data Cloud sobre o que deu errado no processamento.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[7].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Event Monitoring do Salesforce Shield', ExplicacaoAlternativa__c='Event Monitoring cobre eventos de usuário e API do CRM Salesforce, não eventos de ingestão do Data Cloud.'));

// Q9 — Transformação
alts.add(new AlternativaQuestao__c(Questao__c=questoes[8].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Data Transform Formulas no mapeamento DLO → DMO', ExplicacaoAlternativa__c='As fórmulas de transformação permitem calcular campos, converter tipos, concatenar strings e aplicar lógica condicional durante o mapeamento, sem alterar os dados da fonte.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[8].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Apex Triggers no objeto Data Model Object', ExplicacaoAlternativa__c='DMOs não são objetos Salesforce padrão com suporte a Apex Triggers. Transformações no Data Cloud são feitas no pipeline de mapeamento.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[8].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Process Builder executado após a ingestão do Data Stream', ExplicacaoAlternativa__c='Process Builder é uma ferramenta do CRM Salesforce para objetos padrão/customizados e não se integra com o pipeline de transformação do Data Cloud.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[8].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Pré-processar os dados externamente antes de enviar ao conector do Data Cloud', ExplicacaoAlternativa__c='Pré-processar na fonte é possível, mas não é o recurso nativo do Data 360 para transformação. A plataforma oferece transformações internas via fórmulas.'));

// Q10 — Ingestão
alts.add(new AlternativaQuestao__c(Questao__c=questoes[9].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Streaming Ingestion API ou Web SDK (Interaction SDK)', ExplicacaoAlternativa__c='A Streaming Ingestion API e o Web SDK são projetados para eventos em tempo real de alta frequência, como comportamento web. Permitem latência de ingestão de segundos.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[9].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Conector de arquivo S3 com schedule de 24 horas', ExplicacaoAlternativa__c='Um conector S3 com schedule diário é inadequado para eventos em tempo real. É usado para cargas em lote de arquivos históricos.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[9].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Data Loader do Salesforce CRM', ExplicacaoAlternativa__c='O Data Loader é para importação de dados em objetos do CRM Salesforce, não para streaming de eventos no Data Cloud.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[9].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Conector MuleSoft com schedule de 1 hora', ExplicacaoAlternativa__c='MuleSoft pode ser usado como intermediário, mas schedule de 1 hora ainda é um intervalo de lote, não tempo real. Não é adequado para eventos comportamentais de alta frequência.'));

// Q11 — Zero-Copy
alts.add(new AlternativaQuestao__c(Questao__c=questoes[10].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Dados são acessados diretamente na fonte (ex.: Snowflake) sem mover ou duplicar fisicamente para o Salesforce', ExplicacaoAlternativa__c='Zero-Copy federated access mantém os dados no armazenamento original e usa um mecanismo de consulta federada, eliminando movimentação de dados e custos de duplicação.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[10].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Dados são copiados para o Data Cloud sem nenhuma transformação aplicada', ExplicacaoAlternativa__c='Esta é uma descrição de ingestão simples, não de Zero-Copy. Zero-Copy significa ausência de movimentação de dados.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[10].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Dados são comprimidos (zip) antes de serem transferidos para reduzir o tráfego de rede', ExplicacaoAlternativa__c='Compressão reduz o tamanho da transferência, mas ainda é uma cópia. Zero-Copy elimina a transferência em si.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[10].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Dados são replicados em tempo real por um processo de CDC (Change Data Capture)', ExplicacaoAlternativa__c='CDC replica dados continuamente, o que ainda é uma cópia. É diferente de Zero-Copy, onde não há replicação.'));

// Q12 — Unificação
alts.add(new AlternativaQuestao__c(Questao__c=questoes[11].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Consolidar registros de múltiplas fontes que representam o mesmo cliente em um único "Unified Individual"', ExplicacaoAlternativa__c='Identity Resolution cria o perfil 360° ao reconhecer que registros de CRM, e-commerce e app mobile podem ser a mesma pessoa, aplicando match rules e reconciliation rules.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[11].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Remover registros duplicados dos Data Lake Objects antes do mapeamento', ExplicacaoAlternativa__c='Deduplicação de DLO é uma etapa de qualidade de dados, não o propósito principal do Identity Resolution, que opera no nível do perfil unificado.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[11].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Sincronizar dados do Data Cloud de volta para o CRM Salesforce automaticamente', ExplicacaoAlternativa__c='Sincronização reversa (Data Cloud for CRM) é um recurso separado. Identity Resolution é exclusivamente sobre criação do perfil unificado.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[11].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Validar a qualidade dos dados de entrada antes de persistir nos Data Lake Objects', ExplicacaoAlternativa__c='Validação de qualidade ocorre no pipeline de ingestão. Identity Resolution acontece após a ingestão, sobre os dados já persistidos nos DMOs.'));

// Q13 — DLO vs DMO
alts.add(new AlternativaQuestao__c(Questao__c=questoes[12].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='DLO armazena dados brutos da fonte; DMO representa entidades harmonizadas no modelo canônico do Data Cloud', ExplicacaoAlternativa__c='O DLO preserva a estrutura original da fonte. O mapeamento DLO→DMO aplica transformações para encaixar os dados no esquema padrão (ex.: Individual, Contact Point), resultando no DMO.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[12].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='DLO é somente para dados em batch; DMO é somente para dados em streaming', ExplicacaoAlternativa__c='Ambos DLO e DMO suportam dados batch e streaming. A diferença é de nível de processamento, não de modalidade de ingestão.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[12].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='DLO é visível ao usuário final; DMO é interno ao processamento do Data Cloud', ExplicacaoAlternativa__c='É o inverso: o DMO é o que é usado em segmentação, Calculated Insights e ativações. O DLO é a camada de armazenamento intermediário.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[12].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='São sinônimos usados em contextos diferentes da documentação', ExplicacaoAlternativa__c='DLO e DMO são objetos tecnicamente distintos com propósitos diferentes no pipeline do Data Cloud. Não são sinônimos.'));

// Q14 — Calculated Insights
alts.add(new AlternativaQuestao__c(Questao__c=questoes[13].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Calculated Insights usando SQL sobre DMOs', ExplicacaoAlternativa__c='Calculated Insights permitem criar atributos derivados e métricas usando queries SQL sobre os DMOs. Podem ser usados em segmentação, ativação e exibição no CRM.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[13].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Formula Fields em objetos customizados do CRM Salesforce', ExplicacaoAlternativa__c='Formula Fields do CRM operam sobre registros individuais do CRM, não sobre os DMOs do Data Cloud. Não é a ferramenta correta para métricas agregadas no Data 360.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[13].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Einstein Analytics Recipes no CRM Analytics', ExplicacaoAlternativa__c='Recipes do CRM Analytics são para transformação de datasets de analytics, não para criação de atributos reutilizáveis em segmentação e ativação do Data Cloud.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[13].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Flows agendados que calculam e gravam o valor em um campo customizado do Contact', ExplicacaoAlternativa__c='Flows podem complementar, mas calcular via Flow no CRM não opera sobre os dados unificados do Data Cloud de forma nativa e escalável.'));

// Q15 — Referenciamento externo
alts.add(new AlternativaQuestao__c(Questao__c=questoes[14].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Data Cloud Related Lists e Data Cloud Insights exibidos na página do Contact via layout', ExplicacaoAlternativa__c='O recurso Data Cloud for CRM permite adicionar Related Lists e componentes de Insights no layout de páginas do CRM, exibindo dados do Data Cloud em contexto sem movê-los.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[14].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Criando um campo de fórmula no Contact que busca o dado via SOQL do Data Cloud', ExplicacaoAlternativa__c='Não existe SOQL cross-object nativo de CRM para Data Cloud. Os dados do Data Cloud não são acessíveis via SOQL padrão de fórmulas.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[14].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Agendando uma sincronização diária dos DMOs para objetos customizados do CRM', ExplicacaoAlternativa__c='Sincronização diária para objetos CRM duplica dados, aumenta custos e gera desatualização. O recurso nativo evita isso com acesso em tempo real.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[14].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Usando External Objects via Salesforce Connect para apontar para o Data Cloud', ExplicacaoAlternativa__c='External Objects via Salesforce Connect são para fontes externas de terceiros. O Data Cloud tem integração nativa com o CRM sem necessidade desse mecanismo.'));

// Q16 — Relatórios
alts.add(new AlternativaQuestao__c(Questao__c=questoes[15].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Data Cloud Analytics (integrado ao CRM Analytics / Tableau CRM)', ExplicacaoAlternativa__c='O Data Cloud Analytics fornece dashboards nativos sobre dados do Data Cloud, acessíveis diretamente dentro do Data Cloud Setup e integrados ao CRM Analytics.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[15].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Salesforce Reports clássico diretamente sobre DMOs sem nenhuma configuração adicional', ExplicacaoAlternativa__c='DMOs não são objetos CRM padrão. Para usar Reports clássico, é necessário expor os dados via Salesforce Connector, não é direto sobre DMOs.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[15].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Google Data Studio conectado ao Data Cloud via API REST pública', ExplicacaoAlternativa__c='Google Data Studio pode ser conectado via APIs, mas não é a ferramenta nativa do Data 360. Exige desenvolvimento adicional e não é a resposta esperada no contexto da certificação.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[15].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Exportar dados do Data Cloud para Excel e criar relatórios manualmente', ExplicacaoAlternativa__c='Exportar para Excel não é uma abordagem escalável, não é nativa e não está relacionada às ferramentas de análise do Data Cloud.'));

// Q17 — IA preditiva
alts.add(new AlternativaQuestao__c(Questao__c=questoes[16].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Configurar um modelo no Einstein Studio, definindo target, features e mapeando pontuações de volta a um DMO', ExplicacaoAlternativa__c='O Einstein Studio no Data Cloud é o ambiente para criação, treinamento e publicação de modelos preditivos. As pontuações geradas são armazenadas em DMOs e podem ser usadas em segmentos e ativações.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[16].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Criar um Apex Batch que chama a API do Einstein Prediction Service e grava resultados em campos customizados', ExplicacaoAlternativa__c='Einstein Prediction Service é para modelos em objetos CRM. Para dados do Data Cloud, usa-se o Einstein Studio nativo, não Apex com chamadas externas.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[16].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Ativar o Einstein Lead Scoring no Sales Cloud e apontar para os dados do Data Cloud', ExplicacaoAlternativa__c='Einstein Lead Scoring é um produto pré-construído do Sales Cloud para qualificação de leads, não configurável para churn scoring com dados customizados do Data Cloud.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[16].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Importar um modelo PMML externo via Data Loader e aplicá-lo em um Report do CRM Analytics', ExplicacaoAlternativa__c='CRM Analytics suporta PMML em alguns contextos, mas o fluxo correto para modelos preditivos sobre dados do Data Cloud é via Einstein Studio.'));

// Q18 — Segmentação
alts.add(new AlternativaQuestao__c(Questao__c=questoes[17].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Unified Individual', ExplicacaoAlternativa__c='Segmentos no Data 360 são sempre construídos sobre o Unified Individual, o perfil unificado resultante do Identity Resolution, garantindo unicidade por pessoa real.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[17].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Contact do CRM Salesforce', ExplicacaoAlternativa__c='Contacts do CRM são registros de uma única fonte. Segmentos no Data Cloud operam sobre o perfil unificado, não sobre registros isolados do CRM.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[17].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Data Lake Object de qualquer tipo', ExplicacaoAlternativa__c='DLOs são dados brutos e não são diretamente segmentáveis. A segmentação opera sobre DMOs, especificamente o Unified Individual.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[17].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Lead ou Contact Point Email', ExplicacaoAlternativa__c='Contact Point Email é um DMO de ponto de contato, não a entidade base de segmentação. O segmento parte do Unified Individual e pode filtrar por atributos de Contact Points.'));

// Q19 — Gerenciamento de segmentos
alts.add(new AlternativaQuestao__c(Questao__c=questoes[18].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='A frequência de publicação (publish schedule) do segmento está configurada como manual ou com intervalo longo', ExplicacaoAlternativa__c='O publish schedule determina com que frequência o segmento é recalculado e enviado ao destino. Se manual ou com schedule longo, os dados chegam ao Marketing Cloud desatualizados.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[18].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='O segmento foi publicado antes de o Identity Resolution ser executado', ExplicacaoAlternativa__c='Se o Identity Resolution não foi executado, o segmento pode ter membros incorretos, mas não explica diretamente dados desatualizados após publicação bem-sucedida.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[18].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='O Marketing Cloud está em manutenção e não está processando novos dados', ExplicacaoAlternativa__c='Manutenção do Marketing Cloud pode causar atraso, mas o primeiro lugar a verificar é sempre a configuração do segmento no Data Cloud.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[18].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='O segmento não tem Activation Target configurado', ExplicacaoAlternativa__c='Sem Activation Target o segmento não seria publicado de forma alguma. Se chegou ao Marketing Cloud (mesmo desatualizado), o target está configurado.'));

// Q20 — Activations
alts.add(new AlternativaQuestao__c(Questao__c=questoes[19].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Os Attributes selecionados na configuração da Activation', ExplicacaoAlternativa__c='Ao criar uma Activation, além de definir o Activation Target e os Contact Points, o consultor seleciona quais atributos do perfil ou Calculated Insights serão incluídos no payload enviado ao destino.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[19].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='O Data Stream de origem do segmento', ExplicacaoAlternativa__c='O Data Stream é a fonte de ingestão, não define quais atributos são enviados na Activation. O Activation é um componente separado com sua própria configuração de atributos.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[19].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Os campos mapeados no Data Lake Object relacionado', ExplicacaoAlternativa__c='Os campos do DLO são a origem dos dados, mas o que é enviado para o destino é controlado pelos Attributes da Activation, não pelos campos do DLO diretamente.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[19].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='As Sharing Rules do objeto Unified Individual no CRM', ExplicacaoAlternativa__c='Sharing Rules são um conceito do CRM e não controlam o que é incluído no payload de uma Activation do Data Cloud.'));

// Q21 — Data Actions
alts.add(new AlternativaQuestao__c(Questao__c=questoes[20].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Data Action configurado para disparar uma entrada no Journey Builder ao detectar mudança no segmento', ExplicacaoAlternativa__c='Data Actions monitoram eventos em DMOs ou segmentos e disparam ações em sistemas externos, incluindo entradas em Journey Builder do Marketing Cloud, em tempo quase real.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[20].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Scheduled Flow que consulta o Data Cloud a cada hora e cria entradas no Journey Builder', ExplicacaoAlternativa__c='Um Flow agendado por hora não é em tempo real e não é a abordagem nativa do Data Cloud para acionar jornadas baseadas em eventos de segmento.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[20].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Ativação via Marketing Cloud Connector que republica o segmento a cada 5 minutos', ExplicacaoAlternativa__c='Republicar o segmento a cada 5 minutos gera carga desnecessária e não é o mesmo que um gatilho baseado em evento. Data Actions são mais adequados para esse cenário.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[20].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Trigger Apex no objeto Contact que monitora mudanças e chama a API do Journey Builder', ExplicacaoAlternativa__c='Um Apex Trigger no Contact monitora o CRM, não os perfis unificados do Data Cloud. Não capturaria mudanças de segmento baseadas em dados do Data Cloud.'));

// Q22 — Flows
alts.add(new AlternativaQuestao__c(Questao__c=questoes[21].Id, OrdemExibicao__c=1, Correta__c=true,  TextoAlternativa__c='Usando a ação "Get Data Cloud Records" no Flow Builder para consultar DMOs em tempo de execução', ExplicacaoAlternativa__c='A ação nativa "Get Data Cloud Records" no Flow Builder consulta DMOs do Data Cloud durante a execução do Flow, trazendo dados unificados sem mover dados previamente para o CRM.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[21].Id, OrdemExibicao__c=2, Correta__c=false, TextoAlternativa__c='Usando um elemento "Get Records" apontando para um objeto customizado sincronizado do Data Cloud', ExplicacaoAlternativa__c='"Get Records" opera sobre objetos CRM. Se os dados foram sincronizados para objetos CRM previamente, funciona, mas não é a abordagem nativa de consumir Data Cloud em tempo real no Flow.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[21].Id, OrdemExibicao__c=3, Correta__c=false, TextoAlternativa__c='Chamando a Data Cloud REST API via elemento HTTP Callout no Flow', ExplicacaoAlternativa__c='HTTP Callout é possível mas exige configuração adicional (External Credential, Named Credential). A ação nativa "Get Data Cloud Records" é a abordagem recomendada e mais simples.'));
alts.add(new AlternativaQuestao__c(Questao__c=questoes[21].Id, OrdemExibicao__c=4, Correta__c=false, TextoAlternativa__c='Usando uma subquery SOQL no Flow para acessar dados do Data Cloud via External Objects', ExplicacaoAlternativa__c='External Objects via Salesforce Connect não é a integração nativa do Data Cloud com Flows. O Data Cloud tem sua própria ação dedicada no Flow Builder.'));

insert alts;
System.debug('Alternativas inseridas: ' + alts.size());
System.debug('CONCLUÍDO: Certificação, ' + 6 + ' domínios, ' + topicos.size() + ' tópicos, ' + questoes.size() + ' questões, ' + alts.size() + ' alternativas.');
