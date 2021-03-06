import { LightningElement, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getAllContacts from "@salesforce/apex/ContactController.getPagedContacts";
import getCourses from "@salesforce/apex/CourseController.getCourses";
import getContactsWithPosition from "@salesforce/apex/ContactController.getContactsWithPosition";
import addSelectedCourses from "@salesforce/apex/CourseController.addSelectedCourses";

const actions = [
    { label: "Show Course details", name: "show_details" },
    { label: "Edit", name: "edit" },
    { label: "Add", name: "edit" }
];

const columns = [
    { label: "Contact", fieldName: "Contact__c" },
    { label: "Course Name", fieldName: "CourseName__c" },
    { label: "Assigned Date", fieldName: "Assigned_Date__c" },
    {
        label: "Expected Completion Date",
        fieldName: "Expected_Completion_Date__c",
        editable: true
    },
    {
        type: "action",
        typeAttributes: { rowActions: actions }
    }
];

export default class CourseList extends LightningElement {
    pageNumber = 1;
    pageSize;
    totalCount = 0;

    @track btnVisible = true;

    columns = columns;
    noRecordsFound = false;

    searchKey = "";
    @track contacts = [];
    viewValue = "contact";
    //roles = ['Facilitator','Client','Trainer','Volunteer'];
    @track roles = [];
    value = [];

    showCourses = false;

    accountView = true;

    @track coursesList = [];
    @track selectedAccountResult = [];
    @track courses = [];
    @track subjects;

    @track selectedCourses = [];

    @wire(getContactsWithPosition, { role: ":value" })
    wiredData({ data, error }) {
        if (data) {
            this.selectedAccountResult = data;
            console.log("Data", data);
        } else if (error) {
            console.error("Error:", error);
        }
    }

    @wire(getAllContacts, {
        searchKey: "$searchKey",
        pageNumber: "$pageNumber"
    })
    wiredResult({ error, data }) {
        if (data) {
            this.contacts = data.records;
            this.totalCount = data.totalItemCount;
            this.pageSize = data.pageSize;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }

    get viewOptions() {
        return [
            { label: "contacts", value: "contact" },
            { label: "Roles", value: "role" }
        ];
    }

    viewChange(event) {
        this.viewValue = event.detail.value;
        if (this.viewValue == "contact") {
            this.accountView = true;
            this.btnVisible = true;
        } else {
            this.accountView = false;
            this.btnVisible = false;
        }
    }

    get getCourses() {
        //return this.roles.join(',');
        this.showCourses = true;
    }

    handleCourseSelecion(e) {
        this.selectedCourses = e.detail.value;
        console.log("Selection: " + this.selectedCourses);
    }

    handleRoleChange(e) {
        this.value = e.detail.value;
    }

    get roleOptions() {
        return [
            { label: "Facilitator", value: "Facilitator" },
            { label: "Client", value: "Client" },
            { label: "Trainer", value: "Trainer" },
            { label: "Volunteer", value: "Volunteer" }
        ];
    }

    get selectedRoles() {
        this.roles = this.value.join(";");
        return this.value.join(",");
    }

    //*********** */

    AddSelectedCourseToRole() {
        console.log("Role- " + this.roles);

        addSelectedCourses({
            roles: this.roles,
            selectedCourses: this.selectedCourses
        })
            .then((result) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success!!",
                        message: " Courses are Added.",
                        variant: "success"
                    })
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error,
                        message: error + " Problem in Adding new Courses.",
                        variant: "error"
                    })
                );
            });

        this.handleCancel();
    }

    @wire(getCourses)
    wiredCourses({ data, error }) {
        if (data) {
            this.coursesList = data;
            this.coursesList.forEach((result) => {
                //this.courses.push({ label:result.Course_Name__c , value: result.Course_Code__c })
                this.courses.push({
                    label: result.Course_Name__c,
                    value: result.Id
                });
            });
        } else if (error) {
            console.error("Error:", error);
        }
    }

    handleDateEdit() {
        console.log("Save");
    }

    handleSearchKey(event) {
        this.searchKey = event.detail.value;
        this.pageNumber = 1;
    }

    handlePreviousPage() {
        this.pageNumber = this.pageNumber - 1;
    }

    handleNextPage() {
        this.pageNumber = this.pageNumber + 1;
    }

    handleCancel() {
        this.template.querySelector("section").classList.add("slds-hide");
        this.template
            .querySelector("div.modalBackdrops")
            .classList.add("slds-hide");
    }

    AddNewCourse() {
        this.template.querySelector("section").classList.remove("slds-hide");
        this.template
            .querySelector("div.modalBackdrops")
            .classList.remove("slds-hide");
    }

    activeSections = ["A"];
    activeSectionsMessage = "";

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = "All sections are closed";
        } else {
            this.activeSectionsMessage =
                "Open sections: " + openSections.join(", ");
        }
    }
}
