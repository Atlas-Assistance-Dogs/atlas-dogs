import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class FileViewCmp extends NavigationMixin(LightningElement) {
    @api file;
    handleView(event) {
        let recordID = this.file.ContentDocumentId;
        this[NavigationMixin.Navigate]({
            type: "standard__namedPage",
            attributes: {
                pageName: "filePreview"
            },
            state: {
                selectedRecordId: recordID
            }
        });
    }
}