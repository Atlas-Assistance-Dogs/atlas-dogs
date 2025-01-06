import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import relateFiles from "@salesforce/apex/FileController.relateFiles";
import { refreshApex } from "@salesforce/apex";

import AUTHORITY_FIELD from "@salesforce/schema/CEU__c.Authority__c";
import AUTHORITY_OTHER_FIELD from "@salesforce/schema/CEU__c.AuthorityOther__c";
import COMMENTS_FIELD from "@salesforce/schema/CEU__c.Comments__c";
import DATE_COMPLETED_FIELD from "@salesforce/schema/CEU__c.DateCompleted__c";
import DATE_SUBMITTED_FIELD from "@salesforce/schema/CEU__c.DateSubmitted__c";
import PROGRAM_DATE_FIELD from "@salesforce/schema/CEU__c.ProgramDate__c";
import PROGRAM_HOURS_FIELD from "@salesforce/schema/CEU__c.ProgramHours__c";
import PROGRAM_TITLE_FIELD from "@salesforce/schema/CEU__c.ProgramTitle__c";
import QUANTITY_FIELD from "@salesforce/schema/CEU__c.Quantity__c";
import ROLE_FIELD from "@salesforce/schema/CEU__c.Role__c";
import STATUS_FIELD from "@salesforce/schema/CEU__c.Status__c";
import TRAINER_FIELD from "@salesforce/schema/CEU__c.Contact__c";

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
    this.mode = this.recordId ? "edit" : "create";
    this.authority = message?.authority;
    this.template.querySelector("c-modal-cmp").openModal();
  }

  closeModal() {
    this.template.querySelector("c-modal-cmp").closeModal();
  }

  get isAuthorityOther() {
    return this.authority === "Other";
  }

  handleAuthorityChange(event) {
    this.authority = event.target.value;
  }

  handleSubmit(event) {
    event.preventDefault();
    this.template.querySelector("lightning-record-edit-form").submit();
  }

  // Create a new log
  handleSuccess(event) {
        if (!this.recordId) { // new CEU
      const docIds = this.relatedFiles?.map((file) => file.documentId);
            relateFiles({documentIds: docIds, recordId: event.detail.id})
        .then((id) => {
          this.dispatchEvent(
            new CustomEvent("changed", { detail: event.detail })
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
      this.dispatchEvent(new CustomEvent("changed", { detail: event.detail }));
      this.closeModal();
    }
  }

  handleCancel() {
    this.dispatchEvent(new CustomEvent("cancel"));
  }

  get hasFiles() {
    return this.relatedFiles !== null && this.relatedFiles.length > 0;
  }

  @wire(getRelatedFiles, { recordId: "$recordId", max: 100 }) filesLst(result) {
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

  // called after files are uploaded
  handleUploadFinished(event) {
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
