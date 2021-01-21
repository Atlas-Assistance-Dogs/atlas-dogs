import { LightningElement, track } from 'lwc';
import getAcct from '@salesforce/apex/courseAssignmentByAccount.getAcct';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const accountList = [];

export default class CourseAssignmentByAccount extends LightningElement {
@track error;
@track accountList = [];
@track noRecordsFound = true;


findAccount(event) {
    const accName = event.target.value;

    if(accName) {
        getAcct ( {accName}) 
        .then(result => {
           this.accountList = 'Ramesh Immadi';
           this.dispatchEvent(
            new ShowToastEvent({
                title: 'Selected Customer',
                message: 'Record ID of the selected customer'+this.accountList.length + accName,
               variant: 'success',
            }))

            this.noRecordsFound = false;
        })
    } else {
        this.accountList = undefined;
        this.noRecordsFound = true;
    }
}



}