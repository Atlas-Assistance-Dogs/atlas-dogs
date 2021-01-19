import { LightningElement, api } from 'lwc';

export default class VolunteerInfoLWC extends LightningElement {
@api recordId;
@api objectApiName;
fields = ['Facilitator_Status__c','Facilitator_application_received__c','Facilitator_application_receipt_date__c','Facilitator_Preliminary_Interview_Date__c',
'Facilitator_Interview_Notes__c','Facitator_Agreement_Recieved_Date__c']
}