import { LightningElement, wire } from 'lwc';
import getTopicos from '@salesforce/apex/QuestaoEstudoController.getTopicos';
import getQuestoes from '@salesforce/apex/QuestaoEstudoController.getQuestoes';

export default class QuestaoEstudo extends LightningElement {
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
    isLoading = false;
    topicoSelecionado = null;

    @wire(getTopicos)
    wiredTopicos({ error, data }) {
        if (data) {
            this.topicos = data;
        } else if (error) {
            console.error('Erro ao carregar tópicos:', error);
        }
    }

    handleTopicoChange(event) {
        this.topicoSelecionado = event.target.value;
        
        if (this.topicoSelecionado) {
            this.isLoading = true;
            this.carregarQuestoes();
        } else {
            this.questoes = [];
            this.questaoAtual = null;
            this.indexAtual = 0;
            this.totalQuestoes = 0;
        }
    }

    carregarQuestoes() {
        getQuestoes({ topicoId: this.topicoSelecionado })
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
        }
    }

    handleAlternativaClick(event) {
        const botao = event.target.closest('button');
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
    }

    handleProxima() {
        if (this.questoes.length > 0) {
            const proximoIndex = (this.indexAtual + 1) % this.questoes.length;
            this.exibirQuestao(proximoIndex);
        }
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
}
