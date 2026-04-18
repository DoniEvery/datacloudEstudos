import { LightningElement } from 'lwc';
import basePath from '@salesforce/community/basePath';

export default class DcSelfRegister extends LightningElement {
    goToStandardSelfRegister() {
        window.location.href = `${basePath}/SelfRegister`;
    }

    goBackLogin() {
        window.location.href = `${basePath}/login`;
    }
}
