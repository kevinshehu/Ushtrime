import { LightningElement } from 'lwc';

export default class Test2 extends LightningElement {
    name = '';

    onChange() {
        this.name = event.target.value;
    }
}