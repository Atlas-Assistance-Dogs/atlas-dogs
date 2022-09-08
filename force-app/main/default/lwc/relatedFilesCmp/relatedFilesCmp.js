import { LightningElement, api, wire, track } from "lwc";
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import deleteRecord from "@salesforce/apex/FileController.deleteRecord";
import { refreshApex } from "@salesforce/apex";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import CV_OBJECT from '@salesforce/schema/ContentVersion';
import CATEGORY_FIELD from "@salesforce/schema/ContentVersion.Category__c";
import TYPE_FIELD from "@salesforce/schema/ContentVersion.Type__c";
import DATE_FIELD from "@salesforce/schema/ContentVersion.Date__c";

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from "lightning/messageService";
import updateFile from "@salesforce/messageChannel/updateFile__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    {
        label: "File Name",
        type: "button",
        typeAttributes: {
            name: "view",
            label: { fieldName: "Title" },
            variant: "base",
            iconName: "utility:file",
            iconPosition: "left"
        }
    },
    { label: "Category", fieldName: 'category', sortable: true },
    { label: "Document Type", fieldName: 'type', sortable: true },
    { label: "Document Date", fieldName: DATE_FIELD.fieldApiName, type: "date-local", sortable: true },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedFiles extends NavigationMixin(LightningElement) {
    @api objectApiName;
    @api recordId;
    @api max = 6;
    columns = COLS;
    @track files;
    total = 0;

    openModal() {
        this.template.querySelector("c-file-upload-cmp").openModal();
    }
    @wire(getObjectInfo, { objectApiName: CV_OBJECT })
    objectInfo;

    get recordTypeId() {
        // Returns a map of record type Ids 
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Special Account');
    }

    types;

    @wire(getPicklistValues, { recordTypeId: "$objectInfo.data.defaultRecordTypeId", fieldApiName: TYPE_FIELD })
    getTypeValues(result) {
        if (result.data && result.data.values && result.data.values.length > 0)
        {
            this.types = Object.assign({}, ...result.data.values.map((x) => ({[x.value]: x.label})));
        }
    }

    categories;

    @wire(getPicklistValues, { recordTypeId: "$objectInfo.data.defaultRecordTypeId", fieldApiName: CATEGORY_FIELD })
    getCategoryValues(result) {
        if (result.data && result.data.values && result.data.values.length > 0)
        {
            this.categories = Object.assign({}, ...result.data.values.map((x) => ({[x.value]: x.label})));
        }
    }

    @wire(getRelatedFiles, { recordId: "$recordId", max: "$max" }) filesLst(result) {
        this.wiredFilesList = result;
        this.files = null;
        let relatedObjects = result.data;
        if (relatedObjects && relatedObjects.total > 0) {
            if (this.max < 10) {
                this.total = relatedObjects.total;
            }

            this.files = relatedObjects.items.map(x => {
                let info = Object.assign({}, x);
                info['type'] = x[TYPE_FIELD.fieldApiName];
                info['category'] = x[CATEGORY_FIELD.fieldApiName];

                if (this.types) {
                    info.type = this.types[info.type];
                }
                if (this.categories) {
                    info.category = this.categories[info.category];
                }
                
                return info;
            });
        } else if (result.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error!!",
                    message: result.error.message,
                    variant: "error"
                })
            );
        }
    }

    handleUpdate() {
        refreshApex(this.wiredFilesList);
    }

    @wire(MessageContext)
    messageContext;

    defaultSortDirection = "asc";
    sortDirection = "asc";
    sortedBy;

    // Used to sort the columns
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.files];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === "asc" ? 1 : -1));
        this.files = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case "delete":
                this.deleteCons(row);
                break;
            case "edit":
                const payload = { recordId: row.Id, fileName: row.Title };
                publish(this.messageContext, updateFile, payload);
                break;
            case "view":
                this.navigateToFiles(row);
                break;
            default:
        }
    }

    navigateToFiles(currentRow) {
        let currentRecordID = currentRow.ContentDocumentId;
        this[NavigationMixin.Navigate]({
            type: "standard__namedPage",
            attributes: {
                pageName: "filePreview"
            },
            state: {
                selectedRecordId: currentRecordID
            }
        });
    }

    deleteCons(currentRow) {
        let currentRecordID = currentRow.ContentDocumentId;
        deleteRecord({ docId: currentRecordID })
            .then((result) => {
                let res = result;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success!!",
                        message: res,
                        variant: "success"
                    })
                );
                this.isErrorMessage = false;
                refreshApex(this.wiredFilesList);
            })
            .catch((error) => {
                window.console.log("Error ====> " + error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error!!",
                        message: error.body.message,
                        variant: "error"
                    })
                );
            });
    }

    handleViewAll(){

    }
}