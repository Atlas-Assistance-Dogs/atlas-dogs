import { LightningElement ,api, wire, track} from 'lwc';
import getAssignedCourse from '@salesforce/apex/CourseAssigned.getAssignedCourse';
export default class CourseAssignedDataTable extends LightningElement {
 @api recordId;
 @wire(getAssignedCourse, {accId:'$recordId' })
   courses;

    @track columns = [{
        label: 'Course Name',
        fieldName: 'Course_Name__r.Course_SIS_Section_SIS_Course_Name__c',
        type: 'text',
        initialWidth: 175
    },
    {
        label: 'Assigned Date',
        fieldName: 'Assigned_Date__c',
        type: 'date',
        sortable: true,
        initialWidth: 100,
        wrapText: true
    },
    {
        label: 'Expected Completion Date',
        fieldName: 'Expected_Completion_Date__c',
        type: 'date',
        sortable: true,
        initialWidth: 100
    },
    {
        label: 'Course Completion Date',
        fieldName: 'Course_Completion_Date__c',
        type: 'date',
        sortable: true,
        initialWidth: 100
    }
];

@track error;
@track courseList ;
@wire(getAssignedCourse)
wiredAccounts({
    error,
    data
}) {
    if (data) {
        this.courseList = data;
    } else if (error) {
        this.error = error;
    }
}
}