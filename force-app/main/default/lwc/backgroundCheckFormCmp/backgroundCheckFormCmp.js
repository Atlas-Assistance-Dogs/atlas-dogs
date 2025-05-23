import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getRelatedFiles from "@salesforce/apex/FileController.getRelatedFiles";
import relateFile from "@salesforce/apex/FileController.relateFile";
import { NavigationMixin } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

import CONTACT_FIELD from "@salesforce/schema/BackgroundCheck__c.Contact__c";
import DATE_FIELD from "@salesforce/schema/BackgroundCheck__c.Date__c";
import NOTES_FIELD from "@salesforce/schema/BackgroundCheck__c.Notes__c";
import RESULT_FIELD from "@salesforce/schema/BackgroundCheck__c.Status__c";
import TYPE_FIELD from "@salesforce/schema/BackgroundCheck__c.Type__c";

export default class BackgroundCheckFormCmp extends NavigationMixin(
  LightningElement
) {
  @api recordId;
  @api contactId;
  currentCv;
  wiredCv;
  message;

  objectName = CONTACT_FIELD.objectApiName;

  fields = {
    contact: CONTACT_FIELD,
    date: DATE_FIELD,
    notes: NOTES_FIELD,
    result: RESULT_FIELD,
    type: TYPE_FIELD
  };

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
      ".csv",
      ".mov",
      ".mp4",
      ".zip"
    ];
  }

  get hasFile() {
    return this.currentCv;
  }

  @wire(getRelatedFiles, { recordId: "$recordId", max: 100 })
  getFiles(result) {
    this.wiredCv = result;
    this.currentCv = null;
    if (result.data?.items?.length ?? 0 > 0) {
      this.currentCv = result.data.items[0].cv;
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

  handleUploadFinished(event) {
    this.isErrorMessage = false;
    this.message = "File Uploaded Successfully";
    this.uploadedFile = event.detail.files[0];
    this.currentCv = {
      Title: this.getFileNameWithoutExtension(this.uploadedFile.name),
      ContentDocumentId: this.uploadedFile.documentId
    };
    refreshApex();
  }

  getFileNameWithoutExtension(name) {
    let parts = name.split(".");
    if (parts.length > 1) {
      return parts.slice(0, -1).join(".");
    }
    return name;
  }

  @api
  handleSubmit(event) {
    event.preventDefault();
    this.template.querySelector("lightning-record-edit-form").submit();
  }

  handleSuccess(event) {
        if (!this.recordId && this.currentCv) { // new background check
      relateFile({
        documentId: this.currentCv.ContentDocumentId,
        recordId: event.detail.id
      })
        .then((id) => {
                    this.dispatchEvent(
                        new CustomEvent("changed", { detail: id })
                    );
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
    }
  }

  handleCancel() {
    this.dispatchEvent(new CustomEvent("cancel", { detail: id }));
  }
}
