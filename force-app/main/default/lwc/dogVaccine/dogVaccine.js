import { LightningElement,api, track,wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getVaccinatios from '@salesforce/apex/dogHandler.getVaccinatios'; 

export default class DogVaccine extends LightningElement {

    @api recordId;
    @track data = [];
    @api today;

    today = new Date();

    @wire(getVaccinatios, { recordId: '$recordId' })
    wiredData({ data,error }) {
      if (data) {
        this.data = data;
        this.error = undefined;
      } else if (error) {
        this.error = error;
        this.data = undefined;
      }
    }
}