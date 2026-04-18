import { LightningElement, track } from 'lwc';
import basePath from '@salesforce/community/basePath';
import forgotPassword from '@salesforce/apex/LightningForgotPasswordController.forgotPassword';

export default class DcForgotPassword extends LightningElement {
    @track username = '';
    @track error = '';
    @track success = '';
    @track isLoading = false;

    handleInputChange(event) {
        this.username = event.target.value;
        this.error = '';
        this.success = '';
    }

    async handleSubmit() {
        if (!this.username) {
            this.error = 'Informe seu e-mail.';
            return;
        }
        this.isLoading = true;
        try {
            const result = await forgotPassword({
                username: this.username,
                checkEmailUrl: './CheckPasswordResetEmail'
            });
            if (result) {
                this.error = result;
            } else {
                this.success = 'Enviamos as instruções para redefinição de senha.';
            }
        } catch (e) {
            this.error = 'Não foi possível processar agora.';
            // eslint-disable-next-line no-console
            console.error(e);
        } finally {
            this.isLoading = false;
        }
    }

    goBack() {
        window.location.href = `${basePath}/login`;
    }
}
