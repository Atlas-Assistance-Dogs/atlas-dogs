import { LightningElement, track, wire, api } from "lwc";
import getAssignedCourses from "@salesforce/apex/CourseController.getAssignedCourses";
import { updateRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import repSelectedCourses from "@salesforce/apex/CourseController.repSelectedCourses";
import assignCoursesToContact from "@salesforce/apex/CourseController.assignCoursesToContact";

import getCourses from "@salesforce/apex/CourseController.getActiveCourses";

const actions = [{ label: "Replace", name: "replace" }];

const columns = [
    { label: "Name", fieldName: "Course_Description__c" },
    { label: "Term SIS", fieldName: "TermSIS__c" },
    { label: "Assigned Date", fieldName: "Assigned_Date__c" },
    {
        label: "Expected Completion Date",
        fieldName: "Expected_Completion_Date__c",
        type: "date-local",
        editable: true
    },
    {
        label: "Actual Completion Date",
        fieldName: "Completion_Date__c",
        type: "date-local",
        editable: true
    },
    {
        label: "Status",
        fieldName: "Status__c",
        type: "picklist",
        editable: true
    },
    {
        type: "action",
        typeAttributes: { rowActions: actions }
    }
];

export default class AssignedCourses extends LightningElement {
    @api course;

    @track courseData = [];
    wiredCourseData;

    @track error;
    columns = columns;
    @track draftValues = [];

    selectedRecords = [];
    recordsCount;
    refreshTable;

    defaultSortDirection = "asc";
    sortDirection = "asc";
    sortedBy;
    noRecordsFound = false;
    recordId;

    @track _selectedCourses = [];
    @track coursesList = [];
    @track courses = [];

    @wire(getAssignedCourses, { id: "$contact" })
    wiredData(result) {
        this.wiredCourseData = result;
        const { data, error } = result;
        if (data) {
            let CourseNameUrl;
            this.courseData = data.map((row) => {
                CourseNameUrl = `/${row.Id}`;
                return { ...row, CourseNameUrl };
            });
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

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case "replace":
                this.replaceCourse(row);
                break;
            case "show_details":
                this.showRowDetails(row);
                break;
            default:
        }
    }

    getSelectedRecords(event) {
        // getting selected rows
        const selectedRows = event.detail.selectedRows;

        this.recordsCount = event.detail.selectedRows.length;

        // this set elements the duplicates if any
        let conIds = new Set();

        // getting selected record id
        for (let i = 0; i < selectedRows.length; i++) {
            conIds.add(selectedRows[i].Id);
        }

        // coverting to array
        this.selectedRecords = Array.from(conIds);

        console.log("selectedRecords ====> " + this.selectedRecords);
    }

    @wire(getCourses)
    wiredCourses({ data, error }) {
        if (data) {
            console.log("data-" + data);
            this.coursesList = data;
            console.log("this.coursesList-" + this.coursesList);
            this.coursesList.forEach((result) => {
                this.courses.push({
                    label: result.Course_Name__c,
                    value: result.Id
                });
            });
        } else if (error) {
            console.error("Error:", error);
        }
    }

    handleReplace(row) {
        if (this.selectedRecords) {
            console.log("SElected Rows -" + this.selectedRecords);

            this.template
                .querySelector("section")
                .classList.remove("slds-hide");
            this.template
                .querySelector("div.modalBackdrops")
                .classList.remove("slds-hide");
        }
    }

    ReplaceCoursesHandler() {
        // get roles for Contact
        // fetch courses for that contact
        // Add selected courses to contact (contact)

        console.log("Selection:-" + this._selectedCourses);

        if (this.selectedRecords) {
            console.log("SElected Rows -" + this.selectedRecords);
            console.log("contact -" + this.contact);

            repSelectedCourses({ lstCourseIds: this.selectedRecords })
                .then((result) => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Success!!",
                            message:
                                this.recordsCount +
                                " Courses Status changed to replaced",
                            variant: "success"
                        })
                    );

                    this.template.querySelector(
                        "lightning-datatable"
                    ).selectedRows = [];
                    this.recordsCount = 0;
                    // refreshing table data using refresh apex
                    return refreshApex(this.refreshTable);
                })
                .catch((error) => {
                    window.console.log(error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Error",
                            message: error.message,
                            variant: "error"
                        })
                    );
                });
        }
        //console.log("Replace Course");

        if (this.selectedRecords) {
            console.log("Selected Rows -" + this.selectedRecords);
            console.log("contact -" + this.contact);

            assignCoursesToContact({
                contactId: this.contact,
                courseIds: this._selectedCourses
            })
                .then((result) => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Success!!",
                            message:
                                " New Courses are added to replace selected Courses",
                            variant: "success"
                        })
                    );
                })
                .catch((error) => {
                    window.console.log(error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Error",
                            message: error.message,
                            variant: "error"
                        })
                    );
                });
        }

        this.handleCancel();
    }

    handleCourseSelecion(e) {
        this._selectedCourses = e.detail.value;
        console.log("Seelection:-" + this._selectedCourses);
    }

    onHandleSort() {
        console.log("Sort Actions");
    }

    handleCancel() {
        this.template.querySelector("section").classList.add("slds-hide");
        this.template
            .querySelector("div.modalBackdrops")
            .classList.add("slds-hide");
    }
}
