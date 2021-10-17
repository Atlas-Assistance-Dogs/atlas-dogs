import { LightningElement, api } from "lwc";
import createRelatedLog from "@salesforce/apex/ContactController.createRelatedLog";
import { NavigationMixin } from "lightning/navigation";

export default class LogCreateCmp extends NavigationMixin(LightningElement) {
    @api recordId;
    roles = [];

    get options() {
        return [
            { label: "Submitter", value: "Submitter" },
            { label: "Client", value: "Client" },
            { label: "Team Facilitator", value: "Team Facilitator" }
        ];
    }

    @api
    openModal() {
        this.message = "";
        this.template.querySelector("c-modal-cmp").openModal();
    }

    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleChange(event) {
        this.roles = event.detail.value;
    }

    @api
    handleSubmit(event) {
        event.preventDefault();
        let fields = [
            ...this.template.querySelectorAll("lightning-input-field")
        ];
        let record = fields.reduce(
            (a, x) => ({ ...a, [x.fieldName]: x.value }),
            {}
        );
        let self = this;
        createRelatedLog({
            contactId: this.recordId,
            roles: this.roles.join(";"),
            log: record
        })
            .then(() => {
                self.dispatchEvent(new CustomEvent("create"));
                self.closeModal();
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error!!",
                        message: error.message,
                        variant: "error"
                    })
                );
            });
    }

    handleClose() {}
}
