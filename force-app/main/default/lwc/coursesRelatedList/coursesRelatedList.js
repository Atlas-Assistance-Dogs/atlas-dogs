import { LightningElement, api, track, wire } from 'lwc';

import showAssignedCourses from '@salesforce/apex/courseActionBuilder.showAssignedCourses';

const columns = [     

    { label:'Name', fieldName: 'Course_Description__c'},
    { label:'Assigned Date', fieldName: 'Assigned_Date__c'},
    { label:'Expected Completion Date', fieldName: 'Expected_Completion_Date__c', type: 'date-local'},
    { label:'Actual Completion Date', fieldName: 'Course_Completion_Date__c', type: 'date-local'},
    { label:'Status', fieldName: 'Status__c', type: 'picklist'},
    
]; 

/*
 { label:'Term SIS', fieldName: 'TermSIS__c'},
{ label:'Course Name', fieldName: 'CourseName__c'},
{ label:'Course SIS', fieldName: 'CourseSIS__c'},
{ label:'Section SIS', fieldName: 'SectionSIS__c'}, */

export default class CoursesRelatedList extends LightningElement {

    @api recordId ;

    @track courseData = [];
    wiredCourseData;
    @track noRecordsFound = true;
    @track error;
    columns = columns;

   @wire(showAssignedCourses,{account:'$recordId'})
    wiredData({ error, data }) {
      if (data) {
        console.log('Data', data);
        this.courseData = data;
        this.noRecordsFound = false;
        this.error = undefined;
      } else if (error) {
         console.error('Error:', error);
         this.error = error;
         this.courseData = undefined;
         this.noRecordsFound = true;
      }
    } 
/*
   @wire(showAssignedCourses,{account:'$recordId'})
    wiredData(result) {
       // this.wiredCourseData = result;
       // const {data,error} = result;
        if (data) {
        this.courseData = data;
        this.noRecordsFound = false;
        this.error = undefined;
        } else if (error) {
            console.error('Error:', error);
        this.error = error;
        this.courseData = undefined;
        this.noRecordsFound = true;
        }
    } */
}