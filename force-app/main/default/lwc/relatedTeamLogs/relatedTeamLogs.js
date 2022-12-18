import { LightningElement, api, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";

import CLIENT_FIELD from "@salesforce/schema/Team__c.Client__c";
import CLIENT_OBJECT from "@salesforce/schema/Contact";

const FIELDS = [CLIENT_FIELD];

export default class RelatedTeamLogs extends LightningElement {
    @api recordId;

    clientObject = CLIENT_OBJECT.objectApiName;
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
}