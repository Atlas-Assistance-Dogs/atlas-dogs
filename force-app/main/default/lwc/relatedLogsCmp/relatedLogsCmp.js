import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getRelatedLogs from "@salesforce/apex/LogController.getRelatedLogs";
import { deleteRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";

import LOG_OBJECT from "@salesforce/schema/Log__c";
import ATLAS_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromAtlas__c";
import TEAM_OBJECT from "@salesforce/schema/Team__c";
import CLIENT_HOURS_FIELD from "@salesforce/schema/Log__c.ClientHours__c";
import CLIENT_STRESS_FIELD from "@salesforce/schema/Log__c.ClientStress__c";
import DATE_FIELD from "@salesforce/schema/Log__c.Date__c";
import DETAILS_FIELD from "@salesforce/schema/Log__c.Details__c";
import DID_MEET_FIELD from "@salesforce/schema/Log__c.DidMeetThisWeek__c";
import FACILITATOR_FIELD from "@salesforce/schema/Log__c.Facilitator__c";
import FIRST_AID_SUPPLIES_FIELD from "@salesforce/schema/Log__c.FirstAidSuppliesUsed__c";
import HANDLERS_FIELD from "@salesforce/schema/Log__c.Handler__c";
import SUBMITTER_FIELD from "@salesforce/schema/Log__c.Submitter__c";
import NAME_FIELD from "@salesforce/schema/Log__c.Name";
import OTHER_HOURS_FIELD from "@salesforce/schema/Log__c.OtherHours__c";
import PAH_FIELD from "@salesforce/schema/Log__c.PublicAccessHours__c";
import SATISFACTION_FIELD from "@salesforce/schema/Log__c.Satisfaction__c";
import SESSION_FIELD from "@salesforce/schema/Log__c.SessionType__c";
import STRESS_FIELD from "@salesforce/schema/Log__c.Stress__c";
import TEAM_FIELD from "@salesforce/schema/Log__c.Team__c";
import TEAM_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromTeam__c";

const actions = [
  { label: "Edit", name: "edit" },
  { label: "Delete", name: "delete" }
];

const COLS = {
  name: {
    label: "Name",
    fieldName: NAME_FIELD.fieldApiName,
    type: "button",
    typeAttributes: {
      name: "view",
      label: { fieldName: NAME_FIELD.fieldApiName },
      variant: "base"
    },
    sortable: true
  },
  date: {
    label: "Date",
    fieldName: DATE_FIELD.fieldApiName,
    type: "date-local",
    sortable: true
  },
  team: {
    label: "Team",
    fieldName: "teamName",
    type: "button",
    typeAttributes: {
      name: "team",
      label: { fieldName: "teamName" },
      variant: "base"
    },
    sortable: true,
    actions: [{ label: "Hide", name: "hide" }]
  },
  facilitator: {
    label: "Facilitator",
    fieldName: "facilitatorName",
    type: "button",
    typeAttributes: {
      name: "facilitator",
      label: { fieldName: "facilitatorName" },
      variant: "base"
    },
    sortable: true,
    actions: [{ label: "Hide", name: "hide" }]
  },
  submitter: {
    label: "Submitter",
    fieldName: "submitterName",
    type: "button",
    typeAttributes: {
      name: "submitter",
      label: { fieldName: "submitterName" },
      variant: "base"
    },
    sortable: true,
    actions: [{ label: "Hide", name: "hide" }]
  },
  handlers: {
    label: "Handler(s)",
    fieldName: HANDLERS_FIELD.fieldApiName,
    type: "string",
    editable: "true"
  },
  session: {
    label: "Session Type",
    fieldName: SESSION_FIELD.fieldApiName,
    type: "string",
    editable: "true"
  },
  clientHours: {
    label: "Hours with Client",
    fieldName: CLIENT_HOURS_FIELD.fieldApiName,
    type: "number",
    editable: "true"
  },
  hours: {
    label: "PA Hours",
    fieldName: PAH_FIELD.fieldApiName,
    type: "number",
    editable: "true"
  },
  otherHours: {
    label: "Other Hours",
    fieldName: OTHER_HOURS_FIELD.fieldApiName,
    type: "number",
    editable: "true"
  },
  teamSupport: {
    label: "Team Support?",
    fieldName: TEAM_SUPPORT_FIELD.fieldApiName,
    type: "boolean"
  },
  didMeet: {
    label: "Met this Week?",
    fieldName: DID_MEET_FIELD.fieldApiName,
    type: "boolean"
  },
  stress: { label: "Stress", fieldName: STRESS_FIELD.fieldApiName },
  clientStress: {
    label: "Client Stress",
    fieldName: CLIENT_STRESS_FIELD.fieldApiName
  },
  satisfaction: {
    label: "Satisfaction",
    fieldName: SATISFACTION_FIELD.fieldApiName
  },
  atlas: {
    label: "Atlas Support?",
    fieldName: ATLAS_SUPPORT_FIELD.fieldApiName,
    type: "boolean"
  },
  aid: {
    label: "1st Aid Supplies Used?",
    fieldName: FIRST_AID_SUPPLIES_FIELD.fieldApiName,
    type: "boolean"
  },
  details: {
    label: "Details",
    fieldName: DETAILS_FIELD.fieldApiName
  },
  action: { type: "action", typeAttributes: { rowActions: actions } }
};

const CLIENT_COLS = [
  COLS.name,
  COLS.date,
  COLS.team,
  COLS.handlers,
  COLS.session,
  COLS.didMeet,
  COLS.details
];

const FAC_COLS = [
  COLS.name,
  COLS.date,
  COLS.team,
  COLS.handlers,
  COLS.facilitator,
  COLS.session,
  COLS.details
];

export default class RelatedLogsCmp extends NavigationMixin(LightningElement) {
  @api recordId;
  @api objectApiName;
  @api viewAll;

  _recordType;
  @track
  columns;
  @api get recordType() {
    return this._recordType;
  }
  set recordType(value) {
    this._recordType = value;
    this.setColumns();
  }

  setColumns() {
    if (this._recordType === "Client") {
      this.columns = CLIENT_COLS.filter(
        (x) => !this.hiddenCols.has(x.fieldName)
      );
    } else {
      this.columns = FAC_COLS.filter((x) => !this.hiddenCols.has(x.fieldName));
    }
  }
  relatedObject = LOG_OBJECT;
  data = [];
  hiddenCols;

  constructor() {
    super();
    this.hiddenCols = new Set();
  }

  get title() {
    return this._recordType === "Client"
      ? "Client Logs"
      : "Team Facilitator Logs";
  }

  get auraCmpName() {
    return this._recordType === "Client"
      ? "AllClientLogsCmp"
      : "AllFacilitatorLogsCmp";
  }

  defaultSortDirection = "asc";
  sortDirection = "asc";
  sortedBy;

  handleSort(event) {
    const { fieldName, sortDirection } = event.detail;
    const cloneData = [...this.data];

    cloneData.sort((a, b) => {
      const x1 = a[fieldName] ?? "";
      const x2 = b[fieldName] ?? "";
      const asc = x1 > x2 ? 1 : x1 < x2 ? -1 : 0;
      return sortDirection === "asc" ? asc : asc * -1;
    });
    this.data = cloneData;
    this.sortDirection = sortDirection;
    this.sortedBy = fieldName;
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case "delete":
        this.deleteLog(row.Id);
        break;
      case "edit":
        const payload = {
          mode: "edit",
          recordId: row.Id,
          record: row,
          recordType:
            this._recordType === "Client" ? "Client" : "Team Facilitator"
        };
        this.template.querySelector("c-log-form-cmp").openModal(payload);
        break;
      case "view":
        this.navigateToRecord(row.Id, this.objectApiName);
        break;
      case "team":
        this.navigateToRecord(
          row[TEAM_FIELD.fieldApiName],
          TEAM_OBJECT.objectApiName
        );
        break;
      case "facilitator":
        this.navigateToRecord(row[FACILITATOR_FIELD.fieldApiName], "Contact");
        break;
      case "submitter":
        this.navigateToRecord(row[SUBMITTER_FIELD.fieldApiName], "Contact");
        break;
    }
  }

  handleHeaderAction(event) {
    // Retrieves the name of the selected filter
    const actionName = event.detail.action.name;
    // Retrieves the current column definition
    // based on the selected filter
    const colDef = event.detail.columnDefinition;
    if (actionName.includes("hide")) {
      this.hiddenCols.add(colDef.fieldName);
      this.setColumns();
    }
  }

  get showResetColBtn() {
    return this.hiddenCols.size > 0;
  }

  // Set the columns back to the default for the record type
  showAllColumns() {
    this.hiddenCols.clear();
    this.setColumns();
  }

  @api
  get max() {
    return this.viewAll ? 10000 : 6;
  }

  @wire(getRelatedLogs, {
    recordId: "$recordId",
    recordType: "$recordType",
    max: "$max"
  })
  getLogs(result) {
    this.wiredData = result;
    this.data = null;
    if (result.data && result.data.items) {
      this.data = result.data.items.map((info) => {
        var log = Object.assign({}, info.log);
        log.teamName = info.teamName;
        log.facilitatorName = info.facilitatorName;
        log.submitterName = info.submitterName;
        log[DETAILS_FIELD.fieldApiName] = log[
          DETAILS_FIELD.fieldApiName
        ]?.replace(/(<([^>]+)>)/gi, "");
        return log;
      });
      if (this.data.length === 0) {
        this.data = null;
        this.total = 0;
      }
      if (!this.viewAll) {
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

  createLog() {
    const typeName =
      this.recordType === "Client" ? "Client" : "Team Facilitator";
    const payload = { mode: "create", recordType: typeName };
    this.template.querySelector("c-log-form-cmp").openModal(payload);
  }

  deleteLog(recordId) {
    deleteRecord(recordId)
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Log Deleted",
            variant: "success"
          })
        );
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
    refreshApex(this.wiredData);
  }

  navigateToRecord(recordId, objectName) {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: recordId,
        objectApiName: objectName,
        actionName: "view"
      }
    });
  }
}
