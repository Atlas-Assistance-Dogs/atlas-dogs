import { LightningElement, api, wire } from "lwc";
import getRelatedLogs from "@salesforce/apex/ContactController.getRelatedLogs";
import { refreshApex } from "@salesforce/apex";

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from "lightning/messageService";
import logForm from "@salesforce/messageChannel/LogForm__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    { label: "Date", fieldName: "date", type: "date", sortable: true },
    { label: "Role", fieldName: "role", sortable: true },
    { label: "Public Access Hours", fieldName: "publicAccessHours" },
    { label: "Other Hours", fieldName: "otherHours" },
    {
        label: "Request Support from Team",
        fieldName: "requestSupportFromTeam"
    },
    { label: "Stress", fieldName: "stress" },
    { label: "Satisfaction", fieldName: "satisfaction" },
    {
        label: "Request Support from Atlas",
        fieldName: "requestSupportFromAtlas"
    },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedLogsCmp extends LightningElement {
    @api recordId;
    columns = COLS;
    data = [
        {
            role: "Client",
            date: new Date(2015, 3, 17),
            publicAccessHours: 10,
            otherHours: 2.5,
            requestSupportFromTeam: true,
            stress: "Some",
            satisfaction: "Lots",
            requestSupportFromAtlas: false,
            id: "0031700001HvS9jAAF"
        }
    ];

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
                this.deleteLog(row.id);
                break;
            case "edit":
                const payload = { mode: "edit", recordId: row.id };
                publish(this.messageContext, logForm, payload);
                break;
        }
    }

    @wire(getRelatedLogs, { contactId: "$recordId" })
    getLogs(result) {
        this.wiredLogs = result;
        if (result.data) {
            console.log(result.data);
            this.data = result.data.map((cl) => {
                return {
                    role: cl.Role__c,
                    date: cl.Log__r.Date__c,
                    publicAccessHours: cl.Log__r.PublicAccessHours__c,
                    otherHours: cl.Log__r.OtherHours__c,
                    requestSupportFromTeam: cl.Log__r.RequestSupportFromTeam__c,
                    stress: cl.Log__r.Stress__c,
                    satisfaction: cl.Log__r.Satisfaction__c,
                    requestSupportFromAtlas:
                        cl.Log__r.RequestSupportFromAtlas__c,
                    id: cl.Id
                };
            });
        } else if (result.error) {
            this.logs = [];
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
        publish(this.messageContext, logForm, payload);
    }

    handleChange() {
        refreshApex(this.wiredLogs);
    }
}
