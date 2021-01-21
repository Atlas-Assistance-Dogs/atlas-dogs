import { LightningElement,  wire, track } from 'lwc';
//import getAssignedCourse from '@salesforce/apex/CourseAssigned.getAssignedCourse';
import getMasterCourses from '@salesforce/apex/CourseAssigned.getMasterCourses';

/*
const COLS = [
    { label: 'Name', fieldName: 'Name', initialWidth: 350},
    { label: 'Course Name', fieldName: 'Course_Description__c', initialWidth: 350},
    { label: 'Assigned Date', fieldName: 'Assigned_Date__c',  initialWidth: 100},
    { label: 'Expected Completion Date', fieldName: 'Expected_Completion_Date__c', initialWidth: 100 },
    { label: 'Actual Completion Date', fieldName: 'Course_Completion_Date__c',  initialWidth: 100 }
];
*/

const COLS = [
    { label: 'Course_SIS_Section_SIS_Course_Name__c', fieldName: 'Course_SIS_Section_SIS_Course_Name__c', initialWidth: 350}
   // { label: 'Course Code', fieldName: 'Course_Code__c',  initialWidth: 100 }
];

let i=0;

export default class CAWireLLC extends LightningElement {

    @track error;
    @track columns = COLS;

    @track page = 1; //this is initialize for 1st page
    @track items = []; //it contains all the records.
    @track data = []; //data to be display in the table
    @track startingRecord = 1; //start record position per page
    @track endingRecord = 0; //end record position per page
    @track pageSize = 10; //default value we are assigning
    @track totalRecountCount = 0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records



    @wire(getMasterCourses)
    AssignedCourses({ error, data }) {
        if (data) {
            //if you want to perform data transformation then following code will be used,
            //so that individual values to be assigned into each columns
            
            for(i=0; i<data.length; i++) {
                this.items = [...this.items,
                                    {
                                        Course_SIS_Section_SIS_Course_Name__c:data[i].Course_SIS_Section_SIS_Course_Name__c, 
                                    }];                               
            }
            
            this.items = data;
            this.totalRecountCount = data.length; //here it is 23
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); //here it is 5
            
            //initital data to be displayed ----------->
            //slice will take 0th element and ends with 5, but it doesn't include 5th element
            //so 0 to 4th rows will be display in the table
            this.data = this.items.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;
            this.columns = COLS;

            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }
  //clicking on previous button this method will be called
  previousHandler() {
    if (this.page > 1) {
        this.page = this.page - 1; //decrease page by 1
        this.displayRecordPerPage(this.page);
    }
}

//clicking on next button this method will be called
nextHandler() {
    if((this.page<this.totalPage) && this.page !== this.totalPage){
        this.page = this.page + 1; //increase page by 1
        this.displayRecordPerPage(this.page);            
    }             
}

//this method displays records page by page
displayRecordPerPage(page){

    /*let's say for 2nd page, it will be => "Displaying 6 to 10 of 23 records. Page 2 of 5"
    page = 2; pageSize = 5; startingRecord = 5, endingRecord = 10
    so, slice(5,10) will give 5th to 9th records.
    */
    this.startingRecord = ((page -1) * this.pageSize) ;
    this.endingRecord = (this.pageSize * page);

    this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                        ? this.totalRecountCount : this.endingRecord; 

    this.data = this.items.slice(this.startingRecord, this.endingRecord);

    //increment by 1 to display the startingRecord count, 
    //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
    this.startingRecord = this.startingRecord + 1;
}


}