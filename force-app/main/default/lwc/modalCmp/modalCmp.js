import { LightningElement, api, track } from "lwc";

export default class ModalCmp extends LightningElement {
    //Boolean variable to indicate if modal is open or not. default value is false
    @api isModalOpen = false;
    @api title;
    @api submitlabel = "Save";
    @api defaultClosed = false;

    @api
    openModal() {
        // to open modal set isModalOpen value as true
        this.isModalOpen = true;
    }
    @api
    cancelModal() {
        // to close modal set isModalOpen value as false
        this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent("close"));
    }

    @api
    closeModal() {
        // to close modal set isModalOpen value as false
        this.isModalOpen = false;
    }

    submit(event) {
        // to close modal set isModalOpen value as false
        // Add your code to call apex method or do some processing
        this.dispatchEvent(new CustomEvent("submit", event));
    }
    error() {
        this.dispatchEvent(new CustomEvent("error"));
    }
}
