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
    { label: "Category", fieldName: 'category' },
    { label: "Document Type", fieldName: 'type' },
    { label: "Document Date", fieldName: DATE_FIELD.fieldApiName, type: "date-local" },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedFiles extends NavigationMixin(LightningElement) {
    @api objectApiName;
    @api recordId;
    columns = COLS;
    @track fileUploadList;

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

    @wire(getRelatedFiles, { recordId: "$recordId" }) filesLst(result) {
        this.wiredFilesList = result;
        this.fileUploadList = null;
        if (result.data && result.data.length > 0) {
            this.fileUploadList = result.data.map(x => {
                let info = Object.assign({}, x);
                info['type'] = this.types[x[TYPE_FIELD.fieldApiName]];
                info['category'] = this.categories[x[CATEGORY_FIELD.fieldApiName]];
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
}