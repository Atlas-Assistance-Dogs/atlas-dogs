import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

import NAME_FIELD from "@salesforce/schema/Team__c.Name";
import CLIENT_FIELD from "@salesforce/schema/Team__c.Client__c";
import HANDLER_FIELD from "@salesforce/schema/Team__c.Handler__c";
import DOG_FIELD from "@salesforce/schema/Team__c.Dog__c";
import CERTIFICATION_FIELD from "@salesforce/schema/Team__c.PrimaryCertification__c";
import SECONDARY_FIELD from "@salesforce/schema/Team__c.SecondaryCertification__c";
import COUNT_FIELD from "@salesforce/schema/Team__c.PatCount__c";
import VALID_UNTIL_FIELD from "@salesforce/schema/Team__c.PatValidUntil__c";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import teamForm from "@salesforce/messageChannel/teamForm__c";

export default class TeamFormCmp extends NavigationMixin(LightningElement) {
    showSourceOther = false;
    showPnounOther = false;
    recordId;

    object = NAME_FIELD.objectApiName;
    fields = {
        name: NAME_FIELD,
        client: CLIENT_FIELD,
        handler: HANDLER_FIELD,
        dog: DOG_FIELD,
        certification: CERTIFICATION_FIELD,
        secondary: SECONDARY_FIELD,
        validUntil: VALID_UNTIL_FIELD,
        patCount: COUNT_FIELD
    };

    @api
    openModal() {
        this.template.querySelector("c-modal-cmp").openModal();
    }

    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    @wire(MessageContext)
    messageContext;

    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                teamForm,
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
        this.mode = message.recordId ? "edit" : "create";
        this.openModal();
    }

    // Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }

    validateFields() {
        return [
            ...this.template.querySelectorAll("lightning-input-field")
        ].reduce((validSoFar, field) => {
            return validSoFar && field.reportValidity();
        }, true);
    }

    handleSubmit(event) {
        event.preventDefault();

        if (!this.validateFields()) {
            const toast = new ShowToastEvent({
                message: "All fields marked with an asterix are required.",
                variant: "error"
            });
            this.dispatchEvent(toast);
        } else {
            this.template.querySelector("lightning-record-edit-form").submit();
            this.dispatchEvent(new CustomEvent("changed"));
            this.closeModal();
        }
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Success",
            message: event.detail.detail,
            variant: "success"
        });
        this.dispatchEvent(evt);
        this.dispatchEvent(new CustomEvent("changed"));
        this.closeModal();
    }

    handleError(event) {
        const evt = new ShowToastEvent({
            title: "Error in Record Creation",
            message: event.detail.detail,
            variant: "error"
        });
        this.dispatchEvent(evt);
    }

    handleCancel() {
        this.closeModal();
    }
}
