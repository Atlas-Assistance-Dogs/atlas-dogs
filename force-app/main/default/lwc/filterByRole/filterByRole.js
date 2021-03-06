import { LightningElement, wire } from "lwc";
import getCoursesForPositions from "@salesforce/apex/CourseController.getCoursesForPositions";

export default class FilterByRole extends LightningElement {
    roles;
    courses;
    showCourses = false;

    value = [];

    get options() {
        return [
            { label: "Facilitator", value: "Facilitator" },
            { label: "Client", value: "Client" },
            { label: "Trainer", value: "Trainer" },
            { label: "Volunteer", value: "Volunteer" }
        ];
    }

    handleChange(e) {
        this.value = e.detail.value;

        if (this.value != null) {
            this.roles = this.value.join(",");
        }
    }

    @wire(getCoursesForPositions, { roles: "$roles" })
    wiredData({ data, error }) {
        if (data) {
            this.courses = data;
            this.showCourses = true;
        } else if (error) {
            console.error("Error:", error);
        }
    }

    handleDateEdit() {
        console.log("Save");
    }
}
