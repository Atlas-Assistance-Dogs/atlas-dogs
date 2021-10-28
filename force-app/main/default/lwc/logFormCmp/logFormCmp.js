import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createRelatedLog from "@salesforce/apex/ContactController.createRelatedLog";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import logForm from "@salesforce/messageChannel/LogForm__c";
/*
import NAME_FIELD from "@salesforce/schema/Contact.Name";
import TITLE_FIELD from "@salesforce/schema/Contact.Title";
import PHONE_FIELD from "@salesforce/schema/Contact.Phone";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import PICTURE_FIELD from "@salesforce/schema/Contact.Picture__c";
*/

export default class LogFormCmp extends LightningElement {
    @api contactId;
    roles = [];

    get options() {
        return [
            { label: "Submitter", value: "Submitter" },
            { label: "Client", value: "Client" },
            { label: "Team Facilitator", value: "Team Facilitator" }
        ];
    }

    @api
    openModal() {
        this.template.querySelector("c-modal-cmp").openModal();
    }

    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleChange(event) {
        this.roles = event.detail.value;
    }

    handleClose() {}

    handleSubmit(event) {
        event.preventDefault();
        let fields = [
            ...this.template.querySelectorAll("lightning-input-field")
        ];
        let record = fields.reduce(
            (a, x) => ({ ...a, [x.fieldName]: x.value }),
            {}
        );
        createRelatedLog({
            contactId: this.contactId,
            roles: this.roles.join(";"),
            log: record
        })
            .then(() => {
                this.dispatchEvent(new CustomEvent("logchanged"));
                this.closeModal();
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error!!",
                        message: error.message,
                        variant: "error"
                    })
                );
            });
    }

    @wire(MessageContext)
    messageContext;

    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                logForm,
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
        this.mode = message.mode;
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
