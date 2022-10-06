import { LightningElement, wire, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getContentVersion from "@salesforce/apex/FileController.getContentVersion";
import updateContentVersion from "@salesforce/apex/FileController.updateContentVersion";
import { NavigationMixin } from "lightning/navigation";

import CATEGORY_FIELD from "@salesforce/schema/ContentVersion.Category__c";
import TYPE_FIELD from "@salesforce/schema/ContentVersion.Type__c";
import DATE_FIELD from "@salesforce/schema/ContentVersion.Date__c";

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
    openModal(message) {
        this.message = "";
        this.recordId = message?.recordId;
        this.getFileInfo()
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
            this.template.querySelector(".date").value
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

    // Get the file name and document id
    getFileInfo() {
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
    }
}
