import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

import NAME_FIELD from "@salesforce/schema/Lead.Name";
import EMAIL_FIELD from "@salesforce/schema/Lead.Email";
import COMPANY_FIELD from "@salesforce/schema/Lead.Company";
import SOURCE_FIELD from "@salesforce/schema/Lead.LeadSource";
import STATUS_FIELD from "@salesforce/schema/Lead.Status";
import SOURCE_OTHER_FIELD from "@salesforce/schema/Lead.LeadSourceOther__c";
import PHONE_FIELD from "@salesforce/schema/Lead.Phone";
import PRONOUN_FIELD from "@salesforce/schema/Lead.Pronoun__c";
import PRONOUN_OTHER_FIELD from "@salesforce/schema/Lead.PronounOther__c";
import INTEREST_FIELD from "@salesforce/schema/Lead.LeadInterest__c";
import STREET_FIELD from "@salesforce/schema/Lead.Street";
import CITY_FIELD from "@salesforce/schema/Lead.City";
import STATE_FIELD from "@salesforce/schema/Lead.State";
import COUNTRY_FIELD from "@salesforce/schema/Lead.Country";
import POSTAL_CODE_FIELD from "@salesforce/schema/Lead.PostalCode";
import DESCRIPTION_FIELD from "@salesforce/schema/Lead.Description";

export default class NewLeadCmp extends NavigationMixin(LightningElement) {
    showSourceOther = false;
    showPnounOther = false;

    object = NAME_FIELD.objectApiName;
    fields = {
        name: NAME_FIELD,
        email: EMAIL_FIELD,
        company: COMPANY_FIELD,
        source: SOURCE_FIELD,
        status: STATUS_FIELD,
        sourceOther: SOURCE_OTHER_FIELD,
        phone: PHONE_FIELD,
        pronoun: PRONOUN_FIELD,
        pronounOther: PRONOUN_OTHER_FIELD,
        interest: INTEREST_FIELD,
        street: STREET_FIELD,
        city: CITY_FIELD,
        state: STATE_FIELD,
        country: COUNTRY_FIELD,
        postalCode: POSTAL_CODE_FIELD,
        description: DESCRIPTION_FIELD
    };

    // Standard lifecycle hooks used run when loaded
    renderedCallback() {
        this.template.querySelector("c-modal-cmp").openModal();
    }

    handlePnounChange(event) {
        if (event.detail.value === "specify") {
            this.showPnounOther = true;
        } else {
            this.showPnounOther = false;
        }
    }

    handleSourceChange(event) {
        if (event.detail.value === "Other") {
            this.showSourceOther = true;
        } else {
            this.showSourceOther = false;
        }
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
