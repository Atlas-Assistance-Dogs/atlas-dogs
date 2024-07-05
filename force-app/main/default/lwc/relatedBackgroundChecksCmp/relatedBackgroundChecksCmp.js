import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedChecks from "@salesforce/apex/BackgroundCheckController.getRelatedChecks";
import { deleteRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";

import BACKGROUND_CHECK from "@salesforce/schema/BackgroundCheck__c";
import DATE_FIELD from "@salesforce/schema/BackgroundCheck__c.Date__c";
import NAME_FIELD from "@salesforce/schema/BackgroundCheck__c.Name";
import STATUS_FIELD from "@salesforce/schema/BackgroundCheck__c.Status__c";
import TYPE_FIELD from "@salesforce/schema/BackgroundCheck__c.Type__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    {
        label: "Name",
        type: "button",
        typeAttributes: {
            name: "goto",
            label: { fieldName: NAME_FIELD.fieldApiName },
            variant: "base"
        },
        sortable: true
    },
    {
        label: "Completed Date",
        fieldName: DATE_FIELD.fieldApiName,
        type: "date-local",
        sortable: true
    },
    { label: "Type", fieldName: TYPE_FIELD.fieldApiName, sortable: true },
    { label: "Status", fieldName: STATUS_FIELD.fieldApiName, sortable: true },
    {
        label: "File",
        type: "button",
        typeAttributes: {
            name: "view",
            label: { fieldName: "fileName" },
            variant: "base",
            iconName: "utility:file",
            iconPosition: "left",
            disabled: { fieldName: "noFile" }
        }
    },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedBackgroundChecksCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @api objectApiName;
    @api viewAll;
    columns = COLS;
    data = [];
    wiredChecks;
    total = 0;
    relatedObject = BACKGROUND_CHECK;

    defaultSortDirection = "asc";
    sortDirection = "asc";
    sortedBy;

    // Used to sort the 'Age' column
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
        const cloneData = [...this.data];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === "asc" ? 1 : -1));
        this.data = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case "delete":
                this.deleteCheck(row.Id);
                break;
            case "edit":
                const payload = { mode: "edit", recordId: row.Id };
                this.template.querySelector("c-related-background-check-cmp").openModal(payload);
                break;
            case "goto":
                this.navigateToRecord(row.Id, this.objectApiName);
                break;
            case "view":
                this.navigateToFiles(row);
                break;
        }
    }

    navigateToFiles(currentRow) {
        let currentRecordID = currentRow.documentId;
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

    @api
    get max() {
        return this.viewAll ? 10000 : 6;
    }

    @wire(getRelatedChecks, { contactId: "$recordId", max: "$max" })
    getChecks(result) {
        this.wiredChecks = result;
        this.data = null;
        if (result.data && result.data.items) {
            this.data = result.data.items.map((info) => {
                var bgc = Object.assign({}, info);
                bgc = Object.assign(bgc, info.check);
                return bgc;
            });
            if (this.data.length === 0) {
                this.data = null;
                this.total = 0;
            }
            if (!this.viewAll) {
                this.total = result.data.total;
            }
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

    createCheck(event) {
        const payload = { mode: "create" };
        this.template
            .querySelector("c-related-background-check-cmp")
            .openModal(payload);
    }

    deleteCheck(recordId) {
        deleteRecord(recordId)
            .then(() => {
                this.handleChange();
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error!!",
                        message: error.body.message,
                        variant: "error"
                    })
                );
            });
    }

    handleChange() {
        refreshApex(this.wiredChecks);
    }

    navigateToRecord(recordId, objectName) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: recordId,
                objectApiName: objectName,
                actionName: "view"
            }
        });
    }
}
