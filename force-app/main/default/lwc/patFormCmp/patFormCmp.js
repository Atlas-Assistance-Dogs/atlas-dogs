import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createPat from "@salesforce/apex/PublicAccessTestController.createPat";
import updatePat from "@salesforce/apex/PublicAccessTestController.updatePat";

import PAT_OBJECT from "@salesforce/schema/PublicAccessTest__c";

import ASSESSOR_FIELD from "@salesforce/schema/PublicAccessTest__c.Assessor__c";
import ASSESSOR_COMMENTS_FIELD from "@salesforce/schema/PublicAccessTest__c.AssessorComments__c";
import CLIENT_FIELD from "@salesforce/schema/PublicAccessTest__c.Client__c";
import DATE_FIELD from "@salesforce/schema/PublicAccessTest__c.DateCompleted__c";
import DOG_FIELD from "@salesforce/schema/PublicAccessTest__c.Dog__c";
import HANDLER_FIELD from "@salesforce/schema/PublicAccessTest__c.Handler__c";
import LOCATION_FIELD from "@salesforce/schema/PublicAccessTest__c.Location__c";
import REVIEW_COMMENTS_FIELD from "@salesforce/schema/PublicAccessTest__c.ReviewComments__c";
import STATUS_FIELD from "@salesforce/schema/PublicAccessTest__c.Status__c";
import TYPE_FIELD from "@salesforce/schema/PublicAccessTest__c.Type__c";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import patForm from "@salesforce/messageChannel/PatForm__c";

export default class PatFormCmp extends LightningElement {
    @api contactId;
    recordId;
    roles = "Client";
    title = "Public Access Test Record";
    mode = "create";
    object = ASSESSOR_FIELD.objectApiName;
    fields = {
        assessor: ASSESSOR_FIELD,
        assessorComments: ASSESSOR_COMMENTS_FIELD,
        client: CLIENT_FIELD,
        date: DATE_FIELD,
        dog: DOG_FIELD,
        handler: HANDLER_FIELD,
        location: LOCATION_FIELD,
        reviewComments: REVIEW_COMMENTS_FIELD,
        status: STATUS_FIELD,
        type: TYPE_FIELD
    };

    get options() {
        return [
            { label: "Assessor", value: "Assessor" },
            { label: "Client", value: "Client" },
            { label: "Handler", value: "Handler" }
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
        record.Id = this.recordId;
        if (this.mode === "create") {
            this.createNewPat(record);
        } else {
            this.editPat(record);
        }
    }

    @wire(MessageContext)
    messageContext;

    // Create a new log
    createNewPat(record) {
        createPat({
            record: record
        })
            .then(() => {
                this.dispatchEvent(new CustomEvent("changed"));
                this.closeModal();
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error!!",
                        message: error.body.message,
                        variant: "error"
                    })
                );
            });
    }

    // Update an existing PAT
    editPat(record) {
        //record["Id"] = this.recordId;
        updatePat({ record: record })
            .then(() => {
                this.dispatchEvent(new CustomEvent("changed"));
                this.closeModal();
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error!!",
                        message: error.body.message,
                        variant: "error"
                    })
                );
            });
    }

    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                patForm,
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
        //this.title = this.mode[0].toUpperCase() + this.mode.slice(1) + " Log";
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
}
