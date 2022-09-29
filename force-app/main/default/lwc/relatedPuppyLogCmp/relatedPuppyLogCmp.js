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
    message;
    contentType = "Puppy Log";
    title = "Puppy Raiser Log";

    @api
    openModal() {
        this.message = "";
        this.template.querySelector("c-modal-cmp").openModal();
    }
    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleSubmit(event) {
        event.preventDefault();
        this.template
            .querySelector("c-puppy-log-form-cmp")
            .handleSubmit(event);
    }

    onChanged(event) {
        this.dispatchEvent(new CustomEvent("changed"));
        this.closeModal();
    }

    @wire(MessageContext)
    messageContext;

    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                puppyLogForm,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }
    // Handler for message received by component
    handleMessage(message) {
        this.recordId = message.recordId;
        // Set defaults if this is a new record
        if (!message.recordId) {
            this.contactId = message.contactId;
            this.dogId = message.dogId;
        }
        refreshApex();
        this.openModal();
    }

    // Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }
}