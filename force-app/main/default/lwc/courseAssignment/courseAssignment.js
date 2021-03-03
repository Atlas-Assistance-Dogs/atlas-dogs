import { LightningElement, api, wire } from "lwc";
import getActiveCourses from "@salesforce/apex/CourseController.getActiveCourses";
import getCourses from "@salesforce/apex/CourseController.getCourses";
import getAssignedCourse from "@salesforce/apex/CourseController.getAssignedCourses";
import updateRecords from "@salesforce/apex/CourseController.updateRecords";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {
    FlowNavigationNextEvent,
    FlowNavigationBackEvent
} from "lightning/flowSupport";

const COLS = [
    {
        label: "Course Name",
        fieldName: "Course_SIS_Section_SIS_Course_Name__c",
        sortable: "true"
    },
    { label: "Status", fieldName: "Status__c" }
];

let coursesList = [];

export default class CourseAssignment extends LightningElement {
    error;
    columns = COLS;
    @api cmasterlst;
    selectRows = [];
    preSelectedCom = [];
    sortDirection;
    sortedBy;
    combinedList = [];
    courses;
    masterCourses = [];
    assigned = [];
    @api recordId;
    retrievedRows = [];
    accountId;
    @api CourseNameOutput = [];
    checkBool = true;
    dupliSelectRows;
    _typeOfUser = "";

    @api
    get typeOfUser() {
        return this._typeOfUser;
    }
    set typeOfUser(val) {
        this._typeOfUser = val;
    }

    connectedCallback() {}

    @wire(getAssignedCourse, { recordId: "$recordId" })
    getAssignedCourse({ data, error }) {
        if (data) {
            let currentData = [];
            data.forEach((row) => {
                let rowData = {};
                rowData.Status__c = row.Status__c;
                rowData.Id = row.Course__c;
                currentData.push(rowData);
            });
            console.log("this.assigned in same method" + this.assigned);
            this.assigned = currentData;
            this.AssignedCourses();
        } else if (error) {
            this.error = error;
            alert(this.error);
            this.courses = undefined;
        }
    }

    AssignedCourses() {
        getActiveCourses()
            .then((data) => {
                console.log("getActiveCourses");
                this.masterCourses = data;
                let localAssigned = [];
                let localAssignedIds = [];
                //console.log('this.assigned in master method'+this.assigned);
                localAssigned = this.assigned;
                /***Covert Array to Object****/
                const arrayToObject = (localAssigned, keyField) =>
                    localAssigned.reduce((obj, item) => {
                        obj[item[keyField]] = item;
                        return obj;
                    }, {});

                const asscoursesObject = arrayToObject(localAssigned, "Id");

                /*******/
                for (let i = 0; i < localAssigned.length; i++) {
                    localAssignedIds.push(localAssigned[i].Id);
                }
                console.log("localAssignedIds" + localAssignedIds);
                let currentData = [];
                data.forEach((row) => {
                    let rowData = {};
                    if (localAssignedIds.includes(row.Id)) {
                        console.log(
                            "inside if of localAssignedIds" +
                                asscoursesObject[row.Id].Status__c
                        );
                        rowData.Status__c = asscoursesObject[row.Id].Status__c;
                        rowData.Course_SIS_Section_SIS_Course_Name__c =
                            row.Course_SIS_Section_SIS_Course_Name__c;
                        rowData.Id = row.Id;
                        currentData.push(rowData);
                    } else {
                        console.log("inside else of localAssignedIds");
                        rowData.Status__c = "Not Assigned";
                        rowData.Course_SIS_Section_SIS_Course_Name__c =
                            row.Course_SIS_Section_SIS_Course_Name__c;
                        rowData.Id = row.Id;
                        currentData.push(rowData);
                    }
                });
                // console.log('this.retrievedRows in second wire'+this.retrievedRows);
                this.courses = currentData;
                this.getSelectedCourses();
                //this.selectMoveTop();
            })
            .catch((error) => {
                this.error = error;
                this.courses = undefined;
            });
    }

