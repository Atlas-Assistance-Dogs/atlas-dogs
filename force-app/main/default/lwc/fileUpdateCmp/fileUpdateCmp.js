import { api } from "lwc";
import FileInformationCmp from "c/fileInformationCmp";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateContentVersion from "@salesforce/apex/FileController.updateContentVersion";
import { NavigationMixin } from "lightning/navigation";

export default class DocumentUploadCmp extends FileInformationCmp {
    @api versionId; // not used, but is in the released package
    @api currentCv = { ContentDocumentId: "", Title: "blank" };
    @api recordId; // also defined in FileInformationCmp, not used here
    title = '';
    contentDocumentId = '';
    contentType = "Emergency Contact";

    @api
    openModal(message) {
        this.message = "";
        this.recordId = message?.recordId;
        this.template.querySelector("c-modal-cmp").openModal();
    }
    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleInfo(event) {
        this.title = `${event.detail.title} (${event.detail.fileType})`;
        this.contentDocumentId = event.detail.contentDocumentId;
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
            this.template.querySelector("c-file-information-cmp").getInformation()
        );
        this.closeModal();
    }

    updateFile(info) {
        updateContentVersion({
            category: info.category,
            docType: info.type,
            docDate: info.date,
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
 }
