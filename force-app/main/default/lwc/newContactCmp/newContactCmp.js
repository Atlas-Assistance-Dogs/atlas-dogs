import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

import NAME_FIELD from "@salesforce/schema/Contact.Name";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import PHONE_FIELD from "@salesforce/schema/Contact.Phone";
import PRONOUN_FIELD from "@salesforce/schema/Contact.Pronoun__c";
import PRONOUN_OTHER_FIELD from "@salesforce/schema/Contact.PronounOther__c";
import STREET_FIELD from "@salesforce/schema/Contact.MailingStreet";
import CITY_FIELD from "@salesforce/schema/Contact.MailingCity";
import STATE_FIELD from "@salesforce/schema/Contact.MailingState";
import COUNTRY_FIELD from "@salesforce/schema/Contact.MailingCountry";
import POSTAL_CODE_FIELD from "@salesforce/schema/Contact.MailingPostalCode";
import INTEREST_FIELD from "@salesforce/schema/Contact.LeadInterest__c";
import LEAD_SOURCE_FIELD from "@salesforce/schema/Contact.LeadSource";
import OTHER_SOURCE_FIELD from "@salesforce/schema/Contact.LeadSourceOther__c";
import LANGUAGE_FIELD from "@salesforce/schema/Contact.Language__c";
import OTHER_LANGUAGES_FIELD from "@salesforce/schema/Contact.OtherLanguages__c";
import BIRTHDATE_FIELD from "@salesforce/schema/Contact.Birthdate";
import DESCRIPTION_FIELD from "@salesforce/schema/Contact.Description";

export default class NewContact extends NavigationMixin(LightningElement) {
    showSourceOther = false;

    object = NAME_FIELD.objectApiName;
    field = {
        name: NAME_FIELD,
        email: EMAIL_FIELD,
        phone: PHONE_FIELD,
        pronoun: PRONOUN_FIELD,
        pronounOther: PRONOUN_OTHER_FIELD,
        street: STREET_FIELD,
        city: CITY_FIELD,
        state: STATE_FIELD,
        country: COUNTRY_FIELD,
        postalCode: POSTAL_CODE_FIELD,
        interest: INTEREST_FIELD,
        leadSource: LEAD_SOURCE_FIELD,
        otherSource: OTHER_SOURCE_FIELD,
        language: LANGUAGE_FIELD,
        otherLanguages: OTHER_LANGUAGES_FIELD,
        birthDate: BIRTHDATE_FIELD,
        description: DESCRIPTION_FIELD
    };

    // Standard lifecycle hooks used run when loaded
    renderedCallback() {
        this.template.querySelector("c-modal-cmp").openModal();
    }

    handleSourceChange(event) {
        this.showSourceOther = event.detail.value === "Other";
    }

    validateFields() {
        return [
            ...this.template.querySelectorAll("lightning-input-field")
        ].reduce((validSoFar, field) => {
            return validSoFar && field.reportValidity();
        }, true);
    }

    handleSubmit(event) {
        event.preventDefault();

        if (!this.validateFields()) {
            const toast = new ShowToastEvent({
                message: "All fields marked with an asterix are required.",
                variant: "error"
            });
            this.dispatchEvent(toast);
        } else {
            this.template.querySelector("lightning-record-edit-form").submit();
        }
    }

    handleSuccess(event) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: event.detail.id,
                objectApiName: this.object,
                actionName: "view"
            }
        });
    }

    handleError(event) {
        console.log("handleError event");
        console.log(JSON.stringify(event.detail));
        const evt = new ShowToastEvent({
            title: "Error in Record Creation",
            message: event.detail.detail,
            variant: "error"
        });
        this.dispatchEvent(evt);
    }

    handleCancel() {
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: this.object,
                actionName: "home"
            }
        });
    }
}