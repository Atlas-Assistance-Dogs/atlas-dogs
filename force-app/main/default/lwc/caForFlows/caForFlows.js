import { LightningElement, wire, track } from 'lwc';
import getMasterCourses from '@salesforce/apex/courseAssignmentFlowScreen.getMasterCourses';

const COLS = [
    { label: 'Course Name', fieldName: 'Course_SIS_Section_SIS_Course_Name__c', initialWidth: 350},
    { label: 'Course Code', fieldName: 'Course_Code__c', initialWidth: 80}    
];

export default class CaForFlows extends LightningElement {

    @track columns = COLS;

    @wire(getMasterCourses)
    assignedCourses;
}