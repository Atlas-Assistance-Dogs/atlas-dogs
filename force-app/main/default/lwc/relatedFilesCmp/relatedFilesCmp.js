import { LightningElement, api, wire, track } from "lwc";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import deleteLink from "@salesforce/apex/FileController.deleteLink";
import { refreshApex } from "@salesforce/apex";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import CV_OBJECT from "@salesforce/schema/ContentVersion";
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
    relatedObject = CV_OBJECT;
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
    @track filterPills = [];

    openModal() {
        this.template.querySelector("c-file-upload-cmp").openModal();
    }

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
        if (result.data?.items) {
            this.data = result.data.items.map((info) => {
                let row = Object.assign({}, info.cv);
                row.cdl = info.cdl;
                row.category = info.category;
                row.type = info.type;
                return row;
            });
            this.bareData = [...this.data]; // save a copy of the data
            if (this.data.length === 0) {
                this.data = null;
                this.total = 0;
                return;
            }
            if (!this.viewAll) {
                this.total = result.data.total;
            }
            this.fillOptions();
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

    // fill in category and type options
    fillOptions() {
        const categories = [...new Set(this.data.map((x) => x.category))];
        categories.sort();
        this.filterItems[0].options = categories.map((x) => {
            return { label: x, value: x };
        });
        this.filterItems[0].options.unshift({
            label: "No filter",
            value: null
        });

        const types = [...new Set(this.data.map((x) => x.type))];
        types.sort();
        this.filterItems[1].options = types.map((x) => {
            return { label: x, value: x };
        });
        this.filterItems[1].options.unshift({
            label: "No filter",
            value: null
        });
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
        this.filterPills = items.map((item, idx) => {
            if (item.value) {
                cloneData = cloneData.filter(
                    (info) => info[item.name] == item.value
                );
                this.filterItems[idx].value = item.value;
                return {
                    type: "text",
                    label: `${item.value}`,
                    name: `${item.name}:${item.value}`
                };
            }
        }).filter(x => x != null);
        this.data = cloneData;
    }

    handleItemRemove(event) {
        let cloneData = [...this.bareData];
        // Update the filter values
        const keyval = event.detail.item.name.split(':');
        const removedName = keyval[0];
        let filter = this.filterItems.filter(x => x.name === removedName)[0];
        filter.value = null;
        // remove the pill from the container
        const index = event.detail.index;
        this.filterPills.splice(index, 1);
        // Update the list of files
        this.filterPills
            .forEach((item) => {
                const keyval = item.name.split(':');
                const name = keyval[0];
                const value = keyval[1];
                cloneData = cloneData.filter((info) => info[name] == value);
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

    // TODO: Have Trigger delete ContentDocument when all Links to the document are deleted.
    deleteCons(row) {
        deleteLink({ cdl: row.cdl })
            .then((result) => {
                let res = result;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success!!",
                        message: res,
                        variant: "success"
                    })
                );
                refreshApex(this.wiredFilesList);
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
}
