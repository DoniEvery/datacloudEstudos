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
    @track loginAttempt = 0;
    @track maxLoginAttempts = 3;

    connectedCallback() {
        this.cleanupRecursiveLoginUrl();
        this.applyExperienceId();
    }

    cleanupRecursiveLoginUrl() {
        try {
            const url = new URL(window.location.href);
            const rawStartUrl = url.searchParams.get('startURL');
            if (rawStartUrl && rawStartUrl.toLowerCase().includes('/login')) {
                url.searchParams.delete('startURL');
                url.searchParams.delete('ec');
                window.history.replaceState({}, '', url.toString());
            }
        } catch (e) {
            // eslint-disable-next-line no-console
            console.warn('Falha ao normalizar URL de login:', e);
        }
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
            this.loginAttempt = 0;
            await this.tentarLogin();
        } else {
            this.destaque = !this.destaque;
            this.error = 'Informe usuário e senha.';
            this.isLoading = false;
        }
    }

    async tentarLogin() {
        try {
            const params = new URL(window.location.href).searchParams;
            let startUrlParam = params.get('startURL');
            let startUrl = this.sanitizeRedirectUrl(startUrlParam);

            this.loginAttempt++;
            
            // Mostrar tentativa se for retry
            if (this.loginAttempt > 1) {
                this.error = `Tentativa ${this.loginAttempt} de ${this.maxLoginAttempts}...`;
                console.log(`Login attempt ${this.loginAttempt} of ${this.maxLoginAttempts}`);
                
                // Aguardar antes de retentar (exponential backoff)
                const delayMs = 500 * this.loginAttempt;
                await new Promise(resolve => setTimeout(resolve, delayMs));
            }

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
                // Se contiver erro de conexão/3G, fazer retry
                if (this.loginAttempt < this.maxLoginAttempts && 
                    (result.includes('Bad Request') || result.includes('timeout') || result.includes('conexão'))) {
                    console.warn(`Login failed (attempt ${this.loginAttempt}): ${result}. Retrying...`);
                    await this.tentarLogin();
                } else {
                    this.destaque = !this.destaque;
                    this.error = result || 'Dados incorretos';
                    this.isLoading = false;
                    console.error(`Login failed after ${this.loginAttempt} attempts: ${result}`);
                }
            }
        } catch (e) {
            // Tentar novamente em caso de erro de rede
            if (this.loginAttempt < this.maxLoginAttempts) {
                console.warn(`Network error on attempt ${this.loginAttempt}: ${e.message}. Retrying...`);
                await this.tentarLogin();
            } else {
                this.error = 'Erro de conexão. Verifique sua internet e tente novamente.';
                this.isLoading = false;
                console.error(`Login failed after ${this.loginAttempt} attempts:`, e);
            }
        }
    }

    sanitizeRedirectUrl(url) {
        if (!url) {
            return null;
        }

        // Se contém login, retornar home
        if (url.toLowerCase().includes('/login') || 
            url.toLowerCase().includes('CommunitiesLogin') ||
            url.toLowerCase().includes('SiteLogin')) {
            console.warn(`Redirect URL contains login path, redirecting to home instead: ${url}`);
            return null;
        }

        // Se começa com /, retornar como está
        if (url.startsWith('/')) {
            return url;
        }

        // Se não começa com /, adicionar /
        if (!url.startsWith('http')) {
            return '/' + url;
        }

        return url;
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
