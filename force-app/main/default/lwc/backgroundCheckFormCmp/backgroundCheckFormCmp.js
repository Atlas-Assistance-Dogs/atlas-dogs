import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import relateFile from "@salesforce/apex/FileController.relateFile";
import { NavigationMixin } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

import CONTACT_FIELD from "@salesforce/schema/BackgroundCheck__c.Contact__c";
import DATE_FIELD from "@salesforce/schema/BackgroundCheck__c.Date__c";
import NOTES_FIELD from "@salesforce/schema/BackgroundCheck__c.Notes__c";
import RESULT_FIELD from "@salesforce/schema/BackgroundCheck__c.Status__c";

export default class BackgroundCheckFormCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @api contactId;
    currentCv;
    wiredCv;
    message;

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
            ".csv",
            ".mov",
            ".mp4",
            ".zip"
        ];
    }

    get hasFile() {
        return this.currentCv;
    }

    @wire(getRelatedFiles, { recordId: "$recordId", max: 100 })
    getFiles(result) {
        this.wiredCv = result;
        this.currentCv = null;
        if (result.data?.items) {
            this.currentCv = result.data.items[0];
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
        this.currentCv = {
            Title: this.getFileNameWithoutExtension(this.uploadedFile.name),
            ContentDocumentId: this.uploadedFile.documentId
        };
        refreshApex();
    }

    getFileNameWithoutExtension(name) {
        let parts = name.split(".");
        if (parts.length > 1) {
            return parts.slice(0, -1).join(".");
        }
        return name;
    }

    @api
    handleSubmit(event) {
        event.preventDefault();
        let fields = [
            ...this.template.querySelectorAll("lightning-input-field")
        ];
        var record = fields.reduce(
            (a, x) => ({ ...a, [x.fieldName]: x.value }),
            {}
        );
        if (this.contactId) {
            record[CONTACT_FIELD.fieldApiName] = this.contactId;
        }
        var documentId = null;
        if (this.uploadedFile) {
            documentId = this.uploadedFile.documentId;
        }
        if (!documentId && !this.currentCv) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error!!",
                    message:
                        "A document must be assigned to the background check.",
                    variant: "error"
                })
            );
            return;
        }
        this.template
            .querySelector("lightning-record-edit-form")
            .submit(record);
    }

    handleSuccess(event) {
        if (!this.recordId) { // new background check
            relateFile({documentId: this.currentCv.ContentDocumentId, recordId: event.detail.id})
                .then((id) => {
                    this.dispatchEvent(new CustomEvent("changed", { detail: id }));
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
        else {
            this.dispatchEvent(
                new CustomEvent("changed", { detail: id })
            );
        }
    }
}
