import { LightningElement, api, track, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";

const FIELDS = [
    "Contact.Positions__c",
    "Contact.Volunteer_Status__c",
    "Contact.Client_Status__c",
    "Contact.Board_Member_Status__c",
    "Contact.Facilitator_Status__c",
    "Contact.Lead_Facilitator_Status__c",
    "Contact.Trainer_Status__c"
];

export default class ContactStatus extends LightningElement {
    @api recordId;
    @track roles = [];

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    Contact;

    get role() {
        if (this.Contact.data.fields.Positions__c.value) {
            this.roles.push("Volunteer");
        }
        if (this.Contact.data.fields.Client__c.value) {
            this.roles.push("Client");
        }
        if (this.Contact.data.fields.Board_Member__c.value) {
            this.roles.push("Board Memeber");
        }
        if (this.Contact.data.fields.Facilitator__c.value) {
            this.roles.push("Facilitator");
        }
        if (this.Contact.data.fields.Trainer__c.value) {
            this.roles.push("Trainer");
        }

        return this.roles;
    }
}
