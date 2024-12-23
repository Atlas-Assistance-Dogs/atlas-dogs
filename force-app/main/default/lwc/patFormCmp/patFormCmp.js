import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import relateFiles from "@salesforce/apex/FileController.relateFiles";
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
      ".mov",
      ".mp4",
      ".zip"
    ];
  }

  @api
  openModal(message) {
    this.recordId = message?.recordId;
    if (this.recordId) {
      refreshApex(this.wiredFilesList);
    } else {
      this.relatedFiles = null;
    }
    this.mode = message?.recordId ? "edit" : "create";
    this.passed =
      message?.status === "Passed" ||
      message?.status === "Provisionally Passed";
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

  handleSubmit(event) {
    event.preventDefault();
    this.template.querySelector("lightning-record-edit-form").submit();
  }

  // Create a new log
  handleSuccess(event) {
    // If we just created a record, we need to attach files
    if (!this.recordId) {
      const documents = this.relatedFiles?.map((file) => file.documentId);
      relateFiles({ documentIds: documents, recordId: event.detail.id })
        .then(() => {
          this.dispatchEvent(
            new CustomEvent("changed", { detail: event.detail.id })
          );
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
    } else {
      this.dispatchEvent(new CustomEvent("changed"));
      this.closeModal();
    }
  }

  @wire(getRelatedFiles, { recordId: "$recordId", max: 100 })
  filesLst(result) {
    this.wiredFilesList = result;
    this.relatedFiles = null;
    if (result.data?.items) {
      this.relatedFiles = result.data.items.map((data) => {
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

  handleCancel() {
    console.log("Pat form cancel");
    this.dispatchEvent(new CustomEvent("cancel"));
  }
}
