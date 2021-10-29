import { LightningElement, api, wire, track } from "lwc";
import retrieveAllData from "@salesforce/apex/FileController.retrieveAllData";
import deleteRecord from "@salesforce/apex/FileController.deleteRecord";
import { refreshApex } from "@salesforce/apex";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const actions = [
    { label: "Show details", name: "show_details" },
    { label: "Edit", name: "edit" },
    { label: "Delete", name: "delete" }
];

const COLS = [
    {
        label: "File Name",
        fieldName: "Title",
        type: "fileUpload",
        typeAttributes: {
            acceptedFileFormats: ".jpg,.jpeg,.pdf,.png",
            recordId: { fieldName: "Id" }
        }
    },
    { label: "Category", fieldName: "Category__c" },
    { label: "Document Type", fieldName: "Type__c" },
    { label: "Document Date", fieldName: "CreatedDate", type: "date" },
    { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedFiles extends LightningElement {
    @api objectApiName;
    @api recordId;
    columns = COLS;
    @track fileUploadList;

    openModal() {
        this.template.querySelector("c-document-upload-cmp").openModal();
    }

    @wire(retrieveAllData, { recordId: "$recordId" }) filesLst(result) {
        this.wiredFilesList = result;
        if (result.data) {
            this.fileUploadList = result.data;
        } else if (result.error) {
            this.fileUploadList = [];
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error!!",
                    message: result.error.message,
                    variant: "error"
                })
            );
        }
    }

    handleConfirm() {
        refreshApex(this.wiredFilesList);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case "delete":
                this.deleteCons(row);
                break;
            // TODO: add edit document record
            case "edit":
                break;
            case "show_details":
                this.navigateToFiles(row);
                break;
            default:
        }
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

    deleteCons(currentRow) {
        let currentRecordID = currentRow.ContentDocumentId;
        deleteRecord({ docId: currentRecordID })
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
                refreshApex(this.wiredFilesList);
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
