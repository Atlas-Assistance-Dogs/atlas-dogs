import { LightningElement, api, track, wire } from "lwc";
import getPositionStatusForContact from "@salesforce/apex/PositionStatusController.getPositionStatusForContact";

export default class ContactStatus extends LightningElement {
  @api recordId;
  @track roles = [];

  @wire(getPositionStatusForContact, { contactId: "$recordId" })
  getStatuses({ error, data }) {
    if (data) {
      if (!!data) this.roles = data;
    } else if (error) {
      console.log(error);
      this.otherPrograms = null;
    }
  }
}
