import { LightningElement, api, wire, track } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

export default class RelatedBackgroundCheckCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @api contactId = "";
    message;
    contentType = "Background Check";
    title = "Background Check";

    @api
    openModal(message) {
        this.message = "";
        this.recordId = message.recordId;
        refreshApex();
        this.template.querySelector("c-modal-cmp").openModal(message);
    }
    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleSubmit(event) {
        event.preventDefault();
        this.template
            .querySelector("c-background-check-form-cmp")
            .handleSubmit(event);
    }

    onChanged(event) {
        this.dispatchEvent(new CustomEvent("changed"));
        this.closeModal();
    }
}