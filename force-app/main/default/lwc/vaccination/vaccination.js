import { LightningElement, wire, track, api } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const vaccinationFields = [
    "Dog__c.Vaccine_Latest_Distemper__c",
    "Dog__c.Vaccine_Latest_Hepatitis__c",
    "Dog__c.Vaccine_Latest_Parainfluenza__c",
    "Dog__c.Vaccine_Latest_Parvovirus__c",
    "Dog__c.Physical_Exam_Latest__c",
    "Dog__c.Vaccine_Latest_Rabies__c"
];

export default class Vaccination extends LightningElement {
    //@track recordId = 'a0sg0000007TkKQAA0';
    @api recordId;
    @api objectApi;

    fieldsArray = [
        "Vaccine_Latest_Distemper__c",
        "Vaccine_Latest_Hepatitis__c",
        "Vaccine_Latest_Rabies__c"
    ];

    @wire(getRecord, { recordId: "$recordId", fields: vaccinationFields })
    dogRecord;

    today = new Date();
    temp = true;

    get title() {
        return this.temp ? "Vaccinations *" : "Vaccination";
    }

    get isExpired() {
        if (this.dogRecord.data) {
            const mydate = new Date(
                this.dogRecord.data.fields.Vaccine_Latest_Distemper__c.value
            );
            return mydate < this.today;
        }
    }

    get distemper() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.Vaccine_Latest_Distemper__c.value;
        }
    }

    get hepatitis() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.Vaccine_Latest_Hepatitis__c.value;
        }
    }

    get parainfluenza() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.Vaccine_Latest_Parainfluenza__c
                .value;
        }
    }
    get parvovirus() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.Vaccine_Latest_Parvovirus__c
                .value;
        }
    }
    get physicalExam() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.Physical_Exam_Latest__c.value;
        }
    }
    get rabies() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.Vaccine_Latest_Rabies__c.value;
        }
    }
}
