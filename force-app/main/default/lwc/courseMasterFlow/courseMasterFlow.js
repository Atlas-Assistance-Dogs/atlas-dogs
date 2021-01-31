import { LightningElement, api, wire, track } from 'lwc';
import getMasterCourses from '@salesforce/apex/CourseAssigned.getMasterCourses';
import getCourses from '@salesforce/apex/CourseAssigned.getCourses';
import getCommonCourses from '@salesforce/apex/CourseAssigned.getCommonCourses';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLS = [
    { label: 'Course Name', fieldName: 'Course_SIS_Section_SIS_Course_Name__c', initialWidth: 550, sortable: 'true' },
    { label: 'Id', fieldName: 'Id', initialWidth: 150 }

];

const cmasterlst = [];
let preSelectedLst = [];
let preSelectedCom = [];
const selectRows = [];
let comList = [];
let facList = [];

export default class CourseMasterFlow extends LightningElement {
    @track error;
    @track columns = COLS;
    @api cmasterlst;
    @track preSelectedLst = [];
    @track selectRows = [];
    @track preSelectedCom = [];
    @track sortDirection;
    @track sortedBy;
    @api recordId;
    @api typeOfUser;


    @wire(getMasterCourses)
    AssignedCourses;


    @wire(getCommonCourses)
    CommonCourse({ data, error }) {

        if (data) {
            preSelectedCom = data;
            this.error = undefined;
            for (let k = 0; k < preSelectedCom.length; k++) {
                comList.push(preSelectedCom[k].Id)
            }
        }

        else if (error) {
            this.error = error;
        }

    }

    /*@wire(getFacilitatorCourses)
     getFacilitatorCourses ({data, error}) {
         if(data){
             let preSelectedLst=data;
             for(let j=0; j<preSelectedLst.length; j++){
                 facList.push(preSelectedLst[j].Id)
             }
           
             this.error = undefined;
             }
     }
 
     @wire(getClientCourses)
     getClientCourses ({data, error}) {
         if(data){
             let preSelectedLst=data;
             for(let j=0; j<preSelectedLst.length; j++){
                 clientList.push(preSelectedLst[j].Id)
             }
             this.error = undefined;
             }
     }
     @wire(getTrainerCourses)
     getTrainerCourses ({data, error}) {
         if(data){
             let preSelectedLst=data;
             for(let j=0; j<preSelectedLst.length; j++){
                 trainerList.push(preSelectedLst[j].Id)
             }
             this.error = undefined;
             }
     }*/

    @wire(getCourses, { typeOfUser: 'Facilitator' })
    getFacilitatorCourses({ data, error }) {
        if (data) {
            preSelectedLst = data;
        /***Covert Array to Object****/


            /*******/
            for (let j = 0; j < preSelectedLst.length; j++) {



                facList.push(preSelectedLst[j].Id)

            }
            this.error = undefined;
        }
    }

    facclick() {

        let facrows = [].concat(facList, comList);
        this.selectRows = facrows;
        this.cmasterlst = facrows;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'preSelectedLst',
                message: 'FacRow length' + facrows.length + 'Cmaster list length:' + this.cmasterlst.length,
                variant: 'success',
            }))

    }





    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        let cmList = [];
        for (let i = 0; i < selectedRows.length; i++) {
            cmList.push(selectedRows[i].Id);
        }
        this.cmasterlst = cmList;

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'preSelectedLst',
                message: 'onclick Cmasterlength:' + this.cmasterlst.length,
                variant: 'success',
            }))

    }

    // The method onsort event handler
    updateColumnSorting(event) {
        var fieldName = event.detail.fieldName;
        var sortDirection = event.detail.sortDirection;
        // assign the latest attribute with the sorted column fieldName and sorted direction
        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;
        let reverse = sortDirection !== 'asc';
        let data_clone = JSON.parse(JSON.stringify(this.AssignedCourses.data));
        this.AssignedCourses.data = data_clone.sort(this.sortBy(fieldName, reverse));

    }

    sortBy(field, reverse, primer) {
        var key = function (x) { return primer ? primer(x[field]) : x[field] };
        return function (a, b) {
            var A = key(a), B = key(b);
            if (A === undefined) A = '';
            if (B === undefined) B = '';
            return (A < B ? -1 : (A > B ? 1 : 0)) * [1, -1][+!!reverse];
        }
    }


}