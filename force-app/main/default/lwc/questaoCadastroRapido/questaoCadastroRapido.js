import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import criarQuestaoComAlternativas from '@salesforce/apex/QuestaoCadastroController.criarQuestaoComAlternativas';
import getCertificacoes from '@salesforce/apex/QuestaoCadastroController.getCertificacoes';
import getDominios from '@salesforce/apex/QuestaoCadastroController.getDominios';
import getTopicos from '@salesforce/apex/QuestaoCadastroController.getTopicos';
import getColecoesSimulado from '@salesforce/apex/QuestaoCadastroController.getColecoesSimulado';
import getSubtopicos from '@salesforce/apex/QuestaoCadastroController.getSubtopicos';

export default class QuestaoCadastroRapido extends LightningElement {
    @track isSaving = false;

    // Estados dos Campos
    @track certificacaoId = '';
    @track dominioId = '';
    @track topicoId = '';
    @track nome = '';
    @track enunciado = '';
    @track tipoQuestao = 'Exercicio';
    @track nivelDificuldade = 'Facil';
    @track colecaoSimulado = 'Fundamentos Data Cloud';
    @track nivelSimulado = 1;
    @track origemSimulado = 'Salesforce';
    @track subtopico = '';
    @track codigoInterno = '';
    @track ativa = true;

    // Dados das Picklists
    @track certificacoes = [];
    @track dominios = [];
    @track topicos = [];
    @track colecoesSimulado = [];
    @track subtopicos = [];

    // Opções Fixas
    get tipoOptions () {
        return [
            { label: 'Simulado', value: 'Simulado' },
            { label: 'Exercício', value: 'Exercicio' }
        ];
    }

    get dificuldadeOptions () {
        return [
            { label: 'Fácil', value: 'Facil' },
            { label: 'Médio', value: 'Medio' },
            { label: 'Difícil', value: 'Dificil' }
        ];
    }

    @track alternativaView = [
        { idx: 0, texto: '', explicacao: '', checked: true },
        { idx: 1, texto: '', explicacao: '', checked: false },
        { idx: 2, texto: '', explicacao: '', checked: false },
        { idx: 3, texto: '', explicacao: '', checked: false }
    ];

    // --- CARREGAMENTO INICIAL ---

    @wire( getCertificacoes )
    wiredCert ( { error, data } ) {
        if ( data )
        {
            this.certificacoes = data;
            if ( data.length > 0 && !this.certificacaoId )
            {
                this.certificacaoId = data[ 0 ].value;
                this.buscarDominios( this.certificacaoId );
            }
        }
    }

    @wire( getColecoesSimulado ) wiredCol ( { data } ) { if ( data ) this.colecoesSimulado = data; }
    @wire( getSubtopicos ) wiredSub ( { data } ) { if ( data ) this.subtopicos = data; }

    async buscarDominios ( certId ) {
        const data = await getDominios( { certificacaoId: certId } );
        this.dominios = data;
        if ( data && data.length > 0 )
        {
            this.dominioId = data[ 0 ].value;
            this.buscarTopicos( this.dominioId );
        }
    }

    async buscarTopicos ( domId ) {
        const data = await getTopicos( { dominioId: domId } );
        this.topicos = data;
        if ( data && data.length > 0 ) this.topicoId = data[ 0 ].value;
    }

    // --- HANDLERS ---

    handleCertificacaoChange ( e ) { this.certificacaoId = e.detail.value; this.buscarDominios( this.certificacaoId ); }
    handleDominioChange ( e ) { this.dominioId = e.detail.value; this.buscarTopicos( this.dominioId ); }
    handleTopicoChange ( e ) { this.topicoId = e.detail.value; }

    // CORREÇÃO AQUI: Handlers para Tipo e Dificuldade
    handleTipoChange ( e ) { this.tipoQuestao = e.detail.value; }
    handleDificuldadeChange ( e ) { this.nivelDificuldade = e.detail.value; }

    handleNomeChange ( e ) { this.nome = e.detail.value; }
    handleEnunciadoChange ( e ) { this.enunciado = e.detail.value; }
    handleColecaoChange ( e ) { this.colecaoSimulado = e.detail.value; }
    handleNivelSimuladoChange ( e ) { this.nivelSimulado = e.detail.value; }
    handleOrigemChange ( e ) { this.origemSimulado = e.detail.value; }

    handleAlternativaTextoChange ( e ) { this.alternativaView[ e.target.dataset.index ].texto = e.detail.value; }
    handleAlternativaExplicacaoChange ( e ) { this.alternativaView[ e.target.dataset.index ].explicacao = e.detail.value; }
    handleRadioChange ( e ) {
        const idx = e.target.dataset.index;
        this.alternativaView = this.alternativaView.map( ( a, i ) => ( { ...a, checked: i == idx } ) );
    }

    // --- SALVAR E RESET ---

    resetForm () {
        this.nome = '';
        this.enunciado = '';
        this.tipoQuestao = 'Simulado'; // Volta ao padrão
        this.nivelDificuldade = 'Facil'; // Volta ao padrão
        this.colecaoSimulado = '';
        this.nivelSimulado = 1;
        this.origemSimulado = '';
        this.alternativaView = [
            { idx: 0, texto: '', explicacao: '', checked: true },
            { idx: 1, texto: '', explicacao: '', checked: false },
            { idx: 2, texto: '', explicacao: '', checked: false },
            { idx: 3, texto: '', explicacao: '', checked: false }
        ];
        // Mantém certificação atual, mas poderia resetar se quisesse
    }

    async handleSalvar () {
        this.isSaving = true;
        const input = {
            nome: this.nome,
            enunciado: this.enunciado,
            certificacaoId: this.certificacaoId,
            dominioId: this.dominioId,
            topicoId: this.topicoId,
            tipoQuestao: this.tipoQuestao,
            nivelDificuldade: this.nivelDificuldade,
            colecaoSimulado: this.colecaoSimulado,
            nivelSimulado: parseInt( this.nivelSimulado ) || 1,
            origemSimulado: this.origemSimulado,
            ativa: true,
            alternativas: this.alternativaView.map( a => ( {
                ordem: parseInt( a.idx ) + 1,
                texto: a.texto,
                explicacao: a.explicacao,
                correta: a.checked
            } ) )
        };

        try
        {
            await criarQuestaoComAlternativas( { input } );
            this.dispatchEvent( new ShowToastEvent( { title: 'Sucesso', message: 'Questão criada!', variant: 'success' } ) );
            this.resetForm();
        } catch ( error )
        {
            this.dispatchEvent( new ShowToastEvent( { title: 'Erro', message: error.body?.message || error.message, variant: 'error' } ) );
        } finally
        {
            this.isSaving = false;
        }
    }
}