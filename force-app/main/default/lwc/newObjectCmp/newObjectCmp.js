import { LightningElement, api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

export default class NewObjectCmp extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;

    // Standard lifecycle hooks runs when loaded
    renderedCallback() {
        this.template.querySelector("c-modal-cmp").openModal();
    }

    handleSuccess(event) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: event.detail.id,
                objectApiName: this.objectApiName,
                actionName: "view"
            }
        });
    }

    handleCancel() {
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: this.objectApiName,
                actionName: "home"
            }
        });
    }
}