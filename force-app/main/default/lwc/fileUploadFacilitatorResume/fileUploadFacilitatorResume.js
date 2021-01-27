import { LightningElement,api,track,wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
//import {refreshApex} from '@salesforce/apex'
//import { deleteRecord } from 'lightning/uiRecordApi'
import accountFilesRetrieve from '@salesforce/apex/RetrieveFiles.accountFilesRetrieve';
import deleteRecords from '@salesforce/apex/RetrieveFiles.deleteRecords';
import updateRecords from '@salesforce/apex/RetrieveFiles.updateRecords';

import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

const actions = [
    { label: 'Delete', name: 'delete' },
];

const COLS = [
    {label: 'File Name', fieldName: 'Title'},
    {label: 'Document ID', fieldName: 'ContentDocumentId'},
   
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

export default class FileUploadFacilitatorResume extends LightningElement {
    @api recordId;
    @track columns=COLS;
    @api filelst;
    refreshTable;
    error;
    @api lwcname;   
    @track fileUploadList;
    @track data;
    @track error;
    @track accList ;
    @api userType;
    @api docType;
    disableValue=false;
    localCountofFiles;
    isErrorMessage = false;;
    errorMessage ='';
    @api fileName;
    @api  fileID;
    
    @api
    get countOfFiles(){
        return this._countOfFiles;
    }
    set countOfFiles(val=''){
        this._countOfFiles = val;
    }
    
    connectedCallback() {
        this.getRelatedFiles();
    }

    // accepted parameters
    get acceptedFormats() {
        return ['.pdf', '.png','.jpg','.jpeg', '.doc', '.docx', '.txt'];
    }
   
    handleUploadFinished(event){
        this.isErrorMessage = false;
        const uploadedFiles = event.detail.files;
        this.fileName = uploadedFiles[0].name;
        this.fileID = uploadedFiles[0].documentId;
        this.updateFiles();
        this.getRelatedFiles();
        const attributeChangeEvent = new FlowAttributeChangeEvent('countOfFiles', this.countOfFiles);
        this.dispatchEvent(attributeChangeEvent); 
    
}
//Update the Files with User Type and Doc Type 
    updateFiles(){
        updateRecords({accountId: this.recordId,userType: this.userType,docType: this.docType,docName:this.fileName,docId:this.fileID})
        .then(data => {
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });

 }
    // Getting releated files of the current record
   getRelatedFiles() {
        accountFilesRetrieve({accountId: this.recordId,userType: this.userType,docType: this.docType,docName:this.fileName,docId:this.fileID})
        .then(data => {
            this.fileUploadList = data;
            this.localCountofFiles = this.fileUploadList.length;
            this.handleErrorOnUpload();
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
        
    }
    //Show Error if Count of Files are less 
    handleErrorOnUpload(){
        if(this.localCountofFiles < this.countOfFiles){
            this.errorMessage = 'Minimum of ' +this.countOfFiles+ ' files are required'
            this.isErrorMessage = true;
        }else{
            this.isErrorMessage = false;
        }
    }
   
    getSelectedRecords(event) {
            const actionName = event.detail.action.name;
            const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteCons(row);
                break;
        }

    }
    
    deleteCons(currentRow) {
       let currentRecord = [];
        currentRecord.push(currentRow.ContentDocumentId);
        // calling apex class method to delete the selected contact
        deleteRecords({docIds: currentRecord})
        .then(result => {
            let res = result;
            //alert('result'+this.res);
            // showing success message
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: 'Success',
                variant: 'success'
            }),);
            this.isErrorMessage = false;
            // refreshing table data using refresh apex
            this.getRelatedFiles();

        })
        .catch(error => {
            window.console.log('Error ====> '+error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!', 
                message: error.message, 
                variant: 'error'
            }),);
        });
    }


}