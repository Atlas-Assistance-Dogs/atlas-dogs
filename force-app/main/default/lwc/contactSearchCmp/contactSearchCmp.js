import { LightningElement, track } from "lwc";
import getContactsByName from "@salesforce/apex/ContactController.getContactsByName";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class SearchContacts extends LightningElement {
    @track error;
    @track contacts = [];
    @track noRecordsFound = true;

    findAccount(event) {
        const name = event.target.value;

        if (name) {
            getContactsByName({ name }).then((result) => {
                this.contacts = result;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Selected Contacts",
                        message:
                            "Record ID of the selected customer" +
                            this.contacts.length +
                            name,
                        variant: "success"
                    })
                );

                this.noRecordsFound = false;
            });
        } else {
            this.contacts = undefined;
            this.noRecordsFound = true;
        }
    }
}