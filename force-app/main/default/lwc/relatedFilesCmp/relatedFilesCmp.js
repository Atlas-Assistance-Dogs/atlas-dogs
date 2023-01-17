import { LightningElement, api, wire, track } from "lwc";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import deleteRecord from "@salesforce/apex/FileController.deleteRecord";
import { refreshApex } from "@salesforce/apex";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import CV_OBJECT from "@salesforce/schema/ContentVersion";
import CATEGORY_FIELD from "@salesforce/schema/ContentVersion.Category__c";
import TYPE_FIELD from "@salesforce/schema/ContentVersion.Type__c";
import DATE_FIELD from "@salesforce/schema/ContentVersion.Date__c";

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
    {
        label: "Category",
        fieldName: 'category',
        sortable: true
    },
    {
        label: "Document Type",
        fieldName: 'type',
        sortable: true
    },
    {
        label: "Document Date",
        fieldName: DATE_FIELD.fieldApiName,
        type: "date-local",
        sortable: true
    },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedFiles extends NavigationMixin(LightningElement) {
    @api objectApiName;
    @api recordId;
    @api viewAll;
    columns = COLS;
    @track data;
    total = 0;
    @track filterItems = [
        {
            label: "Category",
            name: "category",
            placeholder: "Select category",
            value: null,
            options: []
        },
        {
            label: "Type",
            name: "type",
            placeholder: "Select type",
            value: null,
            options: []
        }
    ];

    openModal() {
        this.template.querySelector("c-file-upload-cmp").openModal();
    }
    @wire(getObjectInfo, { objectApiName: CV_OBJECT })
    objectInfo;

    @api
    get max() {
        return this.viewAll ? 10000 : 6;
    }

    bareData;
    @wire(getRelatedFiles, { recordId: "$recordId", max: "$max" }) filesLst(
        result
    ) {
        this.wiredFilesList = result;
        this.data = null;
        if (result.data) {
            this.data = result.data.items.map((info) => {
                let row = Object.assign({}, info.cv);
                row.category = info.category;
                row.type = info.type;
                return row;
            });
            this.bareData = [...this.data]; // save a copy of the data
            if (this.data.length === 0) {
                this.data = null;
                this.total = 0;
            }
            if (!this.viewAll) {
                this.total = result.data.total;
            }
            // fill in category and type options
            const categories = [
                ...new Set(
                    this.data.map((x) => {
                        return {
                            label: x.category,
                            value: x[CATEGORY_FIELD.fieldApiName]
                        };
                    })
                )
            ];
            this.filterItems[0].options = categories; //.map(x => {return {label: x, value: x};});
            const types = [
                ...new Set(
                    this.data.map((x) => {
                        return {
                            label: x.type,
                            value: x[TYPE_FIELD.fieldApiName]
                        };
                    })
                )
            ];
            this.filterItems[1].options = types;
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
                this.deleteCons(row);
                break;
            case "edit":
                const payload = { recordId: row.Id, fileName: row.Title };
                this.template
                    .querySelector("c-file-update-cmp")
                    .openModal(payload);
                break;
            case "view":
                this.navigateToFiles(row);
                break;
            default:
        }
    }

    handleFilter() {
        this.template.querySelector("c-select-option-cmp").open();
    }

    handleFilterSelect(event) {
        const items = event.detail;
        let cloneData = [...this.bareData];
        items.foreach((item) => {
            if (item.value) {
                cloneData = cloneData.filter(
                    (info) => info[item.name] == item.value
                );
            }
        });
        this.data = cloneData;
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
