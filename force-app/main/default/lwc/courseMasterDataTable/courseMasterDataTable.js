import { LightningElement ,api, wire, track} from 'lwc';
import getCourseMasterList from '@salesforce/apex/CourseMasterHelper.getCourseMasterList';
export default class LightningDatatableLWCExample extends LightningElement {
         @track columns = [{
            label: 'Couse Desc',
            fieldName: 'Name',
            type: 'text',
            initialWidth: 175
        },
        {
            label: 'Course Name',
            fieldName: 'Course_Name__c',
            type: 'text',
            sortable: true,
            initialWidth: 450,
            wrapText: true
        },
        {
            label: 'Course Code',
            fieldName: 'Course_Code__c',
            type: 'text',
            sortable: true,
            initialWidth: 125
        },
        {
            label: 'Section SIS',
            fieldName: 'Section_SIS__c',
            type: 'text',
            sortable: true,
            initialWidth: 125
        },
        {
            label: 'Term SIS',
            fieldName: 'Term_SIS__c',
            type: 'text',
            sortable: true,
            initialWidth: 125
        },
        {
            label: 'Active',
            fieldName: 'Active__c',
            type: 'boolean',
            sortable: true,
            initialWidth: 75,
            editable : 'true'
        },
                {
            label: 'Commmon Course',
            fieldName: 'Common_Course__c',
            type: 'boolean',
            sortable: true,
            initialWidth: 150,
            editable : 'true'
        },
        {
            label: 'Facilitator Course',
            fieldName: 'Facilitator_Course__c',
            type: 'boolean',
            sortable: true ,
            initialWidth: 150,
            editable : 'true'
        },
        {
            label: 'Trainer Course',
            fieldName: ',Trainer_Course__c',
            type: 'boolean',
            sortable: true,
            initialWidth: 150,
            editable : 'true'
        }
    ];
 
    @track error;
    @track courseList ;
    @wire(getCourseMasterList)
    wiredAccounts({
        error,
        data
    }) {
        if (data) {
            this.courseList = data;
        } else if (error) {
            this.error = error;
        }
    }
}