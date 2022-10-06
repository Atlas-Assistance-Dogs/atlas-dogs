import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import relateFile from "@salesforce/apex/FileController.relateFile";
import { NavigationMixin } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

import ADDITIONAL_INFORMATION_FIELD from "@salesforce/schema/PuppyLog__c.AdditionalInformation__c";
import DATE_FIELD from "@salesforce/schema/PuppyLog__c.Date__c";
import DOG_FIELD from "@salesforce/schema/PuppyLog__c.Dog__c";
import RAISER_FIELD from "@salesforce/schema/PuppyLog__c.Raiser__c";
import SUPPORT_FIELD from "@salesforce/schema/PuppyLog__c.RequestSupportFromAtlas__c";

export default class PuppyLogFormCmp extends NavigationMixin(LightningElement) {
    @api recordId;
    @api contactId;
    @api dogId;
    currentCv;
    wiredCv;
    message;

    get today() {
        return new Date().toISOString();
    }

    objectName = RAISER_FIELD.objectApiName;

    fields = {
        information: ADDITIONAL_INFORMATION_FIELD,
        date: DATE_FIELD,
        dog: DOG_FIELD,
        raiser: RAISER_FIELD,
        support: SUPPORT_FIELD
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

    @wire(getRelatedFiles, { recordId: "$recordId", max: 1 })
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
        var documentId = null;
        if (this.uploadedFile) {
            documentId = this.uploadedFile.documentId;
        }
        const form = this.template.querySelector("lightning-record-edit-form");
        form.submit();
    }

    handleLogChanged(event) {
        // if we are creating a new log and adding the CV
        if (this.currentCv && !this.recordId) {
        relateFile({
            documentId: this.currentCv.ContentDocumentId,
            recordId: event.detail.id
        })
        .then(() => {
                this.dispatchEvent(
                    new CustomEvent("changed", { detail: event.detail.id })
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error assigning file to log!!",
                        message: error.message,
                        variant: "error"
                    })
                );
            });
        } else {
            this.dispatchEvent(
                new CustomEvent("changed", { detail: event.detail.id })
            );
        }
    }
}
