import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import puppyLogForm from "@salesforce/messageChannel/puppyLogForm__c";

export default class RelatedPuppyLogCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @api contactId = "";
    @api objectApiName;
    @api viewAll;
    message;
    contentType = "Puppy Log";
    title = "Puppy Raiser Log";

    @api
    openModal(message) {
        this.message = "";
        this.recordId = message.recordId;
        // Set defaults if this is a new record
        if (!message.recordId) {
            this.contactId = message.contactId;
            this.dogId = message.dogId;
        }
        refreshApex();
        this.template.querySelector("c-modal-cmp").openModal();
    }
    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleSubmit(event) {
        event.preventDefault();
        this.template.querySelector("c-puppy-log-form-cmp").handleSubmit(event);
    }

    onChanged(event) {
        this.dispatchEvent(new CustomEvent("changed"));
        this.closeModal();
    }
}