    getSelectedCourses() {
        getCourses({ typeOfUser: this._typeOfUser })
            .then((data) => {
                let preSelectedLst = data;
                for (let j = 0; j < preSelectedLst.length; j++) {
                    coursesList.push(preSelectedLst[j].Id);
                    this.CourseNameOutput.push(
                        "<br/>" +
                            "Name - " +
                            JSON.stringify(
                                preSelectedLst[j]
                                    .Course_SIS_Section_SIS_Course_Name__c
                            )
                    );
                }
                console.log("getCourses");
                console.log("this._recordId" + this._recordId);
                this.retrievedRows = coursesList;
                this.selectRows = coursesList;
                this.dupliSelectRows = this.selectRows;
                console.log("this.selectRows.length" + this.selectRows.length);
                this.selectMoveTop();
                //console.log('this.retrievedRows'+this.retrievedRows);
                if (this.selectRows.length > 1) {
                    this.checkBool = false;
                }

                //this.getAssignedCourses();
            })
            .catch((error) => {
                this.error = error;
            });
    }

    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        let cmList = [];
        let coursName = [];
        for (let i = 0; i < selectedRows.length; i++) {
            cmList.push(selectedRows[i].Id);
            coursName.push(
                "<br/>" +
                    "Name - " +
                    selectedRows[i].Course_SIS_Section_SIS_Course_Name__c
            );
        }
        this.cmasterlst = cmList;
        this.CourseNameOutput = coursName;
        if (this.cmasterlst.length > 1) {
            this.retrievedRows = this.cmasterlst;
            this.checkBool = false;
        }
    }
    //To show selected records on the top

    selectMoveTop() {
        console.log("selectMoveTop");
        this.combinedList = this.courses;
        //console.log('this.combinedList'+JSON.stringify(this.combinedList));
        let selectList = [];
        let unselectlist = [];
        console.log("this.selectRows in select to top" + this.selectRows);
        // console.log('this.selectRows duplicate'+this.dupliSelectRows);
        for (var i = 0; i < this.combinedList.length; i++) {
            //console.log('inside for loop' + this.combinedList[i].Id);
            if (
                this.selectRows &&
                this.selectRows.includes(this.combinedList[i].Id)
            ) {
                console.log("inside if");
                selectList.push(this.combinedList[i]);
            } else {
                //console.log('inside else');
                unselectlist.push(this.combinedList[i]);
            }
        }
        console.log("selectList" + selectList.length);
        console.log("unselectlist" + unselectlist.length);
        this.courses = selectList.concat(unselectlist);
        console.log("final courses" + this.courses.length);
    }

    handleNext(event) {
        const nextNavigationEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(nextNavigationEvent);
        this.updateRecordsToAssignedStatus();
    }

    handleBack(event) {
        const nextNavigationEvent = new FlowNavigationBackEvent();
        this.dispatchEvent(nextNavigationEvent);
    }
    handlePause(event) {
        const pauseNavigationEvent = new FlowNavigationBackEvent();
        this.dispatchEvent(pauseNavigationEvent);
    }
    updateRecordsToAssignedStatus() {
        let updateList = this.retrievedRows;
        console.log("updateList" + updateList);
        if (this.retrievedRows) {
            updateRecords({ accId: this.recordId, sobList: updateList })
                .then((result) => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: "Success",
                            message: "Records updated",
                            variant: "success"
                        })
                    );
                })
                .catch((error) => {
                    console.log("-------error-------------" + error);
                    console.log(error);
                });
        }
    }

    // The method onsort event handler
    updateColumnSorting(event) {
        var fieldName = event.detail.fieldName;
        var sortDirection = event.detail.sortDirection;
        // assign the latest attribute with the sorted column fieldName and sorted direction
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        let reverse = sortDirection !== "asc";
        let data_clone = JSON.parse(JSON.stringify(this.AssignedCourses.data));
        this.AssignedCourses.data = data_clone.sort(
            this.sortBy(fieldName, reverse)
        );
    }

    sortBy(field, reverse, primer) {
        var key = function (x) {
            return primer ? primer(x[field]) : x[field];
        };
        return function (a, b) {
            var A = key(a),
                B = key(b);
            if (A === undefined) A = "";
            if (B === undefined) B = "";
            return (A < B ? -1 : A > B ? 1 : 0) * [1, -1][+!!reverse];
        };
    }
}
