import { LightningElement, wire, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getContentVersion from "@salesforce/apex/FileController.getContentVersion";
import updateContentVersion from "@salesforce/apex/FileController.updateContentVersion";
import { NavigationMixin } from "lightning/navigation";

import CATEGORY_FIELD from "@salesforce/schema/ContentVersion.Category__c";
import TYPE_FIELD from "@salesforce/schema/ContentVersion.Type__c";
import DATE_FIELD from "@salesforce/schema/ContentVersion.Date__c";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import updateFile from "@salesforce/messageChannel/UpdateFile__c";

export default class DocumentUploadCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @api currentCv = { ContentDocumentId: "", Title: "blank" };
    contentType = "Emergency Contact";

    fields = {
        category: CATEGORY_FIELD,
        type: TYPE_FIELD,
        date: DATE_FIELD
    };
    
    @api
    openModal() {
        this.message = "";
        this.template.querySelector("c-modal-cmp").openModal();
    }
    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleView(event) {
        let currentRecordID = this.currentCv.ContentDocumentId;
        this[NavigationMixin.Navigate]({
            type: "standard__namedPage",
            attributes: {
                pageName: "filePreview"
            },
            state: {
                selectedRecordId: currentRecordID
            }
        });
    }

    handleSubmit(event) {
        event.preventDefault();
        this.updateFile(
            this.template.querySelector(".category").value,
            this.template.querySelector(".type").value,
            this.template.querySelector(".date").value,
        );
        this.closeModal();
    }

    updateFile(category, docType, docDate) {
        updateContentVersion({
            category: category,
            docType: docType,
            docDate: docDate,
            recordId: this.recordId
        })
            .then((data) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "File Updated",
                        message: data,
                        variant: "success"
                    })
                );
                this.dispatchEvent(new CustomEvent("update"));
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

    @wire(MessageContext)
    messageContext;

    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                updateFile,
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
        getContentVersion({ recordId: this.recordId })
            .then((data) => {
                this.currentCv = data;
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
