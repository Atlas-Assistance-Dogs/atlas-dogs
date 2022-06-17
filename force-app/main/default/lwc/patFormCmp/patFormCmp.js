import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import createPat from "@salesforce/apex/PublicAccessTestController.createPat";
import updatePat from "@salesforce/apex/PublicAccessTestController.updatePat";
import { refreshApex } from "@salesforce/apex";

import ASSESSOR_FIELD from "@salesforce/schema/PublicAccessTest__c.Assessor__c";
import ASSESSOR_COMMENTS_FIELD from "@salesforce/schema/PublicAccessTest__c.AssessorComments__c";
import DATE_FIELD from "@salesforce/schema/PublicAccessTest__c.DateCompleted__c";
import HANDLER_FIELD from "@salesforce/schema/Team__c.Handler__c";
import LOCATION_FIELD from "@salesforce/schema/PublicAccessTest__c.Location__c";
import REVIEW_COMMENTS_FIELD from "@salesforce/schema/PublicAccessTest__c.ReviewComments__c";
import STATUS_FIELD from "@salesforce/schema/PublicAccessTest__c.Status__c";
import TEAM_FIELD from "@salesforce/schema/PublicAccessTest__c.Team__c";
import TYPE_FIELD from "@salesforce/schema/PublicAccessTest__c.Type__c";
import VALID_UNTIL_FIELD from "@salesforce/schema/PublicAccessTest__c.ValidUntil__c";

import PAT_DUE_FIELD from "@salesforce/schema/Team__c.PatValidUntil__c";
import PAT_COUNT_FIELD from "@salesforce/schema/Team__c.PatCount__c";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import patForm from "@salesforce/messageChannel/patForm__c";

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

export default class PatFormCmp extends NavigationMixin(LightningElement) {
    @api teamId;
    recordId;
    title = "Public Access Test Record";
    passed = false;
    mode = "create";
    relatedFiles = null;
    wiredFilesList;
    object = ASSESSOR_FIELD.objectApiName;
    teamObject = PAT_COUNT_FIELD.objectApiName;
    fields = {
        assessor: ASSESSOR_FIELD,
        assessorComments: ASSESSOR_COMMENTS_FIELD,
        date: DATE_FIELD,
        handler: HANDLER_FIELD,
        location: LOCATION_FIELD,
        reviewComments: REVIEW_COMMENTS_FIELD,
        status: STATUS_FIELD,
        team: TEAM_FIELD,
        type: TYPE_FIELD,
        patDue: PAT_DUE_FIELD,
        patCount: PAT_COUNT_FIELD,
        validUntil: VALID_UNTIL_FIELD
    };

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

    handleChange(event) {
        this.passed =
            event.detail.value === "Passed" ||
            event.detail.value === "Provisionally Passed";
    }

    updateDueDate(event) {}

    handleClose() {}

    handleSubmit(event) {
        event.preventDefault();
        const documents = this.relatedFiles?.map((file) => file.documentId);
        if (!documents) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error!!",
                    message: "At least one file is required for a PAT.",
                    variant: "error"
                })
            );
            return;
        }
        let fields = [
            ...this.template.querySelectorAll("lightning-input-field")
        ];
        var record = fields.reduce(
            (a, x) => ({ ...a, [x.fieldName]: x.value }),
            {}
        );
        if (this.teamId) {
            record[TEAM_FIELD.fieldApiName] = this.teamId;
        }
        record.Id = this.recordId;
        if (this.mode === "create") {
            this.createNewPat(record, documents);
        } else {
            this.editPat(record);
        }
    }

    @wire(MessageContext)
    messageContext;

    // Create a new log
    createNewPat(record, documents) {
        createPat({
            record: record,
            documentIds: documents
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
    editPat(record) {
        updatePat({ record: record })
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
                patForm,
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
        this.passed =
            message.status === "Passed" ||
            message.status === "Provisionally Passed";
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
        if (this.relatedFiles) {
            this.relatedFiles = this.relatedFiles.concat(event.detail.files);
        } else {
            this.relatedFiles = event.detail.files;
        }
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
