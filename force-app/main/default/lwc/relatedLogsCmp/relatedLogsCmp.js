import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedLogs from "@salesforce/apex/LogController.getRelatedLogs";
import { deleteRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";

import ATLAS_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromAtlas__c";
import CLIENT_FIELD from "@salesforce/schema/Log__c.Client__c";
import CLIENT_STRESS_FIELD from "@salesforce/schema/Log__c.ClientStress__c";
import DATE_FIELD from "@salesforce/schema/Log__c.Date__c";
import DETAILS_FIELD from "@salesforce/schema/Log__c.Details__c";
import FACILITATOR_FIELD from "@salesforce/schema/Log__c.Facilitator__c";
import NAME_FIELD from "@salesforce/schema/Log__c.Name";
import OTHER_HOURS_FIELD from "@salesforce/schema/Log__c.OtherHours__c";
import PAH_FIELD from "@salesforce/schema/Log__c.PublicAccessHours__c";
import SATISFACTION_FIELD from "@salesforce/schema/Log__c.Satisfaction__c";
import STRESS_FIELD from "@salesforce/schema/Log__c.Stress__c";
import TEAM_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromTeam__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = {
    name: {
        label: "Name",
        fieldName: NAME_FIELD.fieldApiName,
        type: "button",
        typeAttributes: {
            name: "view",
            label: { fieldName: NAME_FIELD.fieldApiName },
            variant: "base"
        },
        sortable: true
    },
    date: {
        label: "Date",
        fieldName: DATE_FIELD.fieldApiName,
        type: "date-local",
        sortable: true
    },
    client: {
        label: "Client",
        fieldName: CLIENT_FIELD.fieldApiName,
        type: "button",
        typeAttributes: {
            name: "client",
            label: { fieldName: "clientName" },
            variant: "base"
        },
        sortable: true
    },
    facilitator: {
        label: "Facilitator",
        fieldName: FACILITATOR_FIELD.fieldApiName,
        type: "button",
        typeAttributes: {
            name: "facilitator",
            label: { fieldName: "facilitatorName" },
            variant: "base"
        },
        sortable: true
    },
    hours: {
        label: "PA Hours",
        fieldName: PAH_FIELD.fieldApiName,
        type: "number",
        editable: "true"
    },
    otherHours: {
        label: "Other Hours",
        fieldName: OTHER_HOURS_FIELD.fieldApiName,
        type: "number",
        editable: "true"
    },
    team: {
        label: "Team Support?",
        fieldName: TEAM_SUPPORT_FIELD.fieldApiName,
        type: "boolean"
    },
    stress: { label: "Stress", fieldName: STRESS_FIELD.fieldApiName },
    clientStress: {
        label: "Client Stress",
        fieldName: CLIENT_STRESS_FIELD.fieldApiName
    },
    satisfaction: {
        label: "Satisfaction",
        fieldName: SATISFACTION_FIELD.fieldApiName
    },
    atlas: {
        label: "Atlas Support?",
        fieldName: ATLAS_SUPPORT_FIELD.fieldApiName,
        type: "boolean"
    },
    details: {
        label: "Details",
        fieldName: DETAILS_FIELD.fieldApiName
    },
    action: { type: "action", typeAttributes: { rowActions: actions } }
};

export default class RelatedLogsCmp extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    @api viewAll;
    @api max; // needed for previous version
    data = [];

    get columns() {
        if (this.recordType === "Client") {
            return [
                COLS.name,
                COLS.date,
                COLS.client,
                COLS.facilitator,
                COLS.hours,
                COLS.otherHours,
                COLS.team,
                COLS.stress,
                COLS.satisfaction,
                COLS.atlas,
                COLS.details,
                COLS.action
            ];
        }
        return [
            COLS.name,
            COLS.date,
            COLS.client,
            COLS.facilitator,
            COLS.hours,
            COLS.otherHours,
            COLS.team,
            COLS.clientStress,
            COLS.atlas,
            COLS.details,
            COLS.action
        ];
    }

    get title() {
        return this.recordType === "Client"
            ? "Client Logs"
            : "Team Facilitator Logs";
    }

    get auraCmpName() {
        return this.recordType === "Client"
            ? "AllClientLogsCmp"
            : "AllFacilitatorLogsCmp";
    }

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
                this.deleteLog(row.Id);
                break;
            case "edit":
                const payload = {
                    mode: "edit",
                    recordId: row.Id,
                    recordType: this.recordType === "Client" ? "Client" : "Team Facilitator"
                };
                this.template
                    .querySelector("c-log-form-cmp")
                    .openModal(payload);
                break;
            case "view":
                this.navigateToRecord(row.Id, this.objectApiName);
                break;
            case "client":
                this.navigateToRecord(row.Client__c, "Contact");
                break;
            case "facilitator":
                this.navigateToRecord(row.Facilitator__c, "Contact");
                break;
        }
    }

    get max() {
        return this.viewAll ? 10000 : 6;
    }

    @wire(getRelatedLogs, {
        recordId: "$recordId",
        recordType: "$recordType",
        max: "$max"
    })
    getLogs(result) {
        this.wiredData = result;
        this.data = null;
        if (result.data && result.data.items) {
            this.data = result.data.items.map((info) => {
                var log = Object.assign({}, info.log);
                log.clientName = info.clientName;
                log.facilitatorName = info.facilitatorName;
                log[DETAILS_FIELD.fieldApiName] = log[DETAILS_FIELD.fieldApiName].replace(/(<([^>]+)>)/gi, "");
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

    createLog() {
        const typeName =
            this.recordType === "Client" ? "Client" : "Team Facilitator";
        const payload = { mode: "create", recordType: typeName };
        this.template.querySelector("c-log-form-cmp").openModal(payload);
    }

    deleteLog(recordId) {
        deleteRecord(recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success",
                        message: "Log Deleted",
                        variant: "success"
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
        refreshApex(this.wiredData);
    }

    navigateToRecord(recordId, objectName) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: recordId,
                objectApiName: objectName,
                actionName: "view"
            }
        });
    }
}
