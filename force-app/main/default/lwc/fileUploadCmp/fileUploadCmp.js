import { LightningElement, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateRecords from "@salesforce/apex/FileController.updateRecords";
import { NavigationMixin } from "lightning/navigation";

export default class DocumentUploadCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @track fileUploadList = [];
    @track fileIDs = [];
    isErrorMessage = false;
    message = "";
    fileName;
    contentType = "Emergency Contact";
    today = Date.now();

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

    handleUploadFinished(event) {
        this.isErrorMessage = false;
        this.message = "File Uploaded Successfully";
        const uploadedFiles = event.detail.files.map((doc) => doc.documentId);
        this.updateFiles(
            this.template.querySelector(".category").value,
            this.template.querySelector(".type").value,
            this.template.querySelector(".date").value,
            uploadedFiles
        );
    }

    handleSubmit(event) {
        event.preventDefault();
        this.closeModal();
    }

    updateFiles(category, docType, date, files) {
        updateRecords({
            category: category,
            docType: docType,
            date: date,
            docIds: files
        })
            .then((data) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Files Assigned to Category and Type",
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