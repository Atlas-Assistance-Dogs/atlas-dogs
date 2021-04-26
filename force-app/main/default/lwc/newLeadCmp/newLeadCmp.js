import { LightningElement } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

export default class NewLeadCmp extends NavigationMixin(LightningElement) {

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
            title: "Lead created",
            message: "Lead created",
            variant: "success"
        });
        this.dispatchEvent(evt);

        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: event.detail.id,
                objectApiName: "Lead",
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
                objectApiName: "Lead",
                actionName: "home"
            }
        });
    }

}
