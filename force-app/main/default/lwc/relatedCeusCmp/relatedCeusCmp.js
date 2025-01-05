import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedCeus from "@salesforce/apex/CEUController.getRelatedCeus";
import deleteRecord from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";

import AUTHORITY_FIELD from "@salesforce/schema/CEU__c.Authority__c";
import AUTHORITY_OTHER_FIELD from "@salesforce/schema/CEU__c.AuthorityOther__c";
import DATE_COMPLETED_FIELD from "@salesforce/schema/CEU__c.DateCompleted__c";
import NAME_FIELD from "@salesforce/schema/CEU__c.Name";
import PROGRAM_DATE_FIELD from "@salesforce/schema/CEU__c.ProgramDate__c";
import REQUESTED_CEUS_FIELD from "@salesforce/schema/CEU__c.Quantity__c";
import ROLE_FIELD from "@salesforce/schema/CEU__c.Role__c";
import STATUS_FIELD from "@salesforce/schema/CEU__c.Status__c";

const actions = [
  { label: "Edit", name: "edit" },
  { label: "Delete", name: "delete" }
];

const COLS = [
  {
    label: "Name",
    type: "button",
    typeAttributes: {
      name: "goto",
      label: { fieldName: NAME_FIELD.fieldApiName },
      variant: "base"
    }
  },
  { label: "Authority", fieldName: "authority" },
  {
    label: "Program Date",
    fieldName: PROGRAM_DATE_FIELD.fieldApiName,
    type: "date-local"
  },
  {
    label: "Date Completed",
    fieldName: DATE_COMPLETED_FIELD.fieldApiName,
    type: "date-local"
  },
  {
    label: "Requested CEUs",
    fieldName: REQUESTED_CEUS_FIELD.fieldApiName,
    type: "number"
  },
  { label: "Role", fieldName: ROLE_FIELD.fieldApiName },
  { label: "Status", fieldName: STATUS_FIELD.fieldApiName },
  { type: "action", typeAttributes: { rowActions: actions } }
];

export default class RelatedCeusCmp extends NavigationMixin(LightningElement) {
  @api recordId;
  @api objectApiName;
  @api viewAll;
  columns = COLS;
  data = [];
  wiredCeus;
  total = 0;
  fieldName = STATUS_FIELD.fieldApiName;
  relatedObject = STATUS_FIELD.objectApiName;

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
        this.template.querySelector("c-ceu-form-cmp").openModal(payload);
        break;
      case "view":
        this.navigateToFiles(row);
        break;
      case "goto":
        this.navigateToRecord(row.Id);
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

  navigateToRecord(recordId) {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: recordId,
        actionName: "view"
      }
    });
  }

  @api
  get max() {
    return this.viewAll ? 10000 : 6;
  }

  @wire(getRelatedCeus, { contactId: "$recordId", max: "$max" })
  getCeus(result) {
    this.wiredCeus = result;
    this.data = null;
    if (result.data) {
      this.data = result.data.items.map((info) => {
        var ceu = Object.assign({}, info);
        ceu.authority = ceu[AUTHORITY_FIELD.fieldApiName];
        if (ceu.authority === "Other") {
          ceu.authority = ceu[AUTHORITY_OTHER_FIELD.fieldApiName];
        }
        return ceu;
      });
      if (this.data.length === 0) {
        this.data = null;
        this.total = 0;
      }
      if (this.max < 15) {
        this.total = result.data.total;
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
    this.template.querySelector("c-ceu-form-cmp").openModal(payload);
  }

  deleteCeu(recordId) {
    deleteRecord(recordId)
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
