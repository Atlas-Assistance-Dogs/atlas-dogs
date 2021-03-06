import { LightningElement, track, api, wire } from "lwc";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import retrieveAllData from "@salesforce/apex/FileController.retrieveAllData";
import deleteRecords from "@salesforce/apex/FileController.deleteRecords";
import updateRecords from "@salesforce/apex/FileController.updateRecords";
import TYPE__C_FIELD from "@salesforce/schema/ContentVersion.Type__c";
import POSITIONS__C_FIELD from "@salesforce/schema/ContentVersion.Positions__c";
import { getPicklistValues } from "lightning/uiObjectInfoApi";

const actions = [{ label: "Delete", name: "delete" }];

const COLS = [
    { label: "File Name", fieldName: "Title" },
    { label: "userType", fieldName: "Positions__c" },
    { label: "docType", fieldName: "Type__c" },
    { label: "Document Date", fieldName: "CreatedDate", type: "date" },

    {
        type: "action",
        typeAttributes: { rowActions: actions }
    }
];

export default class FileUploadForRelatedList extends LightningElement {
    @track isModalOpen = false;
    @api userPicklistValues;
    @api docPicklistValues;

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
    userValue = "inProgress";
    docValue = "inProgress";

    @wire(getPicklistValues, {
        recordTypeId: "012000000000000AAA",
        fieldApiName: TYPE__C_FIELD
    })
    picklistValues({ error, data }) {
        if (data) {
            this.docPicklistValues = [
                { label: "--None--", value: "", selected: true },
                ...data.values
            ];
        } else {
            this.error = error;
            this.treeModel = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId: "012000000000000AAA",
        fieldApiName: positions__C_FIELD
    })
    picklistValues1({ error, data }) {
        if (data) {
            this.userPicklistValues = [
                { label: "--None--", value: "", selected: true },
                ...data.values
            ];
        } else {
            this.error = error;
            this.treeModel = undefined;
        }
    }

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.errorMessage = "";
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
    // 012000000000000AAA

    handleChangeUser(event) {
        this.userType = event.detail.value;
    }

    handleChangeDoc(event) {
        this.docType = event.detail.value;
    }
    onValueSelection(event) {
        // eslint-disable-next-line no-alert
        alert(event.target.value);
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
        this.errorMessage = "File Uploaded Successfully";
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
                console.log("Update data" + JSON.stringify(data));
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
        retrieveAllData({ accountId: this.recordId })
            .then((data) => {
                this.fileUploadList = data;
                console.log(
                    "this.fileUploadList" + JSON.stringify(this.fileUploadList)
                );

                //Check if file Upload list is Not null
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
            this.errorMessage =
                "Minimum of " + this.countOfFiles + " files are required";
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
