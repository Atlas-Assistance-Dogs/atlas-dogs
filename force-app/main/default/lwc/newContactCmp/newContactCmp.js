import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

export default class NewContact extends NavigationMixin(LightningElement) {
    showSourceOther = false;
    showPnounOther = false;

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
                objectApiName: "Contact",
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
                objectApiName: "Contact",
                actionName: "home"
            }
        });
    }
}