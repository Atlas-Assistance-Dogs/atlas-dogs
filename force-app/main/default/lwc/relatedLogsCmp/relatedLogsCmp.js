import { LightningElement, api, wire } from "lwc";
import getRelatedLogs from "@salesforce/apex/ContactController.getRelatedLogs";

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

    handleRowAction(event) {}

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
                    id: cl.Contact__c
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

    openModal() {
        this.template.querySelector("c-log-create-cmp").openModal();
    }

    handleCreate() {
        refreshApex(this.wiredLogs);
    }
}
