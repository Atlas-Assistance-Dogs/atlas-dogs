import { LightningElement, track, api, wire } from "lwc";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import retrieveAllData from "@salesforce/apex/FileController.retrieveAllData";
import deleteRecord from "@salesforce/apex/FileController.deleteRecord";
import updateRecords from "@salesforce/apex/FileController.updateRecords";
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';

const actions = [
    { label: 'Show details', name: 'show_details' },
    { label: 'Delete', name: 'delete' },
];

const COLS = [
    { label: "File Name", fieldName: "Title", type: 'fileUpload',typeAttributes :{acceptedFileFormats: '.jpg,.jpeg,.pdf,.png', recordId: { fieldName: 'Id' }, }},
    { label: "userType", fieldName: "Position_Files__c" },
    { label: "docType", fieldName: "Document_Type__c" },
    { label: "Document Date", fieldName: "CreatedDate", type: "date" },
    { type: "action", typeAttributes: { rowActions: actions }}
];

export default class DocumetUploadCmp extends NavigationMixin(LightningElement) {

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

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteCons(row);
                break;
            case 'show_details':
                this.navigateToFiles(row);
                break;
            default:
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
        window.location.reload();
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

    navigateToFiles(currentRow) {
        let currentRecordID = currentRow.ContentDocumentId;
        this[NavigationMixin.Navigate]({
          type: 'standard__namedPage',
          attributes: {
              pageName: 'filePreview'
          },
          state : {
              selectedRecordId:currentRecordID
          }
        })
    }

    deleteCons(currentRow) {
        let currentRecordID = currentRow.ContentDocumentId;
        deleteRecord({ docId: currentRecordID })
            .then((result) => {
                let res = result;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success!!",
                        message: res,
                        variant: "success"
                    })
                );
                this.isErrorMessage = false;
                refreshApex(this.wiredFilesList);
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
