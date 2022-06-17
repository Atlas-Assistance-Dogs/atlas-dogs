import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedCeus from "@salesforce/apex/ContinuingEducationUnitController.getRelatedCeus";
import deleteCeu from "@salesforce/apex/ContinuingEducationUnitController.deleteCeu";
import { refreshApex } from "@salesforce/apex";

import AUTHORITY_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.Authority__c";
import AUTHORITY_OTHER_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.AuthorityOther__c";
import DATE_COMPLETED_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.DateCompleted__c";
import PROGRAM_DATE_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.ProgramDate__c";
import PROGRAM_HOURS_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.ProgramHours__c";
import ROLE_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.Role__c";
import STATUS_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.Status__c";

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from "lightning/messageService";
import ceuForm from "@salesforce/messageChannel/ceuForm__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    { label: "Authority", fieldName: "authority" },
    {
        label: "Program Date",
        fieldName: PROGRAM_DATE_FIELD.fieldApiName,
        type: "date"
    },
    {
        label: "Date Completed",
        fieldName: DATE_COMPLETED_FIELD.fieldApiName,
        type: "date"
    },
    {
        label: "Program Hours",
        fieldName: PROGRAM_HOURS_FIELD.fieldApiName,
        type: "number"
    },
    { label: "Role", fieldName: ROLE_FIELD.fieldApiName },
    { label: "Status", fieldName: STATUS_FIELD.fieldApiName },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedCeusCmp extends NavigationMixin(LightningElement) {
    @api recordId;
    columns = COLS;
    data = [];
    wiredCeus;

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
                this.deleteCeu(row.Id);
                break;
            case "edit":
                const payload = {
                    authority: row.Authority__c,
                    recordId: row.Id
                };
                publish(this.messageContext, ceuForm, payload);
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

    @wire(getRelatedCeus, { contactId: "$recordId" })
    getCeus(result) {
        this.wiredCeus = result;
        this.data = null;
        if (result.data) {
            this.data = result.data.map((ceu) => {
                var newCeu = Object.assign({}, ceu);
                newCeu["authority"] = ceu[AUTHORITY_FIELD.fieldApiName];
                if (newCeu.authority === "Other") {
                    newCeu.authority = ceu[AUTHORITY_OTHER_FIELD.fieldApiName];
                }
                return newCeu;
            });
            if (this.data.length === 0) {
                this.data = null;
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

    createCeu(event) {
        const payload = { mode: "create" };
        publish(this.messageContext, ceuForm, payload);
    }

    deleteCeu(recordId) {
        deleteCeu({ recordId: recordId })
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
        refreshApex(this.wiredCeus);
    }
}
