import { track, api, wire } from "lwc";
import FileInformationCmp from "c/fileInformationCmp";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateRecords from "@salesforce/apex/FileController.updateRecords";

export default class DocumentUploadCmp extends FileInformationCmp {

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
            this.template.querySelector("c-file-information-cmp").getInformation(),
            uploadedFiles
        );
    }

    handleSubmit(event) {
        event.preventDefault();
        this.closeModal();
    }

    updateFiles(info, files) {
        updateRecords({
            category: info.category,
            docType: info.type,
            docDate: info.date,
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
