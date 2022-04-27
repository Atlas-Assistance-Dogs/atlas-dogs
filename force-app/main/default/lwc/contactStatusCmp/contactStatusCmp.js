import { LightningElement, api, track, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";

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

export default class ContactStatus extends LightningElement {
    @api recordId;
    @track roles = [];
    contact;

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    getContact({ error, data }) {
        if (data) {
            this.contact = data;
            const roleNames = this.contact.fields.Positions__c.value.split(";");
            this.getRoleData(roleNames);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contact = undefined;
        }
    }

    getRoleData(roleNames) {
        this.roles = POSITIONS.map((role) => {
            switch (role) {
                case "Volunteer":
                    if (roleNames.includes(role))
                        return {
                            position: role,
                            status: this.contact.fields
                                .GW_Volunteers__Volunteer_Status__c.value
                        };
                    return null;

                case "Team Facilitator":
                    if (
                        roleNames.includes(role) ||
                        roleNames.includes("Team Facilitator Lead")
                    )
                        return {
                            position: role,
                            status: this.contact.fields.FacilitatorStatus__c
                                .value
                        };
                    return null;

                case "Board":
                    if (roleNames.includes("Board Member"))
                        return {
                            position: role,
                            status: this.contact.fields.ClientStatus__c.value
                        };
                    return null;

                case "Client":
                    if (roleNames.includes(role))
                        return {
                            position: role,
                            status: this.contact.fields.ClientStatus__c.value
                        };
                    return null;

                case "Trainer":
                    if (roleNames.includes(role))
                        return {
                            position: role,
                            status: this.contact.fields.FacilitatorStatus__c
                                .value
                        };
                    return null;

                case "Other Programs":
                    if (roleNames.includes("Client"))
                        // get the status of any other programs the client may be enrolled in
                        return {
                            position: role,
                            status: this.contact.fields.FacilitatorStatus__c
                                .value
                        };
                    return null;
            }
        }).filter((x) => x !== null);
    }
}
