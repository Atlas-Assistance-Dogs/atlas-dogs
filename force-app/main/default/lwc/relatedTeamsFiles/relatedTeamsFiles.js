import { LightningElement, api, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import DOG_FIELD from "@salesforce/schema/Team__c.Dog__c";
import CLIENT_FIELD from "@salesforce/schema/Team__c.Client__c";
import CLIENT_OBJECT from "@salesforce/schema/Contact";
import DOG_OBJECT from "@salesforce/schema/Dog__c";

const FIELDS = [CLIENT_FIELD, DOG_FIELD];

export default class RelatedTeamsFiles extends LightningElement {
    @api recordId;
    @api objectApiName;
    
    clientObject = CLIENT_OBJECT.objectApiName;
    dogObject = DOG_OBJECT.objectApiName;
    team;

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    getTeam(result) {
        if (result?.data) {
            this.team = result.data;
        }
    }

    get clientId() {
        return this.team?.fields[CLIENT_FIELD.fieldApiName].value;
    }
    get dogId() {
        return this.team?.fields[DOG_FIELD.fieldApiName].value;
    }
}