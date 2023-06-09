import { LightningElement, api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import CEU_OBJECT from "@salesforce/schema/ContinuingEducationUnit__c";

// This component is used as a stand-alone modal on a page when creating a 
// new CEU from the overall CEU list
export default class EditCeuCmp extends NavigationMixin(LightningElement) {
    @api recordId; // recordId if editing
    @api objectApiName;

    // Standard lifecycle hooks used run when loaded
    renderedCallback() {
        this.template.querySelector("c-ceu-form-cmp").openModal({ recordId: this.recordId });
    }

    handleChanged(event) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                objectApiName: this.objectApiName,
                actionName: "view",
                recordId: event.detail.id
            }
        });
    }

    handleCancel() {
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: CEU_OBJECT.objectApiName,
                actionName: "home"
            }
        });
    }
}