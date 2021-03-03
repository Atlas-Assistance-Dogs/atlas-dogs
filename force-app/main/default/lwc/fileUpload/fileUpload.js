import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import accountFilesRetrieve from "@salesforce/apex/RetrieveFiles.accountFilesRetrieve";
import deleteRecords from "@salesforce/apex/RetrieveFiles.deleteRecords";
import updateRecords from "@salesforce/apex/RetrieveFiles.updateRecords";
import { FlowAttributeChangeEvent } from "lightning/flowSupport";

const actions = [{ label: "Delete", name: "delete" }];

const COLS = [
    { label: "File Name", fieldName: "Title" },
    { label: "Document Date", fieldName: "CreatedDate", type: "date" },
    {
        type: "action",
        typeAttributes: { rowActions: actions }
    }
];

export default class FileUpload extends LightningElement {
    @api recordId;
    @track columns = COLS;
    @api filelst;
    refreshTable;
    error;
    @api lwcname;
    @track fileUploadList;
    @track data;
    @track error;
    @track accList;
    @api userType;
    @api docType;
    disableValue = false;
    localCountofFiles;
    isErrorMessage = false;
    errorMessage = "";
    @api fileName;
    @api fileID = [];
    @api countOfFiles;

    @api validate() {
        console.log("In Validate ****");
        if (this.localCountofFiles > 0) {
            return { isValid: true };
        } else {
            //If the component is invalid, return the isValid parameter as false and return an error message.
            return {
                isValid: false,
                errorMessage:
                    "Minimum of " +
                    this.countOfFiles +
                    " file/s is/are required"
            };
        }
    }

    connectedCallback() {
        this.getRelatedFiles();
    }

    // accepted parameters
    get acceptedFormats() {
        return [".pdf", ".png", ".jpg", ".jpeg", ".doc", ".docx", ".txt"];
    }

    handleUploadFinished(event) {
        this.isErrorMessage = false;
        const uploadedFiles = event.detail.files;
        for (let i = 0; i < uploadedFiles.length; i++) {
            this.fileName += uploadedFiles[i].name + ", ";
            this.fileID.push(uploadedFiles[i].documentId);
        }
        console.log("this.fileID" + this.fileID);
        this.updateFiles();
        this.getRelatedFiles();
    }
    //Update the Files with User Type and Doc Type
    updateFiles() {
        updateRecords({
            accountId: this.recordId,
            userType: this.userType,
            docType: this.docType,
            docName: this.fileName,
            docId: this.fileID
        })
            .then((data) => {
                console.log("data" + JSON.stringify(data));
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
    // Getting releated files of the current record
    getRelatedFiles() {
        accountFilesRetrieve({
            accountId: this.recordId,
            userType: this.userType,
            docType: this.docType
        })
            .then((data) => {
                this.fileUploadList = data;
                console.log(
                    "this.fileUploadList" + JSON.stringify(this.fileUploadList)
                );
                if (this.fileUploadList != null) {
                    this.localCountofFiles = this.fileUploadList.length;
                }
                this.handleErrorOnUpload();
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
    //Show Error if Count of Files are less
    handleErrorOnUpload() {
        if (this.localCountofFiles < this.countOfFiles) {
            // this.errorMessage = 'Minimum of ' +this.countOfFiles+ ' files are required';
            this.isErrorMessage = true;
        } else {
            this.isErrorMessage = false;
        }
    }

    getSelectedRecords(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case "delete":
                this.deleteCons(row);
                break;
        }
    }

    deleteCons(currentRow) {
        let currentRecord = [];
        currentRecord.push(currentRow.ContentDocumentId);
        // calling apex class method to delete the selected contact
        deleteRecords({ docIds: currentRecord })
            .then((result) => {
                let res = result;
                // showing success message
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success!!",
                        message: "Success",
                        variant: "success"
                    })
                );
                this.isErrorMessage = false;
                // refreshing table data using refresh apex
                this.getRelatedFiles();
            })
            .catch((error) => {
                window.console.log("Error ====> " + error);
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
