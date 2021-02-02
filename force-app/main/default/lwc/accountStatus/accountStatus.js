import { LightningElement, api, track, wire} from "lwc";
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Account.Volunteer__c',
    'Account.Client__c',
    'Account.Board_Member__c',
    'Account.Facilitator__c',
    'Account.Lead_Facilitator__c',
    'Account.Trainer__c',
    'Account.Volunteer_Status__c',
    'Account.Client_Status__c',
    'Account.Board_Member_Status__c',
    'Account.Facilitator_Status__c',
    'Account.Lead_Facilitator_Status__c',
    'Account.Trainer_Status__c',
];


export default class AccountStatus extends LightningElement {
    @api recordId;
    @track roles =[];

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    account;

    get role(){
        if(this.account.data.fields.Volunteer__c.value){
           
            this.roles.push('Volunteer');
            
        } 
        if(this.account.data.fields.Client__c.value){
          
            this.roles.push('Client');
            
        } 
        if(this.account.data.fields.Board_Member__c.value) {

            this.roles.push('Board Memeber');

        }
        if(this.account.data.fields.Facilitator__c.value) {

            this.roles.push('Facilitator');

        }
        if(this.account.data.fields.Trainer__c.value) {

            this.roles.push('Trainer');

        } 

        return this.roles;
    }

   // console.log('Res');
   // console.log(this.account.data.fields.Volunteer_Status__c);

   /* get roles() {

        if(this.account.data.fields.Volunteer__c) {

            this.roles.add('Volunteer');
           console.log(this.roles);

        }
        if(this.account.data.fields.Client__c.value) {

            this.roles.push('Client');

        }
       if(this.account.data.fields.Board_Member_Status__c.value) {

            this.roles.push('Board Memeber');

        }
        if(this.account.data.fields.Facilitator_Status__c.value) {

            this.roles.push('Facilitator');

        }
        if(this.account.data.fields.Trainer_Status__c.value) {

            this.roles.push('Trainer');

        } 
        return 'Volunteer';
        
    } */

}