import { createElement } from "lwc";
import LogFormCmp from "c/logFormCmp";
import LOG_OBJECT from "@salesforce/schema/Log__c";
import ATLAS_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromAtlas__c";
import TEAM_FIELD from "@salesforce/schema/Log__c.Team__c";
import CLIENT_FIELD from "@salesforce/schema/Log__c.Client__c";
import DATE_FIELD from "@salesforce/schema/Log__c.Date__c";
import DETAILS_FIELD from "@salesforce/schema/Log__c.Details__c";
import DID_MEET_FIELD from "@salesforce/schema/Log__c.DidMeetThisWeek__c";
import OTHER_HOURS_FIELD from "@salesforce/schema/Log__c.OtherHours__c";
import PAH_FIELD from "@salesforce/schema/Log__c.PublicAccessHours__c";
import SESSION_TYPE_FIELD from "@salesforce/schema/Log__c.SessionType__c";
import STRESS_FIELD from "@salesforce/schema/Log__c.Stress__c";
import SUBMITTER_FIELD from "@salesforce/schema/Log__c.Submitter__c";
import TEAM_FACILITATOR_FIELD from "@salesforce/schema/Log__c.Facilitator__c";
import TEAM_SUPPORT_FIELD from "@salesforce/schema/Log__c.RequestSupportFromTeam__c";

const RECORD_ID_INPUT = "0031700000pJRRSAA4";

describe("c-log-form-cmp", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });
  // Helper function to wait until the microtask queue is empty. This is needed for promise
  // timing when calling imperative Apex.
  async function flushPromises() {
    return Promise.resolve();
  }

  it("renders lightning-record-edit-form with given input values", async () => {
    // Create component
    const element = createElement("c-log-form-cmp", { is: LogFormCmp });
    // Set public properties
    element.recordId = RECORD_ID_INPUT;
    element.objectApiName = LOG_OBJECT.objectApiName;
    document.body.appendChild(element);
    const modalEl = element.shadowRoot.querySelector("c-modal-cmp");
    modalEl.openModal(RECORD_ID_INPUT);

    // Wait for any asynchronous DOM updates
    await flushPromises();
    // Validate if correct parameters have been passed to base components
    const formEl = element.shadowRoot.querySelector(
      "lightning-record-edit-form"
    );
    expect(formEl.recordId).toBe(RECORD_ID_INPUT);
    expect(formEl.objectApiName).toBe(LOG_OBJECT.objectApiName);
  });

  it("renders given set of lightning-output-field`s in specific order", async () => {
    const INPUT_FIELDS = [
      DATE_FIELD.fieldApiName,
      SUBMITTER_FIELD.fieldApiName,
      TEAM_FIELD.fieldApiName,
      CLIENT_FIELD.fieldApiName,
      TEAM_FACILITATOR_FIELD.fieldApiName,
      SESSION_TYPE_FIELD.fieldApiName,
      PAH_FIELD.fieldApiName,
      OTHER_HOURS_FIELD.fieldApiName,
      DETAILS_FIELD.fieldApiName,
      DID_MEET_FIELD.fieldApiName,
      TEAM_SUPPORT_FIELD.fieldApiName,
      ATLAS_SUPPORT_FIELD.fieldApiName,
      STRESS_FIELD.fieldApiName
    ];

    // Create component
    const element = createElement("c-log-form-cmp", { is: LogFormCmp });
    // Set public properties
    element.recordId = RECORD_ID_INPUT;
    element.objectApiName = LOG_OBJECT.objectApiName;
    document.body.appendChild(element);
    const modalEl = element.shadowRoot.querySelector("c-modal-cmp");
    modalEl.openModal(RECORD_ID_INPUT);

    // Wait for any asynchronous DOM updates
    await flushPromises();

    // Select elements for validation
    const outputFieldNames = Array.from(
      element.shadowRoot.querySelectorAll("lightning-input-field")
    ).map((outputField) => outputField.fieldName.fieldApiName);
    expect(outputFieldNames).toEqual(INPUT_FIELDS);
  });
});
