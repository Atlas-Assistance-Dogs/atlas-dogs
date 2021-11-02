import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import { NavigationMixin } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

import CONTACT_FIELD from "@salesforce/schema/BackgroundCheck__c.Contact__c";
import DATE_FIELD from "@salesforce/schema/BackgroundCheck__c.Date__c";
import NOTES_FIELD from "@salesforce/schema/BackgroundCheck__c.Notes__c";
import RESULT_FIELD from "@salesforce/schema/BackgroundCheck__c.Result__c";

export default class BackgroundCheckFormCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @api contactId;
    currentCv;
    wiredCv;
    message;
    contentType = "Background Check";

    objectName = CONTACT_FIELD.objectApiName;

    fields = {
        contact: CONTACT_FIELD,
        date: DATE_FIELD,
        notes: NOTES_FIELD,
        result: RESULT_FIELD
    };

    get acceptedFormats() {
        return [
            ".pdf",
            ".png",
            ".jpg",
            ".jpeg",
            ".doc",
            ".docx",
            ".txt",
            ".xlsx",
            ".xls",
            ".csv"
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

    get hasFile() {
        return this.currentCv;
    }

    @wire(getRelatedFiles, { recordId: "$recordId" })
    getFiles(result) {
        this.wiredCv = result;
        if (result.data.size() > 0) {
            this.currentCv = result.data[0];
        } else if (result.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error!!",
                    message: result.error.message,
                    variant: "error"
                })
            );
        }
    }

    handleUploadFinished(event) {
        this.isErrorMessage = false;
        this.message = "File Uploaded Successfully";
        this.uploadedFile = event.detail.files[0];
        refreshApex();
    }

    handleSubmit(event) {
        event.preventDefault();
        if (!this.recordId) {
            let fields = [
                ...this.template.querySelectorAll("lightning-input-field")
            ];
            var record = fields.reduce(
                (a, x) => ({ ...a, [x.fieldName]: x.value }),
                {}
            );
            addBackgroundCheck({
                check: record,
                documentId: this.uploadedFile.documentId
            })
                .then((data) => {
                    this.dispatchEvent(new CustomEvent("changed"));
                    this.closeModal();
                })
                .catch((error) => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Error!!",
                            message: error.body.message,
                            variant: "error"
                        })
                    );
                });
        }
        this.closeModal();
    }
}
