import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from "lightning/navigation";

import NAME_FIELD from '@salesforce/schema/Contact.Name';

const fields = [
    NAME_FIELD
];

import recordSelected from '@salesforce/messageChannel/RelatedFiles__c';

export default class AllRelatedFilesCmp extends NavigationMixin(LightningElement) {
    @api recordId = '00319000010uTqDAAU';
 
    name = 'Sample';
    list = 'Object';
    objectApiName;

    @wire(getRecord, { recordId: '$recordId', fields })
    wiredRecord({ error, data }) {
        this.record = data;
        if (error) {
            this.dispatchToast(error);
        } else if (data) {
            this.name = data.fields.Name.value;
            this.list = data.apiName.replace('__c', '') + 's';
            this.objectApiName = data.apiName;
        }
    }

    // Helper
    dispatchToast(error) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error loading contact',
                message: reduceErrors(error).join(', '),
                variant: 'error'
            })
        );
    }

    navigateToList(event) {
        //event.stopPropagation();
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.objectApiName,
                actionName: 'list'
            }
        });
    }

    navigateToObject(event) {
        //event.stopPropagation();
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: this.objectApiName,
                actionName: 'view'
            }
        });
    }
}