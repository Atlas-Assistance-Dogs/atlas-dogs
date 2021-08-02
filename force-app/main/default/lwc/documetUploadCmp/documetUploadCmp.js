import { LightningElement, track, api, wire } from "lwc";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import retrieveAllData from "@salesforce/apex/FileController.retrieveAllData";
import deleteRecords from "@salesforce/apex/FileController.deleteRecords";
import updateRecords from "@salesforce/apex/FileController.updateRecords";
import { refreshApex } from '@salesforce/apex';

const actions = [{ label: "Delete", name: "delete" }];

const COLS = [
    { label: "File Name", fieldName: "Title" },
    { label: "userType", fieldName: "Position_Files__c" },
    { label: "docType", fieldName: "Document_Type__c" },
    { label: "Document Date", fieldName: "CreatedDate", type: "date" },
    { type: "action", typeAttributes: { rowActions: actions }}
];

export default class DocumetUploadCmp extends LightningElement {

    @api objectApiName;
    @api recordId;
    @track isModalOpen = false;
    @track columns = COLS;
    position;
    docType;
    @track wiredFilesList = [];
    @track fileUploadList = [];
    @api fileID = [];
    @api filelst
    @track accList;
    disableValue = false;
    isErrorMessage = false;
    errorMessage = "";
    @api fileName;

     // localCountofFiles;
     // @api countOfFiles;

    @wire(retrieveAllData, { recordId: '$recordId' }) filesLst (result) {
        this.wiredFilesList = result;
        if (result.data) {
            this.fileUploadList = result.data;
        } else if (result.error) {
            this.fileUploadList = [];
            this.dispatchEvent( new ShowToastEvent({
                                    title: "Error!!",
                                    message: result.error.message,
                                    variant: "error"
                                })
                            );
        }
    }
    
    get acceptedFormats() {
        return [".pdf", ".png", ".jpg", ".jpeg", ".doc", ".docx", ".txt", ".xlxs",".xls",".csv"];
    }

    openModal() {
        this.errorMessage = "";
        this.isModalOpen = true;

    }
    closeModal() {
        this.isModalOpen = false;
    }

     handleUploadFinished(event) {
        this.isErrorMessage = false;
        this.errorMessage = "File Uploaded Successfully";
        const uploadedFiles = event.detail.files;
        for (let i = 0; i < uploadedFiles.length; i++) {
            this.fileName += uploadedFiles[i].name + ", ";
            this.fileID.push(uploadedFiles[i].documentId);
        }
    }

    handleSubmit(event){

        event.preventDefault(); 
        const fields = event.detail.fields;
        this.position = fields.Position_Files__c;
        this.docType = fields.Document_Type__c;
        this.updateFiles();
        refreshApex(this.wiredFilesList);
        this.isModalOpen = false;
    }
    updateFiles() {
        updateRecords( { recordId: this.currenRecordId, position: this.position, docType: this.docType, docName: this.fileName, docId: this.fileID } )
            .then((data) => {
                console.log("Update data" + JSON.stringify(data));
            })
            .catch((error) => {
                console.log('Error' + JSON.stringify(error));
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
    /*
    getRelatedFiles() {
        retrieveAllData({ recordId: this.currenRecordId  })
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

    */
    //Show Error if Count of Files are less
    /*
    handleErrorOnUpload() {
        if (this.localCountofFiles < this.countOfFiles) {
            this.errorMessage =
                "Minimum of " + this.countOfFiles + " files are required";
            this.isErrorMessage = true;
        } else {
            this.isErrorMessage = false;
        }
    }

     getSelectedRecords(event) {

     }

     */

 
}
