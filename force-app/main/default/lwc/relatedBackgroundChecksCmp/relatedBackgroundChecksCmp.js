import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedChecks from "@salesforce/apex/BackgroundCheckController.getRelatedChecks";
import { deleteRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    {
        label: "Completed Date",
        fieldName: "completedDate",
        type: "date-local",
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
                this.template.querySelector("c-related-background-check-cmp").openModal(payload);
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

    @wire(getRelatedChecks, { contactId: "$recordId", max: "$max" })
    getChecks(result) {
        this.wiredChecks = result;
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
}
