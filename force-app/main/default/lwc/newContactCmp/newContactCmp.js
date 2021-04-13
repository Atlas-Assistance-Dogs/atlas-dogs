import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

export default class NewContact extends NavigationMixin(LightningElement) {
    handleSubmit() {
        this.template.querySelector("lightning-record-edit-form").submit();
        const evt = new ShowToastEvent({
            title: "Record Submission",
            message: "Submitted",
            variant: "success"
        });

        this.dispatchEvent(evt);
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Contact created",
            message: "Contact created",
            variant: "success"
        });
        this.dispatchEvent(evt);

        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: event.detail.id,
                objectApiName: "Contact",
                actionName: "view"
            }
        });
    }

    handleCancel(event) {
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Contact",
                actionName: "home"
            }
        });
    }
}
