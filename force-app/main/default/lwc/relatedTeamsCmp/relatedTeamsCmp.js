import { LightningElement, api, wire, track } from "lwc";
import getRelatedTeams from "@salesforce/apex/TeamController.getRelatedTeams";
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from "@salesforce/apex";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from "lightning/messageService";
import teamForm from "@salesforce/messageChannel/teamForm__c";

const actions = [
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    {
        label: "Name",
        fieldName: 'name',
        type: "button",
        typeAttributes: {
            name: "view",
            label: { fieldName: 'name' },
            variant: "base"
        }
    },
    {
        label: "Dog",
        fieldName: 'dog',
        type: "button",
        typeAttributes: {
            name: "view-dog",
            label: { fieldName: 'dogName' },
            variant: "base"
        }
    },
    {
        label: "Handler",
        fieldName: 'handler',
        type: "button",
        typeAttributes: {
            name: "view-handler",
            label: { fieldName: 'handlerName' },
            variant: "base"
        }
    },
    {
        label: "Client",
        fieldName: 'client',
        type: "button",
        typeAttributes: {
            name: "view-client",
            label: { fieldName: 'clientName' },
            variant: "base"
        }
    },
    { label: "Primary Certification", fieldName: 'certification' },
    { label: "PAT #", fieldName: 'patCount'},
    { label: "PAT Valid Until", fieldName: 'nextPat', type: "date-local" },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedTeams extends NavigationMixin(LightningElement) {
    @api objectApiName;
    @api recordId;
    columns = COLS;
    @track teamsList;

    openModal() {
        const payload = {};
        publish(this.messageContext, teamForm, payload);
    }

    @wire(getRelatedTeams, { recordId: "$recordId" }) teamsLst(result) {
        this.wiredTeamsList = result;
        this.teamsList = null;
        if (result.data && result.data.length > 0) {
            this.teamsList = result.data;
            console.log(this.teamsList);
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

    handleUpdate() {
        refreshApex(this.wiredTeamsList);
    }

    @wire(MessageContext)
    messageContext;

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case "delete":
                this.deleteCons(row);
                break;
            case "edit":
                const payload = { recordId: row.id };
                publish(this.messageContext, teamForm, payload);
                break;
            case "view":
                this.navigateToRecord(row.id);
                break;
            case "view-client":
                this.navigateToRecord(row.client);
                break;
            case "view-handler":
                this.navigateToRecord(row.handler);
                break;
            case "view-dog":
                this.navigateToRecord(row.dog);
                break;
            default:
        }
    }

    navigateToRecord(id) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: id,
                objectApiName: this.object,
                actionName: "view"
            }
        });
    }

    deleteCons(currentRow) {
        let currentRecordID = currentRow.Id;
        deleteRecord(currentRecordID)
            .then((result) => {
                let res = result;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success!!",
                        message: res,
                        variant: "success"
                    })
                );
                this.isErrorMessage = false;
                refreshApex(this.wiredTeamsList);
            })
            .catch((error) => {
                window.console.log("Error ====> " + error);
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