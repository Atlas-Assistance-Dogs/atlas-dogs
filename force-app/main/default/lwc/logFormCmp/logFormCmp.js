import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import LOG_OBJECT from "@salesforce/schema/Log__c";

import ATLAS_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromAtlas__c";
import CLIENT_FIELD from "@salesforce/schema/Log__c.Client__c";
import CLIENT_HOURS_FIELD from "@salesforce/schema/Log__c.ClientHours__c";
import CLIENT_STRESS_FIELD from "@salesforce/schema/Log__c.ClientStress__c";
import DATE_FIELD from "@salesforce/schema/Log__c.Date__c";
import DETAILS_FIELD from "@salesforce/schema/Log__c.Details__c";
import DOG_FIELD from "@salesforce/schema/Log__c.Dog__c";
import HANDLER_FIELD from "@salesforce/schema/Log__c.Handler__c";
import OTHER_HOURS_FIELD from "@salesforce/schema/Log__c.OtherHours__c";
import PAH_FIELD from "@salesforce/schema/Log__c.PublicAccessHours__c";
import RECORD_TYPE_FIELD from "@salesforce/schema/Log__c.RecordTypeId";
import SATISFACTION_FIELD from "@salesforce/schema/Log__c.Satisfaction__c";
import STRESS_FIELD from "@salesforce/schema/Log__c.Stress__c";
import SUBMITTER_FIELD from "@salesforce/schema/Log__c.Submitter__c";
import SUPPORT_DETAILS_FIELD from "@salesforce/schema/Log__c.SupportDetails__c";
import TEAM_FACILITATOR_FIELD from "@salesforce/schema/Log__c.Facilitator__c";
import TEAM_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromTeam__c";
import SESSION_TYPE_FIELD from "@salesforce/schema/Log__c.SessionType__c";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import logForm from "@salesforce/messageChannel/logForm__c";

export default class LogFormCmp extends LightningElement {
    @api recordId;

    get title() {
        const mode = this.recordId ? "Edit" : "Create";
        return `${mode} ${this.recordTypeName} Log`;
    }

    fields = {
        client: CLIENT_FIELD,
        submitter: SUBMITTER_FIELD,
        facilitator: TEAM_FACILITATOR_FIELD,
        recordType: RECORD_TYPE_FIELD,
        date: DATE_FIELD,
        dog: DOG_FIELD,
        clientHours: CLIENT_HOURS_FIELD,
        publicAccessHours: PAH_FIELD,
        handler: HANDLER_FIELD,
        lesson: SESSION_TYPE_FIELD,
        otherHours: OTHER_HOURS_FIELD,
        details: DETAILS_FIELD,
        teamSupport: TEAM_SUPPORT_FIELD,
        supportDetails: SUPPORT_DETAILS_FIELD,
        stress: STRESS_FIELD,
        clientStress: CLIENT_STRESS_FIELD,
        satisfaction: SATISFACTION_FIELD,
        atlasSupport: ATLAS_SUPPORT_FIELD
    };
    objectName = ATLAS_SUPPORT_FIELD.objectApiName;
    wantSupport = false;

    @wire(getObjectInfo, { objectApiName: LOG_OBJECT })
    objectInfo({ error, data }) {
        if (data) {
            const rtis = data.recordTypeInfos;
            this.recordTypes = rtis;
            // Returns a map of record type names to their ids
            this.recordTypeNames = {};
            Object.keys(rtis).forEach((id) => {
                this.recordTypeNames[rtis[id].name] = id;
            });
        }
    }

    recordTypes;
    recordTypeNames;
    recordTypeName;

    recordTypeId;

    get isClient() {
        try {
            this.recordTypeName === "Client";
        } catch {
            return false;
        }
    }

    get isFacilitator() {
        try {
            return (
                this.recordTypeName === "Team Facilitator"
            );
        } catch {
            return false;
        }
    }

    @api
    openModal() {
        this.template.querySelector("c-modal-cmp").openModal();
    }

    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleSubmitterChange(event) {
        this.isSubmitter = event.target.checked;
    }

    handleTeamSupportChange(event) {
        this.wantSupport = event.target.value;
    }

    handleClose() {
        this.closeModal();
    }

    handleSubmit(event) {
        event.preventDefault();
        let fields = [
            ...this.template.querySelectorAll("lightning-input-field")
        ];
        var record = fields.reduce(
            (a, x) => ({ ...a, [x.fieldName]: x.value }),
            {}
        );
        if (!this.recordTypeId) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error!!",
                    message: "A record type is required",
                    variant: "error"
                })
            );
            return;
        }
        record.RecordTypeId = this.recordTypeId;
        this.template.querySelector("lightning-record-edit-form").submit(record);
    }

    handleSuccess() {
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
        if (message.recordType) {
            this.recordTypeId = this.recordTypeNames[message.recordType];
            this.recordTypeName = message.recordType;
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
