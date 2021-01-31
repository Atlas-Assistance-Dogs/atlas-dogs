import { LightningElement, wire,track} from 'lwc';
import getAllAccounts from '@salesforce/apex/courseActionBuilder.getAllAccounts';

//import showAssignedCourses from '@salesforce/apex/courseActionBuilder.getAllAccounts';

const actions = [
  { label: 'Show Course details', name: 'show_details' },
  { label: 'Replace', name: 'replace' },
];

const columns =[
    {label:'Account Name', fieldName: 'Name', sortable: true, type: 'url', typeAttributes: {label: { fieldName: 'Name' },target: '_blank'}},         
    {label:'First Name', fieldName: 'First_Name__c'},
    {label:'Last Name', fieldName: 'Last_Name__c'},
    {
      type: 'action',
      typeAttributes: { rowActions: actions },
    }
];

export default class CourseActions extends LightningElement {

    columns = columns;
    @track data = [];
    @track courses = [];
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    noRecordsFound = false;
    showAccountsPage = true;
    showCoursesPage = false;
    recordId;
    accountView = true;
    roleView = false;

    @wire(getAllAccounts)
    wiredData({ error, data }) {
      if (data) {
        this.data = data;
        this.error = undefined;
      } else if (error) {
        this.error = error;
        this.data = undefined;
      }
    }

    handleRowAction(event) {
      const actionName = event.detail.action.name;
      const row = event.detail.row;
      switch (actionName) {
          case 'delete':
              this.deleteRow(row);
              break;
          case 'show_details':
              this.showRowDetails(row);
              break;
          default:
      }
    }

    showRowDetails(row){
      this.showAccountsPage = false;
      this.showCoursesPage = false;
    }

    
    onHandleSort(){
        console.log("Sort Actions");
    }    


}