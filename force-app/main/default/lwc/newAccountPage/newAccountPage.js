import { LightningElement } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import FNAME_FIELD from '@salesforce/schema/Account.First_Name__c';
import LNAME_FIELD from '@salesforce/schema/Account.Last_Name__c';
import EMAIL_FIELD from '@salesforce/schema/Account.Email__c';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import CITY_FIELD from '@salesforce/schema/Account.BillingCity';
import STATE_FIELD from '@salesforce/schema/Account.BillingState';
import COUNTRY_FIELD from '@salesforce/schema/Account.BillingCountry';
import NAME_FIELD from '@salesforce/schema/Account.Name';



export default class NewAccountPage extends LightningElement {

    accountObject = ACCOUNT_OBJECT;
    myFields = [NAME_FIELD, FNAME_FIELD, LNAME_FIELD, EMAIL_FIELD, PHONE_FIELD, CITY_FIELD, STATE_FIELD, COUNTRY_FIELD ];

    handleAccountCreated(){
        // Run code when account is created.
    }

}