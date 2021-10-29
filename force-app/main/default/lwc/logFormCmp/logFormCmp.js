import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createRelatedLog from "@salesforce/apex/LogController.createRelatedLog";
import getRelatedLog from "@salesforce/apex/LogController.getRelatedLog";
import updateRelatedLog from "@salesforce/apex/LogController.updateRelatedLog";

import ROLE_FIELD from "@salesforce/schema/ContactLog__c.Role__c";
import DATE_FIELD from "@salesforce/schema/Log__c.Date__c";
import DOG_FIELD from "@salesforce/schema/Log__c.Dog__c";
import PAH_FIELD from "@salesforce/schema/Log__c.PublicAccessHours__c";
import HANDLER_FIELD from "@salesforce/schema/Log__c.Handler__c";
import OTHER_HOURS_FIELD from "@salesforce/schema/Log__c.OtherHours__c";
import DETAILS_FIELD from "@salesforce/schema/Log__c.Details__c";
import TEAM_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromTeam__c";
import SUPPORT_DETAILS_FIELD from "@salesforce/schema/Log__c.SupportDetails__c";
import CLIENT_STRESS_FIELD from "@salesforce/schema/Log__c.ClientStress__c";
import SATISFACTION_FIELD from "@salesforce/schema/Log__c.Satisfaction__c";
import ATLAS_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromAtlas__c";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import logForm from "@salesforce/messageChannel/LogForm__c";

export default class LogFormCmp extends LightningElement {
    @api contactId;
    roles = [];
    title = "Create Log";
    fields = {
        role: ROLE_FIELD,
        date: DATE_FIELD,
        dog: DOG_FIELD,
        publicAccessHours: PAH_FIELD,
        handler: HANDLER_FIELD,
        otherHours: OTHER_HOURS_FIELD,
        details: DETAILS_FIELD,
        teamSupport: TEAM_SUPPORT_FIELD,
        supportDetails: SUPPORT_DETAILS_FIELD,
        clientStress: CLIENT_STRESS_FIELD,
        satisfaction: SATISFACTION_FIELD,
        atlasSupport: ATLAS_SUPPORT_FIELD
    };

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
        let roles = this.roles.join(";");
        if (this.mode === "create") {
            this.createLog(roles, record);
        } else {
            this.updateLog(roles, record);
        }
    }

    @wire(MessageContext)
    messageContext;

    // Create a new log
    createLog(roles, record) {
        createRelatedLog({
            contactId: this.contactId,
            roles: roles,
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
                        message: error.body.message,
                        variant: "error"
                    })
                );
            });
    }

    // Update an existing log and ContactLog
    updateLog(roles, record) {
        record["Id"] = this.logRecordId;
        updateRelatedLog({
            contactLog: { Id: this.recordId, Role__c: roles },
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
        this.title = this.mode[0].toUpperCase() + this.mode.slice(1) + " Log";
        if (message.recordId) {
            getRelatedLog({ recordId: this.recordId }).then((data) => {
                this.roles = data.Role__c.split(";");
                this.logRecordId = data.Log__c;
            });
        }
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
