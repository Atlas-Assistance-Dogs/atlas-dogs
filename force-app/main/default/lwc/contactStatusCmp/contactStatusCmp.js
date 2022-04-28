import { LightningElement, api, track, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import getProgramAssignments from "@salesforce/apex/ContactController.getProgramAssignments";

import BOARD_MEMBER_STATUS_FIELD from "@salesforce/schema/Contact.BoardMemberStatus__c";
import CLIENT_STATUS_FIELD from "@salesforce/schema/Contact.ClientStatus__c";
import FACILITATOR_STATUS_FIELD from "@salesforce/schema/Contact.FacilitatorStatus__c";
import LEAD_FACILITATOR_STATUS_FIELD from "@salesforce/schema/Contact.LeadFacilitatorStatus__c";
import POSITIONS_FIELD from "@salesforce/schema/Contact.Positions__c";
import TRAINER_STATUS_FIELD from "@salesforce/schema/Contact.TrainerStatus__c";
import VOLUNTEER_STATUS_FIELD from "@salesforce/schema/Contact.GW_Volunteers__Volunteer_Status__c";

const FIELDS = [
    BOARD_MEMBER_STATUS_FIELD,
    CLIENT_STATUS_FIELD,
    FACILITATOR_STATUS_FIELD,
    LEAD_FACILITATOR_STATUS_FIELD,
    POSITIONS_FIELD,
    TRAINER_STATUS_FIELD,
    VOLUNTEER_STATUS_FIELD
];

const POSITIONS = [
    "Volunteer",
    "Team Facilitator",
    "Board",
    "Client",
    "Trainer",
    "Other Programs"
];

const OTHER_PROGRAMS = [
    "Teams Set in Motion Client",
    "Assistance Dogs Set in Motion Client"
];

export default class ContactStatus extends LightningElement {
    @api recordId;
    @track roles = [];
    @track otherPrograms;
    contact;

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    getContact({ error, data }) {
        if (data) {
            this.contact = data;
            const positions = this.contact.fields.Positions__c;
            if (!positions) return;
            const roleNames = positions.value.split(";");
            this.getRoleData(roleNames);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contact = undefined;
        }
    }

    @wire(getProgramAssignments, { contactId: "$recordId" })
    getPrograms({ error, data }) {
        if (data) {
            if (data === null) return;
            this.otherPrograms = {
                position: "Other",
                status: null
            };
            for (var idx = 0; idx < data.length; idx++) {
                var pa = data[idx];
                if (OTHER_PROGRAMS.find((x) => x === pa.Program__c)) {
                    // we want to prioritize 'In Progress' as a status
                    if (this.otherPrograms.status !== "In Progress") {
                        this.otherPrograms.status = pa.Status__c;
                    }
                }
            }
            if (this.otherPrograms.status == null) {
                this.otherPrograms = null;
            }
        } else if (error) {
            console.log(error);
            this.otherPrograms = null;
        }
    }

    getRoleData(roleNames) {
        this.roles = [];
        POSITIONS.forEach((role) => {
            switch (role) {
                case "Volunteer":
                    if (roleNames.includes(role))
                        this.roles.push({
                            position: role,
                            status: this.contact.fields
                                .GW_Volunteers__Volunteer_Status__c.value
                        });
                    break;

                case "Team Facilitator":
                    if (
                        roleNames.includes(role) ||
                        roleNames.includes("Team Facilitator Lead")
                    )
                        this.roles.push({
                            position: role,
                            status: this.contact.fields.FacilitatorStatus__c
                                .value
                        });
                    break;

                case "Board":
                    if (roleNames.includes("Board Member"))
                        this.roles.push({
                            position: role,
                            status: this.contact.fields.BoardMemberStatus__c
                                .value
                        });
                    break;

                case "Client":
                    if (roleNames.includes(role))
                        this.roles.push({
                            position: role,
                            status: this.contact.fields.ClientStatus__c.value
                        });
                    break;

                case "Trainer":
                    if (roleNames.includes(role))
                        this.roles.push({
                            position: role,
                            status: this.contact.fields.FacilitatorStatus__c
                                .value
                        });
                    break;
            }
        });
    }
}
