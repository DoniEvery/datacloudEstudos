import { LightningElement, wire } from 'lwc';
import getCertificacoes from '@salesforce/apex/QuestaoEstudoController.getCertificacoes';
import getTopicos from '@salesforce/apex/QuestaoEstudoController.getTopicos';
import getQuestoes from '@salesforce/apex/QuestaoEstudoController.getQuestoes';
import registrarResposta from '@salesforce/apex/QuestaoEstudoController.registrarResposta';

export default class QuestaoEstudo extends LightningElement {
    static TODOS_TOPICOS_VALUE = '__ALL__';

    certificacoes = [];
    certificacaoSelecionada = null;
    topicos = [];
    questoes = [];
    questaoAtual = null;
    indexAtual = 0;
    totalQuestoes = 0;
    mostrarResultado = false;
    alternativaSelecionada = null;
    mensagemResultado = '';
    respostaCorreta = '';
    acertou = false;
    proximaRevisaoLabel = '';
    isLoading = false;
    topicoSelecionado = null;

    connectedCallback() {
        this.carregarCertificacoes();
    }

    carregarCertificacoes() {
        getCertificacoes()
            .then((data) => {
                this.certificacoes = data;
            })
            .catch((error) => {
                console.error('Erro ao carregar certificações:', error);
            });
    }

    handleCertificacaoChange(event) {
        this.certificacaoSelecionada = event.target.value;
        this.topicoSelecionado = null;
        this.topicos = [];
        this.resetQuestoes();

        if (this.certificacaoSelecionada) {
            this.isLoading = true;
            getTopicos({ certificacaoId: this.certificacaoSelecionada })
                .then((data) => {
                    this.topicos = data;
                    this.isLoading = false;
                })
                .catch((error) => {
                    console.error('Erro ao carregar tópicos:', error);
                    this.isLoading = false;
                });
        }
    }

    handleTopicoChange(event) {
        this.topicoSelecionado = event.target.value;

        if (this.temFiltroValido) {
            this.isLoading = true;
            this.carregarQuestoes();
        } else {
            this.resetQuestoes();
        }
    }

    get temFiltroValido() {
        return !!this.certificacaoSelecionada && !!this.topicoSelecionado;
    }

    get estudandoTodosTopicos() {
        return this.topicoSelecionado === QuestaoEstudo.TODOS_TOPICOS_VALUE;
    }

    resetQuestoes() {
        this.questoes = [];
        this.questaoAtual = null;
        this.indexAtual = 0;
        this.totalQuestoes = 0;
    }

    carregarQuestoes() {
        getQuestoes({
            topicoId: this.estudandoTodosTopicos ? null : this.topicoSelecionado,
            certificacaoId: this.certificacaoSelecionada,
            incluirTodosTopicos: this.estudandoTodosTopicos
        })
            .then((result) => {
                this.questoes = result;
                this.totalQuestoes = result.length;
                
                if (this.questoes.length > 0) {
                    this.indexAtual = 0;
                    this.exibirQuestao(0);
                }
                
                this.isLoading = false;
            })
            .catch((error) => {
                console.error('Erro ao carregar questões:', error);
                this.isLoading = false;
            });
    }

    exibirQuestao(index) {
        if (index < this.questoes.length) {
            this.questaoAtual = JSON.parse(JSON.stringify(this.questoes[index]));
            this.indexAtual = index;
            this.mostrarResultado = false;
            this.alternativaSelecionada = null;
            this.respostaCorreta = '';
            this.acertou = false;
            this.proximaRevisaoLabel = '';
        }
    }

    handleAlternativaClick(event) {
        const botao = event.currentTarget;
        const alternativaId = botao.dataset.id;
        const ehCorreta = botao.dataset.correta === 'true';

        this.alternativaSelecionada = alternativaId;
        this.mostrarResultado = true;
        this.acertou = ehCorreta;

        if (ehCorreta) {
            this.mensagemResultado = '✓ Resposta Correta!';
            this.respostaCorreta = '';
        } else {
            this.mensagemResultado = '✗ Resposta Incorreta!';
            const altCorreta = this.questaoAtual?.alternativas?.find((alt) => alt.correta);
            this.respostaCorreta = altCorreta
                ? `${this.getLetraFromOrdem(altCorreta.ordem)} - ${altCorreta.texto}`
                : 'Não identificada';
        }

        registrarResposta({ questaoId: this.questaoAtual.id, acertou: ehCorreta })
            .then((result) => {
                this.proximaRevisaoLabel = this.getProximaRevisaoLabel(result.intervalo);
            })
            .catch((err) => console.error('Erro ao registrar resposta:', err));
    }

    getProximaRevisaoLabel(intervalo) {
        if (intervalo <= 1) return 'Próxima revisão: amanhã';
        if (intervalo <= 3) return 'Próxima revisão: em 3 dias';
        if (intervalo <= 7) return 'Próxima revisão: em 1 semana';
        if (intervalo <= 14) return 'Próxima revisão: em 2 semanas';
        return 'Próxima revisão: em 1 mês';
    }

    handleProxima() {
        if (this.questoes.length > 0) {
            const proximoIndex = (this.indexAtual + 1) % this.questoes.length;
            this.exibirQuestao(proximoIndex);
        }
    }

    get alternativasRenderizadas() {
        if (!this.questaoAtual?.alternativas) {
            return [];
        }
        return this.questaoAtual.alternativas.map((alt) => ({
            ...alt,
            letra: this.getLetraFromOrdem(alt.ordem),
            classe: this.getAlternativaClass(alt)
        }));
    }

    getAlternativaClass(alternativa) {
        let classe = 'alternativa-btn';

        if (this.mostrarResultado) {
            if (alternativa.correta) {
                classe += ' correta';
            } else if (alternativa.id === this.alternativaSelecionada) {
                classe += ' incorreta';
            }
        }

        return classe;
    }

    getLetraFromOrdem(ordem) {
        return String.fromCharCode(64 + ordem); // A=1, B=2, C=3, D=4...
    }

    get getResultadoClass() {
        return this.acertou ? 'resultado sucesso' : 'resultado erro';
    }

    get mostrarRespostaCorreta() {
        return this.mostrarResultado && !this.acertou && !!this.respostaCorreta;
    }

    get progressoTexto() {
        return `Questão ${this.indexAtual + 1} de ${this.totalQuestoes}`;
    }
}