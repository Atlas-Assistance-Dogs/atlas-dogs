import { LightningElement, api, track, wire } from "lwc";
import { updateRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getCourseAssignmentsForCourse from "@salesforce/apex/CourseController.getCourseAssignmentsForCourse";

const columns = [
    { label: "Contact Name", fieldName: "Name" },
    { label: "Assigned Date", fieldName: "Assigned_Date__c" },
    { label: "Assigned Role", fieldName: "Positon__c" },
    {
        label: "Expected Completion Date",
        fieldName: "Expected_Completion_Date__c",
        type: "date-local",
        editable: true
    },
    {
        label: "Actual Completion Date",
        fieldName: "Course_Completion_Date__c",
        type: "date-local",
        editable: true
    }
];

export default class CourseRelatedDetails extends LightningElement {
    @api course;
    @track courseData;
    wiredCourseData;
    error;
    columns = columns;
    @track draftValues = [];

    @wire(getCourseAssignmentsForCourse, { course: "$course" })
    wiredData({ data, error }) {
        if (data) {
            this.courseData = data;
            console.log("courseData-" + this.courseData);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.courseData = undefined;
        }
    }

    // TODO: This method does the same thing as the above.  Remove one of them.
    @wire(getCourseAssignmentsForCourse, { course: "$course" })
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

    handleSave(event) {
        const recordInputs = event.detail.draftValues.slice().map((draft) => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        const promises = recordInputs.map((recordInput) =>
            updateRecord(recordInput)
        );
        Promise.all(promises)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success",
                        message: "Course Date updated",
                        variant: "success"
                    })
                );
                // Clear all draft values
                this.draftValues = [];

                // Display fresh data in the datatable
                return refreshApex(this.wiredCourseData);
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error creating record",
                        message: error.body.message,
                        variant: "error"
                    })
                );
            });

        this.dispatchEvent(new CustomEvent("edit"));
    }
}

/*
            let currentData = [];
            data.forEach((row) => {
                let rowData = {};
                rowData.AccountName__c = row.AccountName__c;
                rowData.Assigned_Date__c = row.Assigned_Date__c;
                rowData.Expected_Completion_Date__c = row.Expected_Completion_Date__c;
                rowData.Course_Completion_Date__c = row.Course_Completion_Date__c;

                if (row.Course_Name__c) {
                    rowData.Role = row.Course_Name__r.Facilitator_Course__c;
                   
                }
                currentData.push(rowData);
            });
            this.data = currentData;
*/
