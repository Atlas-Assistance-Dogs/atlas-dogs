import { LightningElement, track, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import { getRecord } from "lightning/uiRecordApi";
import getCategoriesForObject from "@salesforce/apex/CategoryRuleController.getCategoryEntriesForObject";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import { NavigationMixin } from "lightning/navigation";

import CV_OBJECT from "@salesforce/schema/ContentVersion";
import CATEGORY_FIELD from "@salesforce/schema/ContentVersion.Category__c";
import DATE_FIELD from "@salesforce/schema/ContentVersion.Date__c";
import DOCID_FIELD from "@salesforce/schema/ContentVersion.ContentDocumentId";
import TITLE_FIELD from "@salesforce/schema/ContentVersion.Title";
import FILE_TYPE_FIELD from "@salesforce/schema/ContentVersion.FileType";
import TYPE_FIELD from "@salesforce/schema/ContentVersion.Type__c";

export default class FileInformation extends NavigationMixin(LightningElement) {
  @api objectId; // Id of the object the file is/will be linked to
  @api recordId; // ContentVersion Id if editing
  @api isUpload = false; // true if uploading file
  @track fileUploadList = [];
  @track fileIDs = [];
  isErrorMessage = false;
  message = "";
  recordTypeId;
  category = null;
  type = null;
  @track categories = [];
  @track types = [];

  objectApiName = CV_OBJECT.objectApiName;
  fields = {
    category: CATEGORY_FIELD,
    type: TYPE_FIELD,
    date: DATE_FIELD
  };
  categories = [];
  category = null;

  // Get the ContentVersion settings selected by the user
  @api
  getInformation() {
    return {
      category: this.category,
      type: this.type,
      date: this.template.querySelector(".date").value
    };
  }

  @wire(getCategoriesForObject, {
    recordId: "$objectId",
    isUpload: "$isUpload"
  })
  getCategories(result) {
    if (result?.data !== undefined) {
      this.categories = result.data;
      if (this.categories.length == 1) {
        this.category = this.categories[0].value;
        this.types = this.categoryTypes[this.category];
      }
    } else if (result?.error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error!!",
          message:
            result.error.body?.message ??
            "An error occurred getting categories",
          variant: "error"
        })
      );
    }
  }

  recordTypeId;
  @wire(getObjectInfo, { objectApiName: CV_OBJECT })
  objectInfo({ error, data }) {
    if (data) {
      const rtis = data.recordTypeInfos;
      // Returns a map of record type names to their ids
      this.recordTypeId = Object.keys(rtis)[0];
    } else if (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error!!",
          message:
            error.body?.message ?? "An error occurred getting object info",
          variant: "error"
        })
      );
    }
  }

  categoryTypes = {};

  @wire(getPicklistValues, {
    recordTypeId: "$recordTypeId",
    fieldApiName: TYPE_FIELD
  })
  getPicklistValuesForType({ error, data }) {
    if (error) {
      console.log("unable to fetch values");
    } else if (data && data.values) {
      const controlling = data.controllerValues;
      let controlLookup = [];
      data.values.forEach((optionData) => {
        optionData.validFor.forEach((idx) => {
          if (!controlLookup[idx]) {
            controlLookup[idx] = [];
          }
          controlLookup[idx].push({
            label: optionData.label,
            value: optionData.value
          });
        });
      });
      this.categoryTypes = {};
      for (const cat in controlling) {
        this.categoryTypes[cat] = controlLookup[controlling[cat]];
      }
      // Sometimes we get the category types after we assign a category
      if (this.category) {
        this.types = this.categoryTypes[this.category];
      }
    }
  }

  // Get the file name, document id, and current values
  @wire(getRecord, {
    recordId: "$recordId",
    fields: [
      CATEGORY_FIELD,
      DOCID_FIELD,
      TITLE_FIELD,
      FILE_TYPE_FIELD,
      TYPE_FIELD
    ]
  })
  getFileInfo(result) {
    if (result?.data) {
      const title = result.data.fields.Title.value;
      const fileType = result.data.fields.FileType.value;
      this.category = result.data.fields[CATEGORY_FIELD.fieldApiName].value;
      this.type = result.data.fields[TYPE_FIELD.fieldApiName].value;
      const contentDocumentId = result.data.fields.ContentDocumentId.value;
      this.dispatchEvent(
        new CustomEvent("info", {
          detail: {
            category: this.category,
            type: this.type,
            title: title,
            fileType: fileType,
            contentDocumentId: contentDocumentId
          }
        })
      );
      if (this.categoryTypes) {
        this.types = this.categoryTypes[this.category];
      }
    } else if (result?.error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error!!",
          message: result.error.message,
          variant: "error"
        })
      );
    }
  }

  handleCategoryChange(event) {
    this.category = event.detail.value;
    if (this.categoryTypes) {
      this.types = this.categoryTypes[this.category];
    }
  }

  handleTypeChange(event) {
    this.type = event.detail.value;
  }
}
