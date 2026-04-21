import { LightningElement } from 'lwc';
import getCertificacoes from '@salesforce/apex/QuestaoEstudoController.getCertificacoes';
import getTopicos from '@salesforce/apex/QuestaoEstudoController.getTopicos';
import getSimuladosDisponiveis from '@salesforce/apex/QuestaoEstudoController.getSimuladosDisponiveis';
import getQuestoes from '@salesforce/apex/QuestaoEstudoController.getQuestoes';
import registrarResposta from '@salesforce/apex/QuestaoEstudoController.registrarResposta';

export default class QuestaoEstudo extends LightningElement {
    certificacoes = [];
    certificacaoSelecionada = null;
    modoEstudo = null;
    simuladosDisponiveis = [];
    simuladoSelecionado = null;
    topicos = [];
    subtopicos = [];
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
    explicacaoSelecionada = '';
    explicacaoCorreta = '';
    respostasSimulado = {};
    simuladoAtivo = false;
    simuladoFinalizado = false;
    tempoRestanteSegundos = 0;
    tempoTotalSimuladoSegundos = 5400; // 1h30
    timerIntervalId;
    acertosSimulado = 0;
    errosSimulado = 0;

    connectedCallback() {
        this.carregarCertificacoes();
    }

    disconnectedCallback() {
        this.pararTimer();
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
        this.modoEstudo = null;
        this.topicoSelecionado = null;
        this.simuladosDisponiveis = [];
        this.simuladoSelecionado = null;
        this.topicos = [];
        this.subtopicos = [];
        this.resetQuestoes();
    }

    handleModoChange(event) {
        this.modoEstudo = event.target.value || null;
        this.topicoSelecionado = null;
        this.simuladosDisponiveis = [];
        this.simuladoSelecionado = null;
        this.subtopicos = [];
        this.topicos = [];
        this.resetQuestoes();

        if (!this.certificacaoSelecionada || !this.modoEstudo) {
            return;
        }

        this.isLoading = true;

        if (this.ehModoSimulado && this.certificacaoSelecionada) {
            this.carregarSimuladosDisponiveis();
            return;
        }

        if (this.ehModoLivre && this.certificacaoSelecionada) {
            this.carregarTopicos();
        }
    }

    handleSimuladoChange(event) {
        this.simuladoSelecionado = event.target.value;
        this.resetQuestoes();
        // Questões serão carregadas somente ao clicar em "Iniciar Simulado"
    }

    handleTopicoChange(event) {
        this.topicoSelecionado = event.target.value;
        this.resetQuestoes();
        this.subtopicos = [];
        // Questões serão carregadas somente ao clicar em "Iniciar Estudo Livre"
    }

    get temFiltroValido() {
        if (!this.modoEstudo) {
            return false;
        }
        if (this.ehModoSimulado) {
            return !!this.certificacaoSelecionada && !!this.simuladoSelecionado;
        }
        return !!this.certificacaoSelecionada && !!this.topicoSelecionado;
    }

    get modoNaoSelecionado() {
        return !this.modoEstudo;
    }

    get ehModoLivre() {
        return this.modoEstudo === 'LIVRE';
    }

    get ehModoSimulado() {
        return this.modoEstudo === 'SIMULADO';
    }

    get mostrarSeletorModo() {
        return !!this.certificacaoSelecionada;
    }

    get modosEstudo() {
        return [
            { value: 'LIVRE', label: 'Estudo Livre', selected: this.modoEstudo === 'LIVRE' },
            { value: 'SIMULADO', label: 'Simulado (60 questões, 1h30)', selected: this.modoEstudo === 'SIMULADO' }
        ];
    }

    get mostrarSeletorSimulado() {
        return this.ehModoSimulado && !!this.certificacaoSelecionada;
    }

    get simuladosRenderizados() {
        return (this.simuladosDisponiveis || []).map((simulado) => ({
            ...simulado,
            selected: simulado.id === this.simuladoSelecionado
        }));
    }

    get podeIniciar() {
        return this.temFiltroValido && !this.isLoading;
    }

    get botaoIniciarDesabilitado() {
        return !this.podeIniciar;
    }

    get semSimuladoSelecionado() {
        return !this.simuladoSelecionado;
    }

    get temSubtopicos() {
        return this.subtopicos && this.subtopicos.length > 0;
    }

    resetQuestoes() {
        this.pararTimer();
        this.questoes = [];
        this.questaoAtual = null;
        this.indexAtual = 0;
        this.totalQuestoes = 0;
        this.respostasSimulado = {};
        this.simuladoAtivo = false;
        this.simuladoFinalizado = false;
        this.tempoRestanteSegundos = 0;
        this.acertosSimulado = 0;
        this.errosSimulado = 0;
        this.mensagemResultado = '';
        this.alternativaSelecionada = null;
        this.mostrarResultado = false;
    }

