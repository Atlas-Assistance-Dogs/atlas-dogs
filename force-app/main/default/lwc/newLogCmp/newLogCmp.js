import { LightningElement, api } from 'lwc';
import LOG_OBJECT from "@salesforce/schema/Log__c";
import NewObjectCmp from 'c/newObjectCmp';

export default class NewLogCmp extends NewObjectCmp {
    @api recordId;
    @api recordTypeId;

    objectApiName = LOG_OBJECT.objectApiName;

    // Standard lifecycle hooks that runs when loaded
    renderedCallback() {
        this.template.querySelector("c-log-form-cmp").open(this.recordTypeId);
    }
}