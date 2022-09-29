import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedLogs from "@salesforce/apex/LogController.getRelatedLogs";
import deleteRelatedLog from "@salesforce/apex/LogController.deleteLog";
import { refreshApex } from "@salesforce/apex";

import ATLAS_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromAtlas__c";
import STRESS_FIELD from "@salesforce/schema/Log__c.Stress__c";
import CLIENT_FIELD from "@salesforce/schema/Log__c.Client__c";
import CLIENT_REFERENCE from "@salesforce/schema/Log__c.Client__r.Name";
import SUBMITTER_FIELD from "@salesforce/schema/Log__c.Submitter__c";
import FACILITATOR_FIELD from "@salesforce/schema/Log__c.Facilitator__c";
import DATE_FIELD from "@salesforce/schema/Log__c.Date__c";
import OTHER_HOURS_FIELD from "@salesforce/schema/Log__c.OtherHours__c";
import PAH_FIELD from "@salesforce/schema/Log__c.PublicAccessHours__c";
import SATISFACTION_FIELD from "@salesforce/schema/Log__c.Satisfaction__c";
import TEAM_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromTeam__c";

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from "lightning/messageService";
import logForm from "@salesforce/messageChannel/logForm__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    {
        label: "Date",
        fieldName: DATE_FIELD.fieldApiName,
        type: "date-local",
        sortable: true
    },
    { label: "Role", fieldName: "roles", sortable: true, initialWidth: 140 },
    {
        label: "PA Hours",
        fieldName: PAH_FIELD.fieldApiName,
        type: "number",
        editable: "true"
    },
    {
        label: "Other Hours",
        fieldName: OTHER_HOURS_FIELD.fieldApiName,
        type: "number",
        editable: "true"
    },
    {
        label: "Team Support?",
        fieldName: TEAM_SUPPORT_FIELD.fieldApiName,
        type: "boolean"
    },
    { label: "Stress", fieldName: STRESS_FIELD.fieldApiName },
    { label: "Satisfaction", fieldName: SATISFACTION_FIELD.fieldApiName },
    {
        label: "Atlas Support?",
        fieldName: ATLAS_SUPPORT_FIELD.fieldApiName,
        type: "boolean"
    },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedLogsCmp extends NavigationMixin(LightningElement) {
    @api recordId;
    @api max = 6;
    columns = COLS;
    data = [];

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
                this.deleteLog(row.Id);
                break;
            case "edit":
                const payload = {
                    mode: "edit",
                    recordId: row.Id,
                    roles: row.roles,
                    recordTypeId: row.RecordTypeId
                };
                publish(this.messageContext, logForm, payload);
                break;
        }
    }

    @wire(getRelatedLogs, { contactId: "$recordId", max: "$max" })
    getLogs(result) {
        this.wiredLogs = result;
        this.data = null;
        if (result.data && result.data.items) {
            this.data = result.data.items.map((log) => {
                var newLog = Object.assign({}, log);
                newLog["roles"] = this.getRoles(log);
                return newLog;
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

    getRoles(log) {
        var roles = [];
        if (log[CLIENT_FIELD.fieldApiName] === this.recordId) {
            roles.push("Client");
        }
        if (log[SUBMITTER_FIELD.fieldApiName] === this.recordId) {
            roles.push("Submitter");
        }
        if (log[FACILITATOR_FIELD.fieldApiName] === this.recordId) {
            roles.push("Team Facilitator");
        }
        return roles.join(";");
    }

    createLog(event) {
        const payload = { mode: "create" };
        publish(this.messageContext, logForm, payload);
    }

    deleteLog(recordId) {
        deleteRelatedLog({ recordId: recordId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success",
                        message: 'Log Deleted',
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
        refreshApex(this.wiredLogs);
    }

    handleViewAll() {
        // Navigate to a specific component.
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__LogsCmp'
            },
            state: {
                c__id: this.recordId
            }
        });
    }
}
