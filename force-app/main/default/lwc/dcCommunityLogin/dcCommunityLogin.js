import { LightningElement, track } from 'lwc';
import basePath from '@salesforce/community/basePath';
import communityLogin from '@salesforce/apex/LightningLoginFormController.loginLwc';
import setExperienceId from '@salesforce/apex/LightningLoginFormController.setExperienceId';

export default class DcCommunityLogin extends LightningElement {
    @track disableButton = true;

    destaque = true;
    @track username = '';
    @track password = '';
    @track error = '';
    @track isLoading = false;

    connectedCallback() {
        this.applyExperienceId();
    }

    async applyExperienceId() {
        try {
            const params = new URL(window.location.href).searchParams;
            const expId = params.get('expid');
            if (expId) {
                await setExperienceId({ expId });
            }
        } catch (e) {
            // eslint-disable-next-line no-console
            console.error(e);
        }
    }

    get inputClass() {
        return !this.destaque ? 'custom-input custom-input-error' : 'custom-input';
    }

    handleUsernameChange(event) {
        this.username = event.target.value;
        this.error = '';
        this.validarFormulario();
    }

    handlePasswordChange(event) {
        this.password = event.target.value;
        this.error = '';
        this.validarFormulario();
    }

    handleInputChange(event) {
        const fieldType = event.target.type;

        if (fieldType === 'email') {
            this.username = event.target.value;
        } else if (fieldType === 'password') {
            this.password = event.target.value;
        }

        this.validarFormulario();
    }

    validarFormulario() {
        const emailValido = this.validarEmail(this.username);
        const senhaPreenchida = this.password && this.password.trim() !== '';

        this.disableButton = !(emailValido && senhaPreenchida);
    }

    async handleLogin() {
        if (this.username !== undefined && this.password !== undefined) {
            this.isLoading = true;

            try {
                const params = new URL(window.location.href).searchParams;
                const startUrlParam = params.get('startURL');
                const startUrl = startUrlParam ? decodeURIComponent(startUrlParam) : '/';

                const result = await communityLogin({
                    username: this.username,
                    password: this.password,
                    startUrl
                });

                if (result && (result.startsWith('http://') || result.startsWith('https://') || result.startsWith('/'))) {
                    window.location.href = result;
                    this.isLoading = false;
                } else if (result === null || result === undefined || result === '') {
                    window.location.href = `${basePath}/`;
                    this.isLoading = false;
                } else {
                    this.destaque = !this.destaque;
                    this.error = result || 'Dados incorretos';
                    this.isLoading = false;
                }
            } catch (e) {
                this.error = 'Dados incorretos';
                this.isLoading = false;
                // eslint-disable-next-line no-console
                console.error(e);
            }
        } else {
            this.destaque = !this.destaque;
            this.error = 'Informe usuário e senha.';
            this.isLoading = false;
        }
    }

    validarEmail(email) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    }

    goToSelfRegister() {
        const destino = `${basePath}/cadastro`;
        window.location.href = destino;
    }

    handleCadastro() {
        const destino = `${basePath}/cadastro`;
        window.location.href = destino;
    }

    goToForgotPassword() {
        const destino = `${basePath}/ForgotPassword`;
        window.location.href = destino;
    }

    handleForgotPass() {
        const destino = `${basePath}/ForgotPassword`;
        window.location.href = destino;
    }
}
