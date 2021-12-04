import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import addBackgroundCheck from "@salesforce/apex/BackgroundCheckController.addBackgroundCheck";
import updateBackgroundCheck from "@salesforce/apex/BackgroundCheckController.updateBackgroundCheck";
import { NavigationMixin } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

import CONTACT_FIELD from "@salesforce/schema/BackgroundCheck__c.Contact__c";
import DATE_FIELD from "@salesforce/schema/BackgroundCheck__c.Date__c";
import NOTES_FIELD from "@salesforce/schema/BackgroundCheck__c.Notes__c";
import RESULT_FIELD from "@salesforce/schema/BackgroundCheck__c.Status__c";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import backgroundCheckForm from "@salesforce/messageChannel/BackgroundCheckForm__c";

export default class BackgroundCheckFormCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @api contactId;
    currentCv;
    wiredCv;
    message;
    contentType = "Background Check";
    title = "Background Check";

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
        this.currentCv = null;
        if (result.data) {
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

    handleSubmit(event) {
        event.preventDefault();
        let fields = [
            ...this.template.querySelectorAll("lightning-input-field")
        ];
        var record = fields.reduce(
            (a, x) => ({ ...a, [x.fieldName]: x.value }),
            {}
        );
        record.Contact__c = this.contactId;
        var documentId = null;
        if (this.uploadedFile) {
            documentId = this.uploadedFile.documentId;
        }
        if (!this.recordId) {
            this.createBC(record, documentId);
        } else {
            record.Id = this.recordId;
            this.updateBC(record);
        }
    }

    createBC(record, documentId) {
        addBackgroundCheck({
            check: record,
            documentId: documentId
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
                this.closeModal();
            });
    }

    updateBC(record) {
        updateBackgroundCheck({
            check: record
        })
            .then(() => {
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
                this.closeModal();
            });
    }

    @wire(MessageContext)
    messageContext;

    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                backgroundCheckForm,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    // Handler for message received by component
    handleMessage(message) {
        this.recordId = message.recordId;
        this.currentCv = null;
        refreshApex();
        this.openModal();
    }

    // Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }
}
