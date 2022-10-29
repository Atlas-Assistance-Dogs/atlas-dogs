import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import PAT_OBJECT from "@salesforce/schema/PublicAccessTest__c";

export default class NewPatCmp extends NavigationMixin(LightningElement) {
    @api recordId;

    @api
    openModal() {
        this.template.querySelector("c-pat-form-cmp").openModal();
    }
    closeModal() {
        this.template.querySelector("c-pat-form-cmp").closeModal();
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
                objectApiName: PAT_OBJECT.objectApiName,
                actionName: "home"
            }
        });
    }
}
