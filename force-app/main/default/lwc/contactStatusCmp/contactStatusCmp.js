import { LightningElement, api, track, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import getProgramAssignments from "@salesforce/apex/ProgramAssignmentController.getProgramAssignments";

import BOARD_MEMBER_STATUS_FIELD from "@salesforce/schema/Contact.BoardMemberStatus__c";
import CLIENT_CERT_AGREEMENT_RECEIVED from "@salesforce/schema/Contact.ClientCertAgreementReceived__c";
import CLIENT_STATUS_FIELD from "@salesforce/schema/Contact.ClientStatus__c";
import FACILITATOR_CERT_AGREEMENT_RECEIVED from "@salesforce/schema/Contact.FacilitatorCertAgreementReceived__c";
import FACILITATOR_STATUS_FIELD from "@salesforce/schema/Contact.FacilitatorStatus__c";
import LEAD_FACILITATOR_STATUS_FIELD from "@salesforce/schema/Contact.LeadFacilitatorStatus__c";
import POSITIONS_FIELD from "@salesforce/schema/Contact.Positions__c";
import PUPPY_CERT_AGREEMENT_RECEIVED from "@salesforce/schema/Contact.PuppyCertAgreementReceived__c";
import PUPPY_STATUS_FIELD from "@salesforce/schema/Contact.PuppyRaiserStatus__c";
import TRAINER_CERT_AGREEMENT_RECEIVED from "@salesforce/schema/Contact.TrainerCertAgreementReceived__c";
import TRAINER_STATUS_FIELD from "@salesforce/schema/Contact.TrainerStatus__c";
import VOLUNTEER_STATUS_FIELD from "@salesforce/schema/Contact.GW_Volunteers__Volunteer_Status__c";
import PROGRAM_FIELD from "@salesforce/schema/ProgramAssignment__c.Program2__c";
import STANDALONE_FIELD from "@salesforce/schema/Program__c.Standalone__c";
import PROGRAM_ASSIGNMENT_STATUS_FIELD from "@salesforce/schema/ProgramAssignment__c.Status__c";

const FIELDS = [
    BOARD_MEMBER_STATUS_FIELD,
    CLIENT_CERT_AGREEMENT_RECEIVED,
    CLIENT_STATUS_FIELD,
    FACILITATOR_CERT_AGREEMENT_RECEIVED,
    FACILITATOR_STATUS_FIELD,
    LEAD_FACILITATOR_STATUS_FIELD,
    POSITIONS_FIELD,
    PUPPY_CERT_AGREEMENT_RECEIVED,
    PUPPY_STATUS_FIELD,
    TRAINER_CERT_AGREEMENT_RECEIVED,
    TRAINER_STATUS_FIELD,
    VOLUNTEER_STATUS_FIELD
];

const POSITIONS = [
    "Volunteer",
    "Team Facilitator",
    "Puppy Raiser",
    "Board",
    "Client",
    "Trainer",
    "Other Programs"
];

const STANDARD_PROGRAMS = [
    "Volunteer",
    "Team Facilitator",
    "Trainer",
    "Client",
    "Staff"
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
            const positions = this.contact.fields[POSITIONS_FIELD.fieldApiName];
            if (positions && positions.value) {
                const roleNames = positions.value.split(";");
                this.getRoleData(roleNames);
                this.error = undefined;
            }
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
                const progRef = PROGRAM_FIELD.fieldApiName.replace(
                    "__c",
                    "__r"
                );
                if (pa[progRef] && pa[progRef][STANDALONE_FIELD.fieldApiName]) {
                    // we want to prioritize 'In Progress' as a status
                    if (
                        pa[PROGRAM_ASSIGNMENT_STATUS_FIELD.fieldApiName] ===
                        "In Progress"
                    ) {
                        this.otherPrograms.status =
                            pa[PROGRAM_ASSIGNMENT_STATUS_FIELD.fieldApiName];
                        break; // we don't care about any other programs
                    } else {
                        this.otherPrograms.status = "Decertifed/Suspended";
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
                            status: this.contact.fields[
                                VOLUNTEER_STATUS_FIELD.fieldApiName
                            ].value
                        });
                    break;

                case "Team Facilitator":
                    if (
                        roleNames.includes(role) ||
                        roleNames.includes("Team Facilitator Lead")
                    ) {
                        const status = this.fineTuneStatus(
                            this.contact.fields[
                                FACILITATOR_STATUS_FIELD.fieldApiName
                            ].value,
                            this.contact.fields[
                                FACILITATOR_CERT_AGREEMENT_RECEIVED.fieldApiName
                            ].value
                        );
                        this.roles.push({
                            position: role,
                            status: status
                        });
                    }
                    break;

                case "Puppy Raiser":
                    if (roleNames.includes(role)) {
                        const status = this.fineTuneStatus(
                            this.contact.fields[PUPPY_STATUS_FIELD.fieldApiName]
                                .value,
                            this.contact.fields[
                                PUPPY_CERT_AGREEMENT_RECEIVED.fieldApiName
                            ].value
                        );
                        this.roles.push({
                            position: role,
                            status: status
                        });
                    }
                    break;

                case "Board":
                    if (roleNames.includes("Board Member"))
                        this.roles.push({
                            position: role,
                            status: this.contact.fields[
                                BOARD_MEMBER_STATUS_FIELD.fieldApiName
                            ].value
                        });
                    break;

                case "Client":
                    if (roleNames.includes(role)) {
                        const status = this.fineTuneStatus(
                            this.contact.fields[
                                CLIENT_STATUS_FIELD.fieldApiName
                            ].value,
                            this.contact.fields[
                                CLIENT_CERT_AGREEMENT_RECEIVED.fieldApiName
                            ].value
                        );
                        this.roles.push({
                            position: role,
                            status: status
                        });
                    }
                    break;

                case "Trainer":
                    if (roleNames.includes(role)) {
                        const status = this.fineTuneStatus(
                            this.contact.fields[
                                TRAINER_STATUS_FIELD.fieldApiName
                            ].value,
                            this.contact.fields[
                                TRAINER_CERT_AGREEMENT_RECEIVED.fieldApiName
                            ].value
                        );
                        this.roles.push({
                            position: role,
                            status: status
                        });
                    }
                    break;
            }
        });
    }

    addDays(date, days) {
        var newDate = new Date(date);
        newDate.setDate(newDate.getDate() + days);
        return newDate;
    }

    fineTuneStatus(status, certDate) {
        const today = new Date();
        if (
            status === "Active" ||
            (status === "Certified" && certDate != null)
        ) {
            if (this.addDays(certDate, 365) < today) {
                status = "Action Needed";
            } else if (this.addDays(certDate, 270) < today) {
                status = "Action Needed Soon";
            }
        }
        return status;
    }
}
