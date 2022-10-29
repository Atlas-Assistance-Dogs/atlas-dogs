import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedLogs from "@salesforce/apex/PuppyLogController.getRelatedLogs";
import { deleteRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";

import ADDITIONAL_FIELD from "@salesforce/schema/PuppyLog__c.AdditionalInformation__c";
import DATE_FIELD from "@salesforce/schema/PuppyLog__c.Date__c";
import DOG_FIELD from "@salesforce/schema/PuppyLog__c.Dog__c";
import NAME_FIELD from "@salesforce/schema/PuppyLog__c.Name";
import RAISER_FIELD from "@salesforce/schema/PuppyLog__c.Raiser__c";
import ATLAS_SUPPORT_FIELD from "@salesforce/schema/PuppyLog__c.RequestSupportFromAtlas__c";

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
        }
    },
    {
        label: "Date",
        fieldName: DATE_FIELD.fieldApiName,
        type: "date-local",
        sortable: true
    },
    {
        label: "Raiser",
        type: "button",
        typeAttributes: {
            name: "raiser",
            label: { fieldName: "raiserName" },
            variant: "base"
        }
    },
    {
        label: "Dog",
        type: "button",
        typeAttributes: {
            name: "dog",
            label: { fieldName: "dogName" },
            variant: "base"
        }
    },
    {
        label: "Comment",
        fieldName: ADDITIONAL_FIELD.fieldApiName,
        sortable: true
    },
    {
        label: "Support?",
        fieldName: ATLAS_SUPPORT_FIELD.fieldApiName,
        sortable: true,
        type: "boolean"
    },
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

export default class RelatedPuppyLogsCmp extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    @api viewAll;
    columns = COLS;
    data = [];
    total = 0;
    wiredLogs;

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
                this.deleteLog(row.Id);
                break;
            case "edit":
                const payload = { mode: "edit", recordId: row.Id };
                this.template
                    .querySelector("c-related-puppy-log-cmp")
                    .openModal(payload);
                break;
            case "goto":
                this.navigateToRecord(row.Id, this.objectApiName);
                break;
            case "raiser":
                this.navigateToRecord(row[RAISER_FIELD.fieldApiName], RAISER_FIELD.objectApiName);
                break;
            case "dog":
                this.navigateToRecord(row[DOG_FIELD.fieldApiName], DOG_FIELD.objectApiName);
                break;
            case "view":
                this.navigateToFiles(row);
                break;
        }
    }

    navigateToRecord(recordId, objectName) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: recordId,
                actionName: "view"
            }
        });
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

    get max() {
        return this.viewAll ? 10000 : 6;
    }

    @wire(getRelatedLogs, { recordId: "$recordId", max: "$max" })
    getLogs(result) {
        this.wiredLogs = result;
        this.data = null;
        if (result.data) {
            this.data = result.data.items.map(info => {
                var log = Object.assign({}, info.log);
                log.fileName = info.fileName;
                log.documentId = info.documentId;
                log.noFile = info.noFile;
                log.raiserName = info.raiserName;
                log.dogName = info.dogName;
                log[ADDITIONAL_FIELD.fieldApiName] =
                    log[ADDITIONAL_FIELD.fieldApiName]?.replace(/(<([^>]+)>)/gi, "");
                return log;
            });
            if (this.data.length === 0) {
                this.data = null;
                this.total = 0;
            }
            if (this.max < 15) {
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

    createLog(event) {
        const payload = { mode: "create" };
        if (this.objectApiName == "Contact") {
            payload.contactId = this.recordId;
        } else {
            payload.dogId = this.recordId;
        }
        this.template
            .querySelector("c-related-puppy-log-cmp")
            .openModal(payload);
    }

    deleteLog(recordId) {
        deleteRecord(recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Record Deleted"
                    })
                );
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
        refreshApex(this.wiredLogs);
    }
}
