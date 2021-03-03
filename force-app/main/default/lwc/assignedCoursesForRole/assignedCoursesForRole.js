import { LightningElement, track, wire, api } from "lwc";
import assignedCoursesForPosition from "@salesforce/apex/CourseController.assignedCoursesForPosition";

const columns = [
    { label: "Account Name", fieldName: "AccountName__c" },
    { label: "Course Name", fieldName: "CourseName__c" },
    { label: "Section SIS", fieldName: "SectionSIS__c" },
    { label: "Term SIS", fieldName: "TermSIS__c" },
    { label: "Course SIS", fieldName: "CourseSIS__c" },
    { label: "Assigned Date", fieldName: "Assigned_Date__c" },
    {
        label: "Expected Completion Date",
        fieldName: "Expected_Completion_Date__c",
        type: "date-local",
        editable: true
    },
    {
        type: "action",
        typeAttributes: { rowActions: actions }
    }
];
export default class AssignedCoursesForRole extends LightningElement {
    @api role;
    @track courseData = [];
    wiredCourseData;
    @track error;
    columns = columns;

    noRecordsFound = false;
    recordId;

    @wire(assignedCoursesForPosition, { role: "$role" })
    wiredData(result) {
        this.wiredCourseData = result;
        const { data, error } = result;
        if (data) {
            this.courseData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.courseData = undefined;
        }
    }
}
