import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import LOG_OBJECT from "@salesforce/schema/Log__c";

import ATLAS_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromAtlas__c";
import TEAM_FIELD from "@salesforce/schema/Log__c.Team__c";
import CLIENT_HOURS_FIELD from "@salesforce/schema/Log__c.ClientHours__c";
import CLIENT_STRESS_FIELD from "@salesforce/schema/Log__c.ClientStress__c";
import DATE_FIELD from "@salesforce/schema/Log__c.Date__c";
import DETAILS_FIELD from "@salesforce/schema/Log__c.Details__c";
import FIRST_AID_FIELD from "@salesforce/schema/Log__c.FirstAidSuppliesUsed__c";
import FIRST_AID_DETAILS_FIELD from "@salesforce/schema/Log__c.FirstAidDetails__c";
import DID_MEET_FIELD from "@salesforce/schema/Log__c.DidMeetThisWeek__c";
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

export default class LogFormCmp extends LightningElement {
    @api recordId;

    get title() {
        const mode = this.recordId ? "Edit" : "Create";
        return `${mode} ${this.recordTypeName} Log`;
    }

    fields = {
        team: TEAM_FIELD,
        submitter: SUBMITTER_FIELD,
        facilitator: TEAM_FACILITATOR_FIELD,
        recordType: RECORD_TYPE_FIELD,
        date: DATE_FIELD,
        didMeet: DID_MEET_FIELD,
        clientHours: CLIENT_HOURS_FIELD,
        publicAccessHours: PAH_FIELD,
        lesson: SESSION_TYPE_FIELD,
        otherHours: OTHER_HOURS_FIELD,
        details: DETAILS_FIELD,
        firstAid: FIRST_AID_FIELD,
        firstAidDetails: FIRST_AID_DETAILS_FIELD,
        teamSupport: TEAM_SUPPORT_FIELD,
        supportDetails: SUPPORT_DETAILS_FIELD,
        stress: STRESS_FIELD,
        clientStress: CLIENT_STRESS_FIELD,
        satisfaction: SATISFACTION_FIELD,
        atlasSupport: ATLAS_SUPPORT_FIELD
    };
    objectName = ATLAS_SUPPORT_FIELD.objectApiName;
    wantSupport = false;
    didFirstAid = false;

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
            return this.recordTypeName === "Team Facilitator";
        } catch {
            return false;
        }
    }

    @api
    openModal(message) {
        this.recordId = message.recordId;
        this.wantSupport = false;
        this.didFirstAid = false;
        if (message.recordType) {
            this.recordTypeId = this.recordTypeNames[message.recordType];
            this.recordTypeName = message.recordType;
        }
        if (message.record) {
            this.wantSupport = message.record.RequestSupportFromTeam__c;
            this.didFirstAid = message.record.FirstAidSuppliesUsed__c;
        }
        this.template.querySelector("c-modal-cmp").openModal();
    }

    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleSubmitterChange(event) {
        this.isSubmitter = event.target.checked;
    }

    handleFirstAidChange(event) {
        this.didFirstAid = event.target.value;
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
        if (!record.recordTypeId) record.RecordTypeId = this.recordTypeId;
        this.template
            .querySelector("lightning-record-edit-form")
            .submit(record);
    }

    handleSuccess() {
        this.dispatchEvent(new CustomEvent("changed"));
        this.dispatchEvent(
            new ShowToastEvent({
                title: "Success",
                message: "Created Log",
                variant: "success"
            })
        );
    this.closeModal();
    }

    handleError(event) {
        console.log(event);
        this.dispatchEvent(
            new ShowToastEvent({
                title: "Error!!",
                message: event.detail?.message ?? 'Error updating Log',
                variant: "error"
            })
        );
    }
}
