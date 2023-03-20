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

NavigationMixin(LightningElement) {
    @api recordId;
    @track fileUploadList = [];
    @track fileIDs = [];
    isErrorMessage = false;
    message = "";
    recordTypeId;
    category = "Client";
    type = "Contact Form";
    categories = [];
    types = [];

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
            this.categories = result.data.map((x) => {
                return { label: x, value: x };
            });
            if (this.categories.length == 1) {
                this.category = this.categories[0];
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

    @wire(getPicklistValues, {
        recordTypeId: "$recordTypeId",
        fieldApiName: TYPE_FIELD
    })
    picklistValues;

    fetchPicklistValuesForGPTIForHowCanWeHelpYouField({ error, data }) {
        if (error) {
            console.log("unable to fetch values");
        } else if (data && data.picklistFieldValues) {
            let optionsValue = {};
            optionsValue["label"] = "--None--";
            optionsValue["value"] = "--None--";
            this.controllingPicklist.push(optionsValue);

            data.picklistFieldValues["controllingFieldAPIName"].values.forEach(
                (optionData) => {
                    this.controllingPicklist.push({
                        label: "ABC",
                        value: "ABC"
                    });
                }
            );
            this.dependentPicklist = data.picklistFieldValues["Field2"];
            //  this.showpicklist = true;

            this.finalDependentVal = [];
            //  this.showdependent = false;
            const selectedVal = "ABC";
            this.finalDependentVal.push({
                label: "--None--",
                value: "--None--"
            });
            let controllerValues = this.dependentPicklist.controllerValues;
            this.dependentPicklist.values.forEach((depVal) => {
                depVal.validFor.forEach((depKey) => {
                    if (depKey === controllerValues[selectedVal]) {
                        this.dependentDisabled = false;
                        // this.showdependent = true;
                        this.finalDependentVal.push({
                            label: depVal.label,
                            value: depVal.value
                        });
                    }
                });
            });
        }
    }
}
