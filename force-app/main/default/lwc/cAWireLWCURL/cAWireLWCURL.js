import { LightningElement, api, wire, track } from 'lwc';
import getAssignedCourse from '@salesforce/apex/CourseAssigned.getAssignedCourse';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Assigned_Date from '@salesforce/schema/Courses_Taken__c.Assigned_Date__c';
import Name from '@salesforce/schema/Courses_Taken__c.Name';
import Expected_Completion_Date  from '@salesforce/schema/Courses_Taken__c.Expected_Completion_Date__c';
import Actual_Completion_Date from '@salesforce/schema/Courses_Taken__c.Course_Completion_Date__c';
import ID_FIELD from '@salesforce/schema/Courses_Taken__c.Id';


const COLS = [
    { label: 'Name', fieldName: 'Name', initialWidth: 350},
    { label: 'Course Name', fieldName: 'Course_Description__c', initialWidth: 350},
    { label: 'Assigned Date', fieldName: 'Assigned_Date__c', editable: true, initialWidth: 100},
    { label: 'Expected Completion Date', fieldName: 'Expected_Completion_Date__c', editable: true, initialWidth: 100 },
    { label: 'Actual Completion Date', fieldName: 'Course_Completion_Date__c', editable: true, initialWidth: 100 }
];

export default class CAWireLLC extends LightningElement {

    @track error;
    @track draftValues = [];
    @track acctId;
    @api recordId;
    @track columns = [
        Name
    ]

    @wire(getAssignedCourse)
    AssignedCourses;

    handleSave(event) {

        const fields = {};
        fields[ID_FIELD.fieldApiName] = event.detail.draftValues[0].Id;
        fields[Assigned_Date.fieldApiName] = event.detail.draftValues[0].Assigned_Date__c;
        fields[Expected_Completion_Date.fieldApiName] = event.detail.draftValues[0].Expected_Completion_Date__c;
        fields[Actual_Completion_Date.fieldApiName] = event.detail.draftValues[0].Course_Completion_Date__c;

        const recordInput = {fields};

        updateRecord(recordInput)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Courese Assignment Dates updated',
                    variant: 'success'
                })
            );
            // Clear all draft values
            this.draftValues = [];

            // Display fresh data in the datatable
            return refreshApex(this.contact);
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