import { LightningElement, wire, track, api } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const vaccinationFields = [
    "Dog__c.VaccineLatestDistemper__c",
    "Dog__c.VaccineLatestHepatitis__c",
    "Dog__c.VaccineLatestParainfluenza__c",
    "Dog__c.VaccineLatestParvovirus__c",
    "Dog__c.PhysicalExamLatest__c",
    "Dog__c.VaccineLatestRabies__c"
];

export default class Vaccination extends LightningElement {
    //@track recordId = 'a0sg0000007TkKQAA0';
    @api recordId;
    @api objectApi;

    fieldsArray = [
        "VaccineLatestDistemper__c",
        "VaccineLatestHepatitis__c",
        "VaccineLatestRabies__c"
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
                this.dogRecord.data.fields.VaccineLatestDistemper__c.value
            );
            return mydate < this.today;
        }
    }

    get distemper() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.VaccineLatestDistemper__c.value;
        }
    }

    get hepatitis() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.VaccineLatestHepatitis__c.value;
        }
    }

    get parainfluenza() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.VaccineLatestParainfluenza__c
                .value;
        }
    }
    get parvovirus() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.VaccineLatestParvovirus__c.value;
        }
    }
    get physicalExam() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.PhysicalExamLatest__c.value;
        }
    }
    get rabies() {
        if (this.dogRecord.data) {
            return this.dogRecord.data.fields.VaccineLatestRabies__c.value;
        }
    }
}
