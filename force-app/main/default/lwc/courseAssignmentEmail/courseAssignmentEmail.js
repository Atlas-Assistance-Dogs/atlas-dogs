import { LightningElement, api, wire } from "lwc";
import getAssignedCourses from "@salesforce/apex/CourseController.getAssignedCourses";

export default class CourseAssignmentEmail extends LightningElement {
    student = { id: "abcdexfg", Name: "Abby McDonald", Email: "abby@farm.org" };
    contactId;
    @api
    get contact() {
        return this.student;
    }
    set contact(value) {
        this.student = value;
        this.contactId = this.student.Id;
    }

    courses = [
        {
            id: "abcdef",
            Course__r: { Course_SIS_Section_SIS_Course_Name__c: "course 1" }
        },
        {
            id: "abcdefg",
            Course__r: { Course_SIS_Section_SIS_Course_Name__c: "course 2" }
        },
        {
            id: "bcdefg",
            Course__r: { Course_SIS_Section_SIS_Course_Name__c: "course 3" }
        }
    ];

    /*
    @wire(getAssignedCourses, { contact: "$contactId" })
    wiredData({ data, error }) {
        if (data) {
            this.courses = data;
            console.log("Data", data);
        } else if (error) {
            console.error("Error:", error);
        }
    }*/
}
