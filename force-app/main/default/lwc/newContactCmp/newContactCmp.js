import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
/*
import CONTACT_OBJECT from '@salesforce/schema/Contact';

import FNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import SOURCE_FIELD from '@salesforce/schema/Contact.LeadSource';
import CITY_FIELD from '@salesforce/schema/Contact.MailingCity';
import STATE_FIELD from '@salesforce/schema/Contact.MailingState';
import COUNTRY_FIELD from '@salesforce/schema/Contact.MailingCountry'; */

export default class NewContact extends NavigationMixin(LightningElement) {
    // contactObj = CONTACT_OBJECT;
    //myFields = [FNAME_FIELD, LNAME_FIELD, EMAIL_FIELD, PHONE_FIELD, CITY_FIELD, STATE_FIELD, COUNTRY_FIELD, SOURCE_FIELD];

    handleSubmit() {
        const evt = new ShowToastEvent({
            title: "Record Submission",
            message: "Submitted",
            variant: "success"
        });

        this.dispatchEvent(evt);
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Contact created",
            message: "Contact created",
            variant: "success"
        });
        this.dispatchEvent(evt);

        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: event.detail.id,
                objectApiName: "Contact",
                actionName: "view"
            }
        });
    }

    handleCancel(event) {
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Contact",
                actionName: "home"
            }
        });
    }
}
