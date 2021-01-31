import { LightningElement,track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex'
import { deleteRecord } from 'lightning/uiRecordApi'

const actions = [
    { label: 'Show details', name: 'show_details' },
    { label: 'Delete', name: 'delete' },
];

const COLS = [
    { label: 'File Name', fieldName: 'name',initialWidth: 400},
    { label: 'Document Id', fieldName: 'documentId',initialWidth: 175},
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

const filelst=[];

export default class FileUploadFacilitatorResume extends LightningElement {@api recordId;
    @track columns=COLS;
       @api filelst;
       refreshTable;
       error;
    @api lwcname;   

    // accepted parameters
    get acceptedFormats() {
        return ['.pdf', '.png','.jpg','.jpeg', '.doc', '.docx', '.txt'];
    }

    handleUploadFinished(event) {
    // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        //const filedoc={};
        const filelist=[];
    
        for(let i = 0; i < uploadedFiles.length; i++) {
            let filedoc={};
           filedoc.name = uploadedFiles[i].name;
           filedoc.documentId = uploadedFiles[i].documentId;
           
           filelist.push(filedoc);

        //               this.dispatchEvent(
        //        new ShowToastEvent({
         //           title: 'Success!!',
         //           message: filedoc.name,
         //           variant: 'success',
         //       }))

              
        }
        this.filelst=filelist; 
        
    }

    handleRowAction(event) {

        /*this.dispatchEvent(
            new ShowToastEvent({
                title: 'Entered Event handler!!',
                message: event.detail.action.name,
                variant: 'success',
            }))
            */
          //  let row=event.detail.row;

        const documentId = event.detail.row.documentId;
        const documentName  = event.detail.row.name;

        deleteRecord(documentId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Deleted the file:'+documentName,
                        variant: 'success',
                    }),
                    

                );

                let list1 = [];

                for(let k = 0; k < this.filelst.length; k++)
                 {
                    if (this.filelst[k].documentId !==  documentId) {
                    list1.push( this.filelst[k]); }
                }
            this.filelst =  list1;

                
            return refreshApex(this.filelst)

              /*
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'File list length before deletion',
                        message: 'File length is:'+this.filelst.length,
                        variant: 'success',
                    }))
                */
                    
        
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error While Deleting record',
                        message: error.message,
                        variant: 'error',
                    }),
                );

            });

    }




}