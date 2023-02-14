import { LightningElement, api, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import STATUS_FIELD from "@salesforce/schema/Dog__c.ExpiryDateStatus__c";
import DOG_FIELD from "@salesforce/schema/Team__c.Dog__c";

export default class DogHealthStatus extends LightningElement {
    @api recordId;
    dogObject = STATUS_FIELD.objectApiName;
    team;

    field = {
        status: STATUS_FIELD.fieldApiName
    };

    @wire(getRecord, { recordId: "$recordId", fields: [DOG_FIELD] })
    getTeam(result) {
        if (result?.data) {
            this.team = result.data;
        }
    }

    get dogId() {
        return this.team?.fields[DOG_FIELD.fieldApiName].value;
    }
}