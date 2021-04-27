import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class ModalCmp extends LightningElement {
    //Boolean variable to indicate if modal is open or not default value is true
    isModalOpen = true;
    @api title;

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

    submit() {
        // to close modal set isModalOpen value as false
        //Add your code to call apex method or do some processing
       // this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent("submit"));
    }
    error(){
        this.dispatchEvent(new CustomEvent("error"));
    }
}
