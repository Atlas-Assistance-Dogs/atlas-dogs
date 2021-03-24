import { LightningElement, api, track, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";

const FIELDS = [
    "contact.Positions__c",
    "contact.Volunteer_Status__c",
    "contact.Client_Status__c",
    "contact.Board_Member_Status__c",
    "contact.Facilitator_Status__c",
    "contact.Lead_Facilitator_Status__c",
    "contact.Trainer_Status__c"
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
