// PARTE 1 — Certificação + Domínios + Tópicos
Certificacao__c cert = new Certificacao__c(
    Name = 'Salesforce Data 360 Consultant',
    Descricao__c = 'Certifica conhecimento em Data Cloud (Data 360): ingestão, harmonização, segmentação, ativação e IA sobre dados unificados.',
    Nivel__c = 'Professional'
);
insert cert;

DominioCertificacao__c d1 = new DominioCertificacao__c(Name='Solution Positioning',                      Certificacao__c=cert.Id, Codigo__c='D1', PesoProva__c=14, OrdemExibicao__c=1);
DominioCertificacao__c d2 = new DominioCertificacao__c(Name='Data 360 Setup and Administration',          Certificacao__c=cert.Id, Codigo__c='D2', PesoProva__c=13, OrdemExibicao__c=2);
DominioCertificacao__c d3 = new DominioCertificacao__c(Name='Data Source Connection and Ingestion',       Certificacao__c=cert.Id, Codigo__c='D3', PesoProva__c=18, OrdemExibicao__c=3);
DominioCertificacao__c d4 = new DominioCertificacao__c(Name='Harmonization and Unification',              Certificacao__c=cert.Id, Codigo__c='D4', PesoProva__c=17, OrdemExibicao__c=4);
DominioCertificacao__c d5 = new DominioCertificacao__c(Name='Data Enhancements, Sharing, and Analysis',   Certificacao__c=cert.Id, Codigo__c='D5', PesoProva__c=18, OrdemExibicao__c=5);
DominioCertificacao__c d6 = new DominioCertificacao__c(Name='Data Activations and Utilization',           Certificacao__c=cert.Id, Codigo__c='D6', PesoProva__c=20, OrdemExibicao__c=6);
insert new List<DominioCertificacao__c>{d1,d2,d3,d4,d5,d6};

List<Topico__c> ts = new List<Topico__c>{
    new Topico__c(Name='Terminologia e valor de negócio do Data 360',            DominioCertificacao__c=d1.Id, OrdemExibicao__c=1),
    new Topico__c(Name='Data 360 como base para IA generativa e preditiva',      DominioCertificacao__c=d1.Id, OrdemExibicao__c=2),
    new Topico__c(Name='Casos de uso iniciais para Data 360',                    DominioCertificacao__c=d1.Id, OrdemExibicao__c=3),
    new Topico__c(Name='Ética e governança de dados',                            DominioCertificacao__c=d1.Id, OrdemExibicao__c=4),
    new Topico__c(Name='Permissões e configurações organizacionais',             DominioCertificacao__c=d2.Id, OrdemExibicao__c=1),
    new Topico__c(Name='Governança de dados na configuração da plataforma',      DominioCertificacao__c=d2.Id, OrdemExibicao__c=2),
    new Topico__c(Name='Ciclo de desenvolvimento e ferramentas disponíveis',     DominioCertificacao__c=d2.Id, OrdemExibicao__c=3),
    new Topico__c(Name='Diagnóstico e solução de problemas comuns',              DominioCertificacao__c=d2.Id, OrdemExibicao__c=4),
    new Topico__c(Name='Transformação de dados no Data 360',                     DominioCertificacao__c=d3.Id, OrdemExibicao__c=1),
    new Topico__c(Name='Ingestão de dados de fontes variadas',                   DominioCertificacao__c=d3.Id, OrdemExibicao__c=2),
    new Topico__c(Name='Colaboração de dados e Zero-Copy',                       DominioCertificacao__c=d3.Id, OrdemExibicao__c=3),
    new Topico__c(Name='Propósito, processo e casos de uso da unificação',       DominioCertificacao__c=d4.Id, OrdemExibicao__c=1),
    new Topico__c(Name='Modelagem de dados no Data 360',                         DominioCertificacao__c=d4.Id, OrdemExibicao__c=2),
    new Topico__c(Name='Enriquecimento de dados e construção de insights',       DominioCertificacao__c=d5.Id, OrdemExibicao__c=1),
    new Topico__c(Name='Referenciamento de dados do Data 360 em outros sistemas',DominioCertificacao__c=d5.Id, OrdemExibicao__c=2),
    new Topico__c(Name='Relatórios e dashboards com Data 360',                   DominioCertificacao__c=d5.Id, OrdemExibicao__c=3),
    new Topico__c(Name='IA preditiva e generativa no Data 360',                  DominioCertificacao__c=d5.Id, OrdemExibicao__c=4),
    new Topico__c(Name='Conceitos de segmentação e casos de uso',                DominioCertificacao__c=d6.Id, OrdemExibicao__c=1),
    new Topico__c(Name='Gerenciamento de segmentos no Data 360',                 DominioCertificacao__c=d6.Id, OrdemExibicao__c=2),
    new Topico__c(Name='Publicação de Activations no Data 360',                  DominioCertificacao__c=d6.Id, OrdemExibicao__c=3),
    new Topico__c(Name='Ação sobre dados',                                       DominioCertificacao__c=d6.Id, OrdemExibicao__c=4),
    new Topico__c(Name='Uso do Data 360 em Salesforce Flows',                    DominioCertificacao__c=d6.Id, OrdemExibicao__c=5)
};
insert ts;

System.debug('PART1 OK | cert=' + cert.Id);
for(DominioCertificacao__c d : [SELECT Id,Codigo__c FROM DominioCertificacao__c WHERE Certificacao__c=:cert.Id ORDER BY OrdemExibicao__c]) System.debug('DOM ' + d.Codigo__c + '=' + d.Id);
for(Topico__c t : [SELECT Id,Name,OrdemExibicao__c,DominioCertificacao__r.Codigo__c FROM Topico__c WHERE DominioCertificacao__r.Certificacao__c=:cert.Id ORDER BY DominioCertificacao__r.OrdemExibicao__c,OrdemExibicao__c]) System.debug('TOP ' + t.DominioCertificacao__r.Codigo__c + '.' + t.OrdemExibicao__c + '=' + t.Id + ' | ' + t.Name);
