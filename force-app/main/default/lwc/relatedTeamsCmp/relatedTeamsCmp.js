import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedTeams from "@salesforce/apex/TeamController.getRelatedTeams";
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from "@salesforce/apex";

import CERTIFICATION_FIELD from "@salesforce/schema/Team__c.PrimaryCertification__c";
import DATE_FIELD from "@salesforce/schema/Team__c.PatValidUntil__c";
import DOG_FIELD from "@salesforce/schema/Team__c.Dog__c";
import NAME_FIELD from "@salesforce/schema/Team__c.Name";
import PAT_COUNT_FIELD from "@salesforce/schema/Team__c.PatCount__c";
import CLIENT_FIELD from "@salesforce/schema/Team__c.Client__c";
import HANDLER_FIELD from "@salesforce/schema/Team__c.Handler__c";

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
        label: "Dog",
        type: "button",
        typeAttributes: {
            name: "dog",
            label: { fieldName: "dogName" },
            variant: "base"
        }
    },
    {
        label: "Handler",
        type: "button",
        typeAttributes: {
            name: "handler",
            label: { fieldName: "handlerName" },
            variant: "base"
        }
    },
    {
        label: "Client",
        type: "button",
        typeAttributes: {
            name: "client",
            label: { fieldName: "clientName" },
            variant: "base"
        }
    },
    { label: "Primary Certification", fieldName: CERTIFICATION_FIELD.fieldApiName },
    { label: "PAT #", fieldName: PAT_COUNT_FIELD.fieldApiName },
    { label: "PAT Valid Until", fieldName: DATE_FIELD.fieldApiName, type: "date-local" },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedTeams extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    @api viewAll;
    columns = COLS;
    data = [];
    total = 0;
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
                this.deleteCons(row.Id);
                break;
            case "edit":
                const payload = { recordId: row.Id };
                this.template
                    .querySelector("c-team-form-cmp")
                    .openModal(payload);
                break;
            case "goto":
                this.navigateToRecord(row.Id);
                break;
            case "client":
                this.navigateToRecord(row[CLIENT_FIELD.fieldApiName]);
                break;
            case "handler":
                this.navigateToRecord(row[HANDLER_FIELD.fieldApiName]);
                break;
            case "dog":
                this.navigateToRecord(row[DOG_FIELD.fieldApiName]);
                break;
        }
    }

    navigateToRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: recordId,
                actionName: "view"
            }
        });
    }
    get max() {
        return this.viewAll ? 10000 : 6;
    }

    @wire(getRelatedTeams, { recordId: "$recordId", max: "$max" })
    teamsLst(result) {
        this.wiredTeamsList = result;
        this.data = null;
        if (result.data && result.data.items.length > 0) {
            this.data = result.data.items.map(row => {
                var team = Object.assign({}, row.team);
                team.clientName = row.clientName;
                team.handlerName = row.handlerName;
                team.dogName = row.dogName;
                return team;
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

    createTeam(event) {
        const payload = { mode: "create" };
        if (this.objectApiName !== "Contact") {
            payload.dogId = this.recordId;
        }
        this.template
            .querySelector("c-team-form-cmp")
            .openModal(payload);
    }

    deleteCons(recordId) {
        deleteRecord(recordId)
            .then(() => {
                let res = result;

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
        refreshApex(this.wiredTeamsList);
    }
}