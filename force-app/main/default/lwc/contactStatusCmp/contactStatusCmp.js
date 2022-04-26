import { LightningElement, api, track, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";

const FIELDS = [
    "contact.Positions__c",
    "contact.GW_Volunteers__Volunteer_Status__c",
    "contact.ClientStatus__c",
    "contact.BoardMemberStatus__c",
    "contact.FacilitatorStatus__c",
    "contact.LeadFacilitatorStatus__c",
    "contact.TrainerStatus__c"
];

export default class ContactStatus extends LightningElement {
    @api recordId;
    @track roles = [];

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    contact;

    get role() {
        this.roles = this.contact.data.fields.Positions__c.value.split(";");

        return this.roles;
    }
}
