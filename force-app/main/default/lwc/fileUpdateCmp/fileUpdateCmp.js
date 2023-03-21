import { wire, api } from "lwc";
import FileInformationCmp from "c/fileInformationCmp";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecord } from "lightning/uiRecordApi";
import updateContentVersion from "@salesforce/apex/FileController.updateContentVersion";
import { NavigationMixin } from "lightning/navigation";

import TITLE_FIELD from "@salesforce/schema/ContentVersion.Title";
import DOCID_FIELD from "@salesforce/schema/ContentVersion.ContentDocumentId";

export default class DocumentUploadCmp extends FileInformationCmp {
    @api versionId; // not used, but is in the released package
    @api currentCv = { ContentDocumentId: "", Title: "blank" };
    title = '';
    contentDocumentId = '';
    contentType = "Emergency Contact";

    @api
    openModal(message) {
        this.message = "";
        this.recordId = message?.recordId;
        this.getFileInfo();
        this.template.querySelector("c-modal-cmp").openModal();
    }
    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleView(event) {
        let currentRecordID = this.contentDocumentId;
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
    @wire(getRecord, { recordId: '$recordId', fields: [DOCID_FIELD, TITLE_FIELD] })
    getFileInfo(result) {
        if (result?.data) {
            this.title = result.data.fields.Title.value;
            this.contentDocumentId = result.data.fields.ContentDocumentId.value;
        }
        else if (result?.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error!!",
                    message: result.error.message,
                    variant: "error"
                })
            );
        }
    }
 }
