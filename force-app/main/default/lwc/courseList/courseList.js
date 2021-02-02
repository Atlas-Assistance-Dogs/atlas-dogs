import { LightningElement, track, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllAccounts from '@salesforce/apex/courseActionBuilder.getAllAccounts';
import getCourses from '@salesforce/apex/courseActionBuilder.getCourses';
import getSelectedAccounts from '@salesforce/apex/courseActionBuilder.getSelectedAccounts';
import addSelectedCourses from '@salesforce/apex/addCourses.addSelectedCourses';

const actions = [
    { label: 'Show Course details', name: 'show_details' },
    { label: 'Edit', name: 'edit' },
    { label: 'Add', name: 'edit' },
  ];
  
const columns =[
    {label:'Account Name', fieldName: 'AccountName__c'},         
    { label:'Course Name', fieldName: 'CourseName__c'},
    {label:'Assigned Date', fieldName: 'Assigned_Date__c'},
    {label:'Expected Completion Date', fieldName: 'Expected_Completion_Date__c', editable:true},
    {
      type: 'action',
      typeAttributes: { rowActions: actions },
    }
];
  
export default class CourseList extends LightningElement {
  pageNumber = 1;
  pageSize;
  totalCount =0;

  @track btnVisible = true; 

  columns = columns;
  noRecordsFound = false;
  
  searchKey = '';
  @track accounts =[];
  viewValue ='account';
  //roles = ['Facilitator','Client','Trainer','Volunteer'];
  @track roles = [];
  value = [];

  showCourses = false;

  accountView = true;

  @track coursesList =[];
  @track selectedAccountResult =[];
  @track courses =[];
  @track subjects;


  @track _selectedCourses = [];

  @wire(getSelectedAccounts, { role: 'Facilitator' })
  wiredData({ data, error }) {
    if (data) {
      this.selectedAccountResult = data;
      console.log('Data', data);
    } else if (error) {
       console.error('Error:', error);
    }
  }

  @wire(getAllAccounts,{searchKey:'$searchKey', pageNumber:'$pageNumber'})
  wiredResult({ error, data }) {
    if (data) {
      this.accounts = data.records;
      this.totalCount = data.totalItemCount;
      this.pageSize = data.pageSize;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.accounts = undefined;
    }
  }; 
  
  get viewOptions() {
    return [
        { label: 'Accounts', value: 'account' },
        { label: 'Roles', value: 'role' },
    ];
  }

  viewChange(event){
    
    this.viewValue = event.detail.value;
    if(this.viewValue == 'account'){

      this.accountView = true;
      this.btnVisible = true; 

    }else{

      this.accountView = false;
      this.btnVisible = false; 
      
    }
  }

 get getCourses() {
      //return this.roles.join(',');
      this.showCourses =true;

  } 

  handleCourseSelecion(e){
    this._selectedCourses = e.detail.value;
    console.log('Seelection:-'+ this._selectedCourses);
  }

  handleRoleChange(e) {
    this.value = e.detail.value;

}

get roleOptions() {
  return [
      { label: 'Facilitator', value: 'Facilitator' },
      { label: 'Client', value: 'Client' },
      { label: 'Trainer', value: 'Trainer' },
      { label: 'Volunteer', value: 'Volunteer' },
  ];
}

get selectedRoles() {
  this.roles = this.value.join(',');
  return this.value.join(',');
 
}

//*********** */

  AddSelectedCourseToRole() {

    console.log('Role- '+ this.roles);
   
    addSelectedCourses( { roles: this.roles, selectedCourses: this._selectedCourses} )
      .then(result=>{
       
        this.dispatchEvent(
          new ShowToastEvent({
              title: 'Success!!', 
              message: ' Courses are Added.', 
              variant: 'success'
          }),
      );
      })
      .catch(error=>{
        
        this.dispatchEvent(
          new ShowToastEvent({
              title: error, 
              message:  error + ' Problem in Adding new Courses.', 
              variant: 'error'
          }),
      );
        
      }); 

      

      this.handleCancel();
  
  }

  
@wire(getCourses)
wiredCourses({ data,error }) {
  if (data) {
    this.coursesList = data;
    this.coursesList.forEach(result =>{
      //this.courses.push({ label:result.Course_Name__c , value: result.Course_Code__c }) 
      this.courses.push({ label:result.Course_Name__c , value: result.Id }) 
    })
  } else if (error) {
    console.error('Error:',error);
  }
}


    handleDateEdit(){

      console.log('Save');

    }

    handleSearchKey(event){
      this.searchKey = event.detail.value;
      this.pageNumber = 1;
    }

    handlePreviousPage() {
      this.pageNumber = this.pageNumber - 1;
    }
  
    handleNextPage() {
        this.pageNumber = this.pageNumber + 1;
    }

    handleCancel(){
      this.template.querySelector('section').classList.add("slds-hide");
      this.template.querySelector('div.modalBackdrops').classList.add("slds-hide");
    }

    AddNewCourse(){

      this.template.querySelector('section').classList.remove("slds-hide");
      this.template.querySelector('div.modalBackdrops').classList.remove("slds-hide");

    }
    
    activeSections = ['A'];
    activeSectionsMessage = '';

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }


    


    

    

    
    

}