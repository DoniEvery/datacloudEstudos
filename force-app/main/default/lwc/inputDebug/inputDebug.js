import { LightningElement } from 'lwc';

export default class InputDebug extends LightningElement {
    valor1 = '';
    valor2 = '';

    handleInput1(event) {
        this.valor1 = event.target.value;
        console.log('[inputDebug] valor1:', this.valor1);
    }

    handleInput2(event) {
        this.valor2 = event.target.value;
        console.log('[inputDebug] valor2:', this.valor2);
    }
}
