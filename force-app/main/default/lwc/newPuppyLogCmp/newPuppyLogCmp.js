import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import PUPPY_LOG_OBJECT from "@salesforce/schema/PuppyLog__c";

export default class NewPuppyLogCmp extends NavigationMixin(LightningElement) {
    @api recordId;

    @api
    openModal() {
        this.template.querySelector("c-related-puppy-log-cmp").openModal();
    }
    closeModal() {
        this.template.querySelector("c-related-puppy-log-cmp").closeModal();
    }

    handleSubmit(event) {
        event.preventDefault();
        this.template
            .querySelector("c-related-puppy-log-form-cmp")
            .handleSubmit(event);
    }

    // Standard lifecycle hooks used run when loaded
    renderedCallback() {
        this.openModal();
    }

    handleChanged(event) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: event.detail,
                actionName: "view"
            }
        });
    }

    handleCancel() {
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: PUPPY_LOG_OBJECT.objectApiName,
                actionName: "home"
            }
        });
    }
}