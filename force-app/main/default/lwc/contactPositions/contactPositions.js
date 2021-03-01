import { LightningElement, api } from "lwc";

export default class ContactPositions extends LightningElement {
    @api recordId = "myrecordid";

    get volunteer() {
        return true;
    }
}
