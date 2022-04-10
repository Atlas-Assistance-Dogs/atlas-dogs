import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import createCeu from "@salesforce/apex/ContinuingEducationUnitController.createCeu";
import updateCeu from "@salesforce/apex/ContinuingEducationUnitController.updateCeu";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import { refreshApex } from "@salesforce/apex";

import AUTHORITY_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.Authority__c";
import AUTHORITY_OTHER_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.AuthorityOther__c";
import COMMENTS_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.Comments__c";
import DATE_COMPLETED_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.DateCompleted__c";
import DATE_SUBMITTED_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.DateSubmitted__c";
import PROGRAM_DATE_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.ProgramDate__c";
import PROGRAM_HOURS_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.ProgramHours__c";
import PROGRAM_TITLE_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.ProgramTitle__c";
import QUANTITY_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.Quantity__c";
import ROLE_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.Role__c";
import STATUS_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.Status__c";
import TRAINER_FIELD from "@salesforce/schema/ContinuingEducationUnit__c.Trainer__c";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import ceuForm from "@salesforce/messageChannel/CeuForm__c";

const COLS = [
    {
        label: "Files",
        type: "button",
        typeAttributes: {
            name: "view",
            label: { fieldName: "name" },
            variant: "base",
            iconName: "utility:file",
            iconPosition: "left"
        }
    }
];

export default class CeuFormCmp extends NavigationMixin(LightningElement) {
    @api contactId;
    recordId;
    title = "Continuing Education Unit";
    mode = "create";
    relatedFiles = null;
    wiredFilesList;
    object = AUTHORITY_FIELD.objectApiName;
    fields = {
        authority: AUTHORITY_FIELD,
        authorityOther: AUTHORITY_OTHER_FIELD,
        comments: COMMENTS_FIELD,
        dateCompleted: DATE_COMPLETED_FIELD,
        dateSubmitted: DATE_SUBMITTED_FIELD,
        programDate: PROGRAM_DATE_FIELD,
        programHours: PROGRAM_HOURS_FIELD,
        programTitle: PROGRAM_TITLE_FIELD,
        quantity: QUANTITY_FIELD,
        role: ROLE_FIELD,
        status: STATUS_FIELD,
        trainer: TRAINER_FIELD
    };
    authority = "Atlas";

    columns = COLS;
    get acceptedFormats() {
        return [
            ".pdf",
            ".png",
            ".jpg",
            ".jpeg",
            ".doc",
            ".docx",
            ".txt",
            ".xlsx",
            ".xls",
            ".zip"
        ];
    }

    @api
    openModal() {
        this.template.querySelector("c-modal-cmp").openModal();
    }

    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleClose() {}

    get isAuthorityOther() {
        return this.authority === "Other";
    }

    handleAuthorityChange(event) {
        this.authority = event.target.value;
    }

    handleSubmit(event) {
        event.preventDefault();
        let fields = [
            ...this.template.querySelectorAll("lightning-input-field")
        ];
        var record = fields.reduce(
            (a, x) => ({ ...a, [x.fieldName]: x.value }),
            {}
        );
        record.Id = this.recordId;
        record.Trainer__c = this.contactId;
        if (this.mode === "create") {
            this.createNewCeu(record);
        } else {
            this.editCeu(record);
        }
    }

    @wire(MessageContext)
    messageContext;

    // Create a new log
    createNewCeu(record) {
        createCeu({
            record: record,
            documentIds: this.relatedFiles?.map((file) => file.documentId)
        })
            .then(() => {
                this.dispatchEvent(new CustomEvent("changed"));
                this.closeModal();
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

    // Update an existing PAT
    editCeu(record) {
        updateCeu({ record: record })
            .then(() => {
                this.dispatchEvent(new CustomEvent("changed"));
                this.closeModal();
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

    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                ceuForm,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    // Handler for message received by component
    handleMessage(message) {
        this.recordId = message.recordId;
        if (this.recordId) {
            refreshApex(this.wiredFilesList);
        } else {
            this.relatedFiles = null;
        }
        this.mode = message.recordId ? "edit" : "create";
        this.authority = message.authority;
        this.openModal();
    }

    // Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }

    @wire(getRelatedFiles, { recordId: "$recordId" }) filesLst(result) {
        this.wiredFilesList = result;
        this.relatedFiles = null;
        if (result.data) {
            this.relatedFiles = result.data.map((data) => {
                return {
                    name: data.Title,
                    documentId: data.ContentDocumentId
                };
            });
        } else if (result.error) {
            this.relatedFiles = null;
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
        refreshApex(this.wiredFilesList);
    }

    handleUploadFinished(event) {
        this.isErrorMessage = false;
        this.message = "File Uploaded Successfully";
        this.relatedFiles = this.relatedFiles.concat(event.detail.files);
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case "view":
                this.navigateToFiles(row);
                break;
            default:
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
}
