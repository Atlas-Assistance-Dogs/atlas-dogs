import { LightningElement, track, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateRecords from "@salesforce/apex/FileController.updateRecords";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import getCategoriesForObject from "@salesforce/apex/CategoryRuleController.getCategoriesForObject";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import { NavigationMixin } from "lightning/navigation";

import CV_OBJECT from "@salesforce/schema/ContentVersion";
import CATEGORY_FIELD from "@salesforce/schema/ContentVersion.Category__c";
import TYPE_FIELD from "@salesforce/schema/ContentVersion.Type__c";
import DATE_FIELD from "@salesforce/schema/ContentVersion.Date__c";

export default class FileInformation extends NavigationMixin(LightningElement) {
    @api recordId;
    @track fileUploadList = [];
    @track fileIDs = [];
    isErrorMessage = false;
    message = "";
    recordTypeId;
    category = "Client";
    type = "ContactForm";
    @track categories = [];
    @track types = [{ label: 'Contact Form', value: 'ContactForm' }];

    fields = {
        category: CATEGORY_FIELD,
        type: TYPE_FIELD,
        date: DATE_FIELD
    };
    categories = [];
    category = null;

    @wire(getCategoriesForObject, { recordId: "$recordId" })
    getCategories(result) {
        if (result?.data) {
            this.categories = result.data;
            if (this.categories.length == 1) {
                this.category = this.categories[0].value;
            }
        } else if (result?.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error!!",
                    message: error.body.message,
                    variant: "error"
                })
            );
        }
    }

    recordTypeId;
    @wire(getObjectInfo, { objectApiName: CV_OBJECT })
    objectInfo({ error, data }) {
        if (data) {
            const rtis = data.recordTypeInfos;
            // Returns a map of record type names to their ids
            this.recordTypeId = Object.keys(rtis)[0];
        }
    }

    categoryTypes = {};

    @wire(getPicklistValues, {
        recordTypeId: "$recordTypeId",
        fieldApiName: TYPE_FIELD
    })
    getPicklistValuesForType({ error, data }) {
        if (error) {
            console.log("unable to fetch values");
        } else if (data && data.values) {
            const controlling = data.controllerValues;
            let controlLookup = [];
            data.values.forEach(
                (optionData) => {
                    optionData.validFor.forEach(idx => {
                        if (!controlLookup[idx]) {
                            controlLookup[idx] = [];
                        }
                        controlLookup[idx].push({ label: optionData.label, value: optionData.value });
                    });
                }
            );
            this.categoryTypes = {};
            for (const cat in controlling) {
                this.categoryTypes[cat] = controlLookup[controlling[cat]];
            }
        }
    }

    handleCategoryChange(event) {
        this.category = event.detail.value;
    }

    handleTypeChange(event) {
        this.type = event.detail.value;
    }

    get types() {
        return this.categoryTypes ? this.categoryTypes[this.category] : [];
    }
}
