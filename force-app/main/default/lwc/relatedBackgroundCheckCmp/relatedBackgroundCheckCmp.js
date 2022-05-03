import { LightningElement, api, wire, track } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import backgroundCheckForm from "@salesforce/messageChannel/backgroundCheckForm__c";

export default class RelatedBackgroundCheckCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @api contactId = "";
    message;
    contentType = "Background Check";
    title = "Background Check";

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
            .querySelector("c-background-check-form-cmp")
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
                backgroundCheckForm,
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