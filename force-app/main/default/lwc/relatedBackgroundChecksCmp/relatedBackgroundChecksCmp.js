import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedChecks from "@salesforce/apex/BackgroundCheckController.getRelatedChecks";
import deleteCheck from "@salesforce/apex/BackgroundCheckController.deleteCheck";
import { refreshApex } from "@salesforce/apex";

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from "lightning/messageService";
import backgroundCheckForm from "@salesforce/messageChannel/BackgroundCheckForm__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    {
        label: "Completed Date",
        fieldName: "completedDate",
        type: "date",
        sortable: true
    },
    { label: "Status", fieldName: "status", sortable: true },
    {
        label: "File",
        type: "button",
        typeAttributes: {
            name: "view",
            label: { fieldName: "fileName" },
            variant: "base",
            iconName: "utility:file",
            iconPosition: "left"
        }
    },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedBackgroundChecksCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    columns = COLS;
    data = [];
    wiredChecks;

    @wire(MessageContext)
    messageContext;

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
                this.deleteCheck(row.recordId);
                break;
            case "edit":
                const payload = { mode: "edit", recordId: row.recordId };
                publish(this.messageContext, backgroundCheckForm, payload);
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

    @wire(getRelatedChecks, { contactId: "$recordId" })
    getChecks(result) {
        this.wiredChecks = result;
        this.data = null;
        if (result.data) {
            this.data = result.data;
            if (this.data.length === 0) {
                this.data = null;
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
        publish(this.messageContext, backgroundCheckForm, payload);
    }

    deleteCheck(recordId) {
        deleteCheck({ recordId: recordId })
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
}