import { LightningElement, api, wire, track } from "lwc";
import getAssignedCourses from "@salesforce/apex/CourseController.getAssignedCourses";
import { updateRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const COLS = [
    {
        label: "Course Name",
        fieldName: "Course_Description__c",
        initialWidth: 350
    },
    {
        label: "Assigned Date",
        fieldName: "Assigned_Date__c",
        editable: true,
        initialWidth: 100
    },
    {
        label: "Expected Completion Date",
        fieldName: "Expected_Completion_Date__c",
        editable: true,
        initialWidth: 100
    },
    {
        label: "Actual Completion Date",
        fieldName: "Course_Completion_Date__c",
        editable: true,
        initialWidth: 100
    }
];

export default class CourseAssignmentInlineEdit extends LightningElement {
    @track error;
    @track columns = COLS;
    @track draftValues = [];
    @track acctId;

    @api recordId;

    @wire(getAssignedCourses, { accountID: "$recordId" })
    AssignedCourses;

    handleSave(event) {
        const recordInputs = event.detail.draftValues.slice().map((draft) => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

        const promises = recordInputs.map((recordInput) =>
            updateRecord(recordInput)
        );
        Promise.all(promises)
            .then((courses) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success",
                        message: "Courses updated",
                        variant: "success"
                    })
                );
                // Clear all draft values
                this.draftValues = [];

                // Display fresh data in the datatable
                return refreshApex(this.AssignedCourses);
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
    }
}
