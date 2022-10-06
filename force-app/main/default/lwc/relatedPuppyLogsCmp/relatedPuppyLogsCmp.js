import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedLogs from "@salesforce/apex/PuppyLogController.getRelatedLogs";
import { deleteRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    {
        label: "Date",
        fieldName: "logDate",
        type: "date-local",
        sortable: true
    },
    { label: "Raiser", fieldName: "raiserName", sortable: true },
    { label: "Dog", fieldName: "dogName", sortable: true },
    {
        label: "Support?",
        fieldName: "support",
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

export default class RelatedPuppyLogsCmp extends NavigationMixin(
    LightningElement
) {
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
                this.deleteLog(row.recordId);
                break;
            case "edit":
                const payload = { mode: "edit", recordId: row.recordId };
                this.template
                    .querySelector("c-related-puppy-log-cmp")
                    .openModal(payload);
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

    get max() {
        return this.viewAll ? 10000 : 6;
    }

    @wire(getRelatedLogs, { recordId: "$recordId", max: "$max" })
    getLogs(result) {
        this.wiredLogs = result;
        this.data = null;
        if (result.data) {
            this.data = result.data.items;
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
