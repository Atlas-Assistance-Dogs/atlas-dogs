import { LightningElement, api, wire, track } from 'lwc';
import getMasterCourses from '@salesforce/apex/CourseAssigned.getMasterCourses';
//import getFacilitatorCourses from '@salesforce/apex/CourseAssigned.getFacilitatorCourses';
import getCommonCourses from '@salesforce/apex/CourseAssigned.getCommonCourses';
//import getTrainerCourses from '@salesforce/apex/CourseAssigned.getTrainerCourses';
//import getClientCourses from '@salesforce/apex/CourseAssigned.getClientCourses';
import getAssignedCourse from '@salesforce/apex/CourseAssigned.getAssignedCourse';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const COLS = [
    { label: 'Course Name', fieldName: 'Course_SIS_Section_SIS_Course_Name__c', sortable: 'true'},
    { label: 'Status', fieldName: 'Status__c'},
  
 ];

const cmasterlst=[];
let preSelectedLst= [];
let preSelectedCom =[];
const selectRows=[];
let comList =[];
let facList=[];
let clientList = [];
let trainerList = [];

export default class CourseMasterFlow extends LightningElement {
    @track error;
    @track columns = COLS;
    @api cmasterlst;
    //@track preSelectedLst=[];
    @track  selectRows = [];
    @track preSelectedCom=[];
    @track sortDirection;
    @track sortedBy;
    @track combinedList = [];
    @api typeOfUser;
    @track courses;
    @track masterCourses=[];
    @track assigned =  [];
    @api recordId;
    retrievedRows = [];
    
    
    @wire(getCommonCourses)
    CommonCourse({data, error}){
      
        if(data){ 
                preSelectedCom = data; 
                this.error=undefined;
                for(let k=0; k<preSelectedCom.length; k++){
                    comList.push(preSelectedCom[k].Id) }
                }
                
         else if (error){
             this.error=error;
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
    
    @wire(getMasterCourses)
    AssignedCourses({data,error}){
        if(data){
            this.masterCourses = data;
            let localAssigned = [];
            let localAssignedIds =[];
            localAssigned = this.assigned;
            /***Covert Array to Object****/
            const arrayToObject = (localAssigned, keyField) =>
            localAssigned.reduce((obj, item) => {
                obj[item[keyField]] = item
                return obj
            }, {})
        
            const asscoursesObject = arrayToObject(localAssigned, "Id")
              
            /*******/
            for(let i =0;i<localAssigned.length;i++){
                localAssignedIds.push(localAssigned[i].Id);
            }
           
            let currentData = [];
            data.forEach((row) => {
               let rowData = {};
                if(localAssignedIds.includes(row.Id)){
                    rowData.Status__c = asscoursesObject[row.Id].Status__c;
                    rowData.Course_SIS_Section_SIS_Course_Name__c = row.Course_SIS_Section_SIS_Course_Name__c;
                    rowData.Id = row.Id;
                    currentData.push(rowData);
                }else{
                    rowData.Status__c = 'Not Assigned';
                    rowData.Course_SIS_Section_SIS_Course_Name__c = row.Course_SIS_Section_SIS_Course_Name__c;
                    rowData.Id = row.Id;
                    currentData.push(rowData);
                }
            });
           
            this.courses = currentData;
           
           if(this.typeOfUser == 'Facilitator'){
            this.retrievedRows=[].concat(facList,comList);
           
            }else if(this.typeOfUser == 'Client'){
            this.retrievedRows=[].concat(clientList,comList);
            }
            else if(this.typeOfUser == 'Trainer'){
                this.retrievedRows=[].concat(trainerList,comList);
            }
            this.selectRows =this.retrievedRows;
            this.selectMoveTop();
        }
        else if(error){
            this.error = error;
            alert(this.error);
            this.courses = undefined;
        }
    }

    @wire(getAssignedCourse,{recordId: '$recordId'})
    getAssignedCourse({data, error}) {
        if(data){
            let currentData = [];
            data.forEach((row) => {
              
                let rowData = {};
                    rowData.Status__c = row.Status__c;
                    rowData.Id = row.Course_Name__c;
                    currentData.push(rowData);
               
            });
            
            this.assigned = currentData;
            
        }
        else if(error){
            this.error = error;
            alert(this.error);
            this.courses = undefined;
        }
    }


     //To show selected records on the top
    
    selectMoveTop(){
        this.combinedList = this.courses ;
            let selectList = [];
            let unselectlist =[];
               for(var i=0;i<this.combinedList.length;i++){
                    if(this.selectRows && this.selectRows.includes(this.combinedList[i].Id)){
                        selectList.push(this.combinedList[i]);
                    }else{
                        unselectlist.push(this.combinedList[i]);
                    }
               }
                this.courses = selectList.concat(unselectlist);

    }

    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
            let cmList = [];
        for (let i = 0; i < selectedRows.length; i++){
            cmList.push(selectedRows[i].Id);
        }
        this.cmasterlst=cmList;

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'preSelectedLst',
                message: 'onclick Cmasterlength:'+this.cmasterlst.length,
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

   sortBy (field, reverse, primer){ 
    var key = function (x) {return primer ? primer(x[field]) : x[field]}; 
    return function (a,b) {
        var A = key(a), B = key(b);
        if (A === undefined) A = '';
        if (B === undefined) B = '';
        return (A < B ? -1 : (A > B ? 1 : 0)) * [1,-1][+!!reverse];
    }
   }
   

}