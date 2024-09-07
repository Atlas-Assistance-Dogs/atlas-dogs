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
        label: "Type",
        fieldName: 'FileType',
        sortable: true
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
    @api numRecords = 6;
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

    openModal() {
        this.template.querySelector("c-file-upload-cmp").openModal();
    }
 
    @api
    get max() {
        return this.viewAll ? 10000 : this.numRecords;
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
        const categories = [
            ...new Set(
                this.data.map((x) => x.category)
            )
        ];
        categories.sort();
        this.filterItems[0].options = categories.map(x => { return { label: x, value: x }; });
        this.filterItems[0].options.unshift({ label: "No filter", value: null });

        const types = [
            ...new Set(
                this.data.map((x) => x.type)
            )
        ];
        types.sort();
        this.filterItems[1].options = types.map((x) => {
            return { label: x, value: x };
        });
        this.filterItems[1].options.unshift({ label: "No filter", value: null });
    }

    handleUpdate() {
        refreshApex(this.wiredFilesList);
    }

    defaultSortDirection = "asc";
    sortDirection = "asc";
    sortedBy;

    handleSort(event) {
        var fieldName = event.detail.fieldName;
        var sortDirection = event.detail.sortDirection;
        const cloneData = [...this.data];

        cloneData.sort((a, b) => {
            const x1 = a[fieldName] ?? '';
            const x2 = b[fieldName] ?? '';
            const asc = x1 > x2 ? 1 : x1 < x2 ? -1 : 0;
            return sortDirection === "asc" ? asc : asc * -1});
        this.data = cloneData;
        this.sortedBy = fieldName;
        this.sortDirection = sortDirection;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case "delete":
                this.deleteCons(row);
                break;
            case "edit":
                const payload = { recordId: row.Id, fileName: row.Title, fileType: row.FileType };
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
        items.forEach((item, idx) => {
            if (item.value) {
                cloneData = cloneData.filter(
                    (info) => info[item.name] == item.value
                );
                this.filterItems[idx].value = item.value;
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

    // TODO: Have Trigger delete ContentDocument when all Links to the document are deleted.
    deleteCons(row) {
        deleteLink({cdl: row.cdl})
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
