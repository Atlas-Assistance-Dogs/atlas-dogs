import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class EditBackgroundCheckCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId; // recordId if editing

    // Standard lifecycle hooks used run when loaded
    renderedCallback() {
        this.template.querySelector("c-modal-cmp").openModal();
    }

    get title() {
        if (this.recordId) {
            return "Edit Background Check";
        }
        return "New Background Check";
    }

    handleSubmit(event) {
        event.preventDefault();
        this.template
            .querySelector("c-background-check-form-cmp")
            .handleSubmit(event);
    }

    handleCancel() {
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: "BackgroundCheck__c",
                actionName: "home"
            }
        });
    }

    onChanged(event) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                objectApiName: "BackgroundCheck__c",
                actionName: "view",
                recordId: event.detail
            }
        });
    }
}
