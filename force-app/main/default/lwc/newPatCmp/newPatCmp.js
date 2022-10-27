import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class NewPatCmp extends NavigationMixin(LightningElement) {
    @api objectApiName;
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
        this.closeModal();
        console.log('Navigating to ' + event.detail.id);
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: event.detail.id,
                actionName: "view"
            }
        });
    }

    handleClose() {
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: this.objectApiName,
                actionName: "home"
            }
        });
    }
}
