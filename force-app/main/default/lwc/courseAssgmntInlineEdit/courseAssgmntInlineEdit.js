import { LightningElement, api, wire, track } from 'lwc';
import getAssignedCourse from '@salesforce/apex/courseAssgmntInline.getAssignedCourse';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const COLS = [
    { label: 'Course Name', fieldName: 'Course_Description__c', initialWidth: 350},
    { label: 'Assigned Date', fieldName: 'Assigned_Date__c', editable: true, initialWidth: 100},
    { label: 'Expected Completion Date', fieldName: 'Expected_Completion_Date__c', editable: true, initialWidth: 100 },
    { label: 'Actual Completion Date', fieldName: 'Course_Completion_Date__c', editable: true, initialWidth: 100 },
    { label: 'Status', fieldName:'Status__c', editable:true, initialWidth:100 }

];

export default class CourseAssgmntInlineEdit extends LightningElement {

    @track error;
    @track columns = COLS;
    @track draftValues = [];
    @track acctId;

    @api recordId;
    

    @wire(getAssignedCourse, {accountID:'$recordId'})
    AssignedCourses;
    
    handleSave(event) {
        const recordInputs =  event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
          console.log(recordInputs);
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(courses => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Courses updated',
                    variant: 'success'
                })
            );
            console.log(promises);
             // Clear all draft values
             this.draftValues = [];
    
             // Display fresh data in the datatable
             return refreshApex(this.AssignedCourses);
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }
    
}