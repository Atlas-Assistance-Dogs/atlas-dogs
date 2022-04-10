import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedCeus from "@salesforce/apex/ContinuingEducationUnitController.getRelatedCeus";
import deleteCeu from "@salesforce/apex/ContinuingEducationUnitController.deleteCeu";
import { refreshApex } from "@salesforce/apex";

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from "lightning/messageService";
import ceuForm from "@salesforce/messageChannel/CeuForm__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    { label: "Authority", fieldName: "authority" },
    { label: "Program Date", fieldName: "ProgramDate__c", type: "date" },
    { label: "Date Completed", fieldName: "DateCompleted__c", type: "date" },
    { label: "Program Hours", fieldName: "ProgramHours__c", type: "number" },
    { label: "Role", fieldName: "Role__c" },
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
                newCeu["authority"] = ceu.Authority__c;
                if (newCeu.authority === "Other") {
                    newCeu.authority = ceu.AuthorityOther__c;
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
