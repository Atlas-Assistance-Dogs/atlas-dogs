import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

import NAME_FIELD from "@salesforce/schema/Dog__c.Name";
import BREED_FIELD from "@salesforce/schema/Dog__c.Breed__c";
import GENDER_FIELD from "@salesforce/schema/Dog__c.Gender__c";
import SPAYED_NEUTERED_FIELD from "@salesforce/schema/Dog__c.SpayedNeutered__c";
import BIRTHDATE_FIELD from "@salesforce/schema/Dog__c.Birthdate__c";
import STATUS_FIELD from "@salesforce/schema/Dog__c.Status__c";
import MICROCHIP_FIELD from "@salesforce/schema/Dog__c.MicrochipNumber__c";
import HEALTH_FIELD from "@salesforce/schema/Dog__c.LatestPhysicalExamOutcome__c";
import EXAM_DUE_FIELD from "@salesforce/schema/Dog__c.PhysicalExamDue__c";
import HEPATITIS_DUE_FIELD from "@salesforce/schema/Dog__c.VaccineDueHepatitis__c";
import DISTEMPER_DUE_FIELD from "@salesforce/schema/Dog__c.VaccineDueDistemper__c";
import PARAINFLUENZA_DUE_FIELD from "@salesforce/schema/Dog__c.VaccineDueParainfluenza__c";
import PARVOVIRUS_DUE_FIELD from "@salesforce/schema/Dog__c.VaccineDueParvovirus__c";
import RABIES_DUE_FIELD from "@salesforce/schema/Dog__c.VaccineDueRabies__c";

export default class NewDogCmp extends NavigationMixin(LightningElement) {
    showSourceOther = false;
    showPnounOther = false;

    object = NAME_FIELD.objectApiName;
    fields = {
        name: NAME_FIELD,
        breed: BREED_FIELD,
        gender: GENDER_FIELD,
        spayed: SPAYED_NEUTERED_FIELD,
        birthdate: BIRTHDATE_FIELD,
        status: STATUS_FIELD,
        microchip: MICROCHIP_FIELD,
        health: HEALTH_FIELD,
        examDue: EXAM_DUE_FIELD,
        hepDue: HEPATITIS_DUE_FIELD,
        distemperDue: DISTEMPER_DUE_FIELD,
        parainfluenzaDue: PARAINFLUENZA_DUE_FIELD,
        parvovirusDue: PARVOVIRUS_DUE_FIELD,
        rabiesDue: RABIES_DUE_FIELD
    };

    // Standard lifecycle hooks used run when loaded
    renderedCallback() {
        this.template.querySelector("c-modal-cmp").openModal();
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
