import { LightningElement,track, api } from 'lwc';
// imported to show toast messages
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const COLS = [
    { label: 'File Name', fieldName: 'name'},
    { label: 'Document Id', fieldName: 'documentId'}
];
const filelst=[];

export default class FileUploadwithToastEvent extends LightningElement {
    @api
    recordId;
    @track columns=COLS;
    
    @api filelst;

    // accepted parameters
    get acceptedFormats() {
        return ['.pdf', '.png','.jpg','.jpeg'];
    }
    handleUploadFinished(event) {
    // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        const filedoc={};
        const filelist=[];
    
        for(let i = 0; i < uploadedFiles.length; i++) {
           
           filedoc.name = uploadedFiles[i].name;
           filedoc.documentId = uploadedFiles[i].documentId;
           
           filelist.push(filedoc);


            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: filedoc.name+filedoc.documentId+uploadedFiles.length+filelist.length,
                    variant: 'success',
                }))

              
        }
 this.filelst=filelist;
        
    }
}