    carregarTopicos() {
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

    carregarSimuladosDisponiveis() {
        getSimuladosDisponiveis({ certificacaoId: this.certificacaoSelecionada })
            .then((data) => {
                this.simuladosDisponiveis = data || [];
                this.simuladoSelecionado = null;
                this.isLoading = false;
            })
            .catch((error) => {
                console.error('Erro ao carregar simulados disponíveis:', error);
                this.isLoading = false;
            });
    }

    handleIniciarEstudo() {
        if (!this.podeIniciar) {
            return;
        }
        this.isLoading = true;
        this.carregarQuestoes();
    }

    carregarQuestoes() {
        getQuestoes({
            topicoId: null,
            dominioId: this.ehModoLivre ? this.topicoSelecionado : null,
            certificacaoId: this.certificacaoSelecionada,
            incluirTodosTopicos: this.ehModoSimulado,
            modoEstudo: this.modoEstudo,
            colecaoSimulado: this.simuladoSelecionado
        })
            .then((result) => {
                const questoesBase = this.ehModoSimulado ? this.embaralharArray([...result]).slice(0, 60) : result;
                this.questoes = questoesBase;
                this.totalQuestoes = questoesBase.length;
                
                if (this.questoes.length > 0) {
                    this.indexAtual = 0;
                    this.exibirQuestao(0);
                    if (this.ehModoSimulado) {
                        this.iniciarTimer();
                        this.simuladoAtivo = true;
                    }
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
            this.embaralharAlternativasQuestaoAtual();

            if (this.ehModoSimulado) {
                const respostaMarcada = this.respostasSimulado[this.questaoAtual.id];
                this.alternativaSelecionada = respostaMarcada || null;
            }

            this.indexAtual = index;
            this.mostrarResultado = false;
            if (!this.ehModoSimulado) {
                this.alternativaSelecionada = null;
            }
            this.respostaCorreta = '';
            this.acertou = false;
            this.proximaRevisaoLabel = '';
            this.explicacaoSelecionada = '';
            this.explicacaoCorreta = '';
        }
    }

    embaralharAlternativasQuestaoAtual() {
        if (!this.questaoAtual?.alternativas || this.questaoAtual.alternativas.length <= 1) {
            return;
        }

        const alternativas = [...this.questaoAtual.alternativas];

        // Fisher-Yates
        for (let i = alternativas.length - 1; i > 0; i -= 1) {
            const j = Math.floor(Math.random() * (i + 1));
            [alternativas[i], alternativas[j]] = [alternativas[j], alternativas[i]];
        }

        // Reindexa a ordem para que as letras (A/B/C/D) reflitam a ordem exibida
        this.questaoAtual.alternativas = alternativas.map((alt, idx) => ({
            ...alt,
            ordem: idx + 1
        }));
    }

    handleAlternativaClick(event) {
        const botao = event.currentTarget;
        const alternativaId = botao.dataset.id;
        const ehCorreta = botao.dataset.correta === 'true';

        if (this.ehModoSimulado) {
            this.alternativaSelecionada = alternativaId;
            this.respostasSimulado = {
                ...this.respostasSimulado,
                [this.questaoAtual.id]: alternativaId
            };
            return;
        }

        const alternativaSelecionada = this.questaoAtual?.alternativas?.find((alt) => alt.id === alternativaId);
        const altCorreta = this.questaoAtual?.alternativas?.find((alt) => alt.correta);
        const explicacaoGeral = this.questaoAtual?.explicacao || '';

        this.alternativaSelecionada = alternativaId;
        this.mostrarResultado = true;
        this.acertou = ehCorreta;
        this.explicacaoSelecionada = alternativaSelecionada?.explicacao || explicacaoGeral;
        this.explicacaoCorreta = '';

        if (ehCorreta) {
            this.mensagemResultado = '✓ Resposta Correta!';
            this.respostaCorreta = '';
        } else {
            this.mensagemResultado = '✗ Resposta Incorreta!';
            this.respostaCorreta = altCorreta
                ? `${this.getLetraFromOrdem(altCorreta.ordem)} - ${altCorreta.texto}`
                : 'Não identificada';
            this.explicacaoCorreta = altCorreta?.explicacao || explicacaoGeral;
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
        if (this.ehModoSimulado) {
            if (this.indexAtual >= this.questoes.length - 1) {
                this.finalizarSimulado(false);
            } else {
                this.exibirQuestao(this.indexAtual + 1);
            }
            return;
        }

        if (this.questoes.length > 0) {
            const proximoIndex = (this.indexAtual + 1) % this.questoes.length;
            this.exibirQuestao(proximoIndex);
        }
    }

    iniciarTimer() {
        this.pararTimer();
        this.tempoRestanteSegundos = this.tempoTotalSimuladoSegundos;
        this.timerIntervalId = window.setInterval(() => {
            if (this.tempoRestanteSegundos <= 1) {
                this.tempoRestanteSegundos = 0;
                this.finalizarSimulado(true);
                return;
            }
            this.tempoRestanteSegundos -= 1;
        }, 1000);
    }

    pararTimer() {
        if (this.timerIntervalId) {
            window.clearInterval(this.timerIntervalId);
            this.timerIntervalId = null;
        }
    }

    finalizarSimulado(tempoEsgotado) {
        this.pararTimer();
        this.simuladoAtivo = false;
        this.simuladoFinalizado = true;

        let acertos = 0;
        for (const q of this.questoes) {
            const respostaId = this.respostasSimulado[q.id];
            const correta = q.alternativas?.find((a) => a.correta);
            if (respostaId && correta && respostaId === correta.id) {
                acertos += 1;
            }
        }

        this.acertosSimulado = acertos;
        this.errosSimulado = this.questoes.length - acertos;
        this.mensagemResultado = tempoEsgotado
            ? 'Tempo encerrado! Simulado finalizado automaticamente.'
            : 'Simulado finalizado!';
    }

    get tempoRestanteFormatado() {
        const total = Math.max(0, this.tempoRestanteSegundos);
        const horas = Math.floor(total / 3600);
        const minutos = Math.floor((total % 3600) / 60);
        const segundos = total % 60;

        const hh = String(horas).padStart(2, '0');
        const mm = String(minutos).padStart(2, '0');
        const ss = String(segundos).padStart(2, '0');
        return `${hh}:${mm}:${ss}`;
    }

    get percentualSimulado() {
        if (!this.questoes.length) {
            return 0;
        }
        return Math.round((this.acertosSimulado / this.questoes.length) * 100);
    }

    get questoesRespondidasCount() {
        return Object.keys(this.respostasSimulado || {}).length;
    }

    get percentualProgressoSimulado() {
        if (!this.questoes.length) {
            return 0;
        }
        return Math.round((this.questoesRespondidasCount / this.questoes.length) * 100);
    }

    get revisaoSimulado() {
        if (!this.ehModoSimulado || !this.simuladoFinalizado || !this.questoes.length) {
            return [];
        }

        return this.questoes.map((q, index) => {
            const correta = q.alternativas?.find((a) => a.correta);
            const respostaId = this.respostasSimulado[q.id];
            const respostaUsuario = q.alternativas?.find((a) => a.id === respostaId);
            const acertou = !!(respostaUsuario && correta && respostaUsuario.id === correta.id);
            const naoRespondida = !respostaUsuario;

            return {
                id: q.id,
                numero: index + 1,
                enunciado: q.enunciado,
                acertou,
                naoRespondida,
                statusLabel: naoRespondida ? 'Não respondida' : acertou ? 'Acertou' : 'Errou',
                statusClasse: naoRespondida ? 'neutra' : acertou ? 'acerto' : 'erro',
                respostaUsuario: respostaUsuario ? respostaUsuario.texto : 'Não respondida',
                respostaCorreta: correta ? correta.texto : 'Não identificada',
                explicacaoCorreta: correta?.explicacao || q.explicacao || ''
            };
        });
    }

    get mostrarQuestaoAtual() {
        return !!this.questaoAtual && !(this.ehModoSimulado && this.simuladoFinalizado);
    }

    get mostrarResumoSimulado() {
        return this.ehModoSimulado && this.simuladoFinalizado;
    }

    get mostrarQuestaoOuResumo() {
        return this.mostrarQuestaoAtual || this.mostrarResumoSimulado;
    }

    get textoBotaoProximo() {
        if (this.ehModoSimulado && this.indexAtual >= this.questoes.length - 1) {
            return 'Finalizar Simulado';
        }
        return 'Próxima Questão →';
    }

    get alternativasBloqueadas() {
        if (this.ehModoSimulado) {
            return !this.simuladoAtivo;
        }
        return this.mostrarResultado;
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

        if (this.ehModoSimulado) {
            if (alternativa.id === this.alternativaSelecionada) {
                classe += ' selecionada';
            }
            return classe;
        }

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

    get mostrarExplicacaoSelecionada() {
        return this.mostrarResultado && !!this.explicacaoSelecionada;
    }

    get mostrarExplicacaoCorreta() {
        return this.mostrarResultado && !this.acertou && !!this.explicacaoCorreta && this.explicacaoCorreta !== this.explicacaoSelecionada;
    }

    get tituloExplicacaoSelecionada() {
        return this.acertou ? 'Por que esta resposta está correta:' : 'Por que sua resposta está incorreta:';
    }

    get progressoTexto() {
        return `Questão ${this.indexAtual + 1} de ${this.totalQuestoes}`;
    }

    embaralharArray(array) {
        const arr = [...array];
        for (let i = arr.length - 1; i > 0; i -= 1) {
            const j = Math.floor(Math.random() * (i + 1));
            [arr[i], arr[j]] = [arr[j], arr[i]];
        }
        return arr;
    }
}