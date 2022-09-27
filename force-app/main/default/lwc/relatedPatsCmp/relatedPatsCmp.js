import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getRelatedPats from "@salesforce/apex/PublicAccessTestController.getRelatedPats";
import deletePat from "@salesforce/apex/PublicAccessTestController.deletePat";
import { refreshApex } from "@salesforce/apex";

import DATE_FIELD from "@salesforce/schema/PublicAccessTest__c.DateCompleted__c";
import LOCATION_FIELD from "@salesforce/schema/PublicAccessTest__c.Location__c";
import STATUS_FIELD from "@salesforce/schema/PublicAccessTest__c.Status__c";
import TYPE_FIELD from "@salesforce/schema/PublicAccessTest__c.Type__c";

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from "lightning/messageService";
import patForm from "@salesforce/messageChannel/patForm__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    {
        label: "Date Completed",
        fieldName: DATE_FIELD.fieldApiName,
        type: "date",
        sortable: true
    },
    {
        label: "Location",
        fieldName: LOCATION_FIELD.fieldApiName
    },
    {
        label: "Status",
        fieldName: STATUS_FIELD.fieldApiName
    },
    { label: "Type", fieldName: TYPE_FIELD.fieldApiName },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedPatsCmp extends NavigationMixin(LightningElement) {
    @api recordId;
    @api max = 6;
    columns = COLS;
    data = [];
    total = 0;

    @wire(MessageContext)
    messageContext;

    defaultSortDirection = "asc";
    sortDirection = "asc";
    sortedBy;

    // Used to sort the 'Role' column
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
                this.deletePat(row.Id);
                break;
            case "edit":
                const payload = {
                    mode: "edit",
                    recordId: row.Id,
                    status: row.Status__c
                };
                publish(this.messageContext, patForm, payload);
                break;
            case "dog":
                this[NavigationMixin.Navigate]({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: row.Dog__c,
                        actionName: "view"
                    }
                });
                break;
        }
    }

    @wire(getRelatedPats, { recordId: "$recordId", max: "$max" })
    getPats(result) {
        this.wiredPats = result;
        this.data = null;
        if (result.data) {
            this.data = result.data.items.map((pat) => {
                var xpat = Object.assign({}, pat);
                return xpat;
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

    createPat(event) {
        const payload = {};
        publish(this.messageContext, patForm, payload);
    }

    deletePat(recordId) {
        deletePat({ recordId: recordId })
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
        refreshApex(this.wiredPats);
    }

    handleViewAll() {
        // Navigate to a specific component.
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__PublicAccessTestsCmp'
            },
            state: {
                c__id: this.recordId
            }
        });
    }
}