import getContactList from '@salesforce/apex/test3.getContactList';
import { LightningElement, api, wire } from 'lwc';

export default class Test3 extends LightningElement {
    result;
    error;

    @wire(getContactList, {})
    wiredData ({error, data}) {
        if (error) {
            this.error = error;
            this.result = undefined;
            console.log(error);
        } else if (data) {
            this.result = data;
            this.error = undefined;
            console.log(data);
        }
    }
}