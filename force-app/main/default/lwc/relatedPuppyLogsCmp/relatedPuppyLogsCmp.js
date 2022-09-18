import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getLatestRelatedLogs from "@salesforce/apex/PuppyLogController.getLatestRelatedLogs";
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from "@salesforce/apex";

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from "lightning/messageService";
import puppyLogForm from "@salesforce/messageChannel/puppyLogForm__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    {
        label: "Date",
        fieldName: 'logDate',
        type: "date-local",
        sortable: true
    },
    { label: "Raiser", fieldName: 'raiserName', sortable: true },
    { label: "Dog", fieldName: 'dogName', sortable: true },
    { label: "Support?", fieldName: 'support', sortable: true },
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
    columns = COLS;
    data = [];
    total = 0;
    wiredLogs;

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
                publish(this.messageContext, puppyLogForm, payload);
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

    @wire(getLatestRelatedLogs, { recordId: "$recordId" })
    getLogs(result) {
        this.wiredLogs = result;
        this.data = null;
        if (result.data) {
            this.data = result.data.items;
            if (this.data.length === 0) {
                this.data = null;
                this.total = 0;
            }
            this.total = result.data.total;
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
        publish(this.messageContext, puppyLogForm, payload);
    }

    deleteLog(recordId) {
        deleteRecord({ recordId: recordId })
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
        refreshApex(this.wiredLogs);
    }

    handleViewAll() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: "So you want to see them all",
                message: "I'm working on it"
            })
        );

    }
}