import { LightningElement,wire,track,api} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

const vaccinationFields = [ 'Dog__c.Most_Recent_Distemper_Vaccine__c',
                            'Dog__c.Most_Recent_Hepatitis_Vaccine__c',
                            'Dog__c.Most_Recent_Parainfluenza_Vaccine__c',
                            'Dog__c.Most_Recent_Parvovirus_Vaccine__c',
                            'Dog__c.Most_Recent_Physical_Exam__c',
                            'Dog__c.Most_Recent_Rabies_Vaccine__c'
                        ];

export default class Vaccination extends LightningElement {

   //@track recordId = 'a0sg0000007TkKQAA0';
   @api recordId;
   @api objectApi;

   fieldsArray = [ 'Most_Recent_Distemper_Vaccine__c',
    'Most_Recent_Hepatitis_Vaccine__c',
    'Most_Recent_Rabies_Vaccine__c'
    
];

    @wire(getRecord, {recordId: '$recordId', fields: vaccinationFields})
    dogRecord;

    today = new Date();
    temp = true;

    get title(){
         return this.temp ? 'Vaccinations *' : 'Vaccination' ;
    }

    get isExpired(){
        if(this.dogRecord.data){
            const mydate = new Date(this.dogRecord.data.fields.Most_Recent_Distemper_Vaccine__c.value);
            return  mydate < this.today ;
        }     
    }

    get distemper(){
        if(this.dogRecord.data){
            return this.dogRecord.data.fields.Most_Recent_Distemper_Vaccine__c.value;
        }             
    }
    

    get hepatitis(){
        if(this.dogRecord.data){
            return this.dogRecord.data.fields.Most_Recent_Hepatitis_Vaccine__c.value;
        }   
    }

    get parainfluenza(){
        if(this.dogRecord.data){
            return this.dogRecord.data.fields.Most_Recent_Parainfluenza_Vaccine__c.value;
        }   
    }
    get parvovirus(){
        if(this.dogRecord.data){
            return this.dogRecord.data.fields.Most_Recent_Parvovirus_Vaccine__c.value;
        }   
    }
    get physicalExam(){
        if(this.dogRecord.data){
            return this.dogRecord.data.fields.Most_Recent_Physical_Exam__c.value;
        }   
    }
    get rabies(){
        if(this.dogRecord.data){
            return this.dogRecord.data.fields.Most_Recent_Rabies_Vaccine__c.value;
        }
    } 
}