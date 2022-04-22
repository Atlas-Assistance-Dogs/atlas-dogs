import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

export default class NewDogCmp extends NavigationMixin(LightningElement) {
    showSourceOther = false;
    showPnounOther = false;

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
                objectApiName: "Dog",
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
                objectApiName: "Dog__c",
                actionName: "home"
            }
        });
    }
}
