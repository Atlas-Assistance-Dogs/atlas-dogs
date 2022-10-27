import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class NewPuppyLogCmp extends NavigationMixin(LightningElement) {
    @api objectApiName;
    @api recordId;
    @api contactId = "";
    message;
    title = "Puppy Raiser Log";

    @api
    openModal() {
        this.message = "";
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

    handleSourceChange(event) {
        this.showSourceOther = event.detail.value === "Other";
    }

    handleChanged(event) {
        this.dispatchEvent(new CustomEvent("changed"));
        this.closeModal();
        if (this.parentAttributes) {
            this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: this.parentAttributes
            });
        }
        else {
            this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: {
                    recordId: event.detail.id,
                    objectApiName: this.object,
                    actionName: "view"
                }
            });
        }
    }

    onClose(event) {

    }
}