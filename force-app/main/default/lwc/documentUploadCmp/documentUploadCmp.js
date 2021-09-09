import { LightningElement, track, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateRecords from "@salesforce/apex/FileController.updateRecords";
import { refreshApex } from "@salesforce/apex";
import { NavigationMixin } from "lightning/navigation";

export default class DocumentUploadCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @track fileUploadList = [];
    @track fileID = [];
    isErrorMessage = false;
    message = "";
    fileName;

    get acceptedFormats() {
        return [
            ".pdf",
            ".png",
            ".jpg",
            ".jpeg",
            ".doc",
            ".docx",
            ".txt",
            ".xlxs",
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

    handleUploadFinished(event) {
        this.isErrorMessage = false;
        this.message = "File Uploaded Successfully";
        const uploadedFiles = event.detail.files;
        for (let i = 0; i < uploadedFiles.length; i++) {
            this.fileName += uploadedFiles[i].name + ", ";
            this.fileID.push(uploadedFiles[i].documentId);
        }
    }

    handleSubmit(event) {
        event.preventDefault();
        var category = this.template.querySelector(".category").value;
        var docType = this.template.querySelector(".type").value;
        this.updateFiles(category, docType);
    }

    updateFiles(category, docType) {
        updateRecords({
            recordId: this.recordId,
            category: category,
            docType: docType,
            docName: this.fileName,
            docId: this.fileID
        })
            .then((data) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Files Loaded",
                        message: data,
                        variant: "success"
                    })
                );
                this.dispatchEvent(new CustomEvent("confirm"));
                this.closeModal();
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error!!",
                        message: error.message,
                        variant: "error"
                    })
                );
            });
    }
}
