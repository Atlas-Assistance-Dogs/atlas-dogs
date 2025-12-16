// hello.test.js
import { createElement } from "lwc";
import NewDogCmp from "c/newDogCmp";

import NAME_FIELD from "@salesforce/schema/Dog__c.Name";
import BREED_FIELD from "@salesforce/schema/Dog__c.Breed__c";
import GENDER_FIELD from "@salesforce/schema/Dog__c.Gender__c";
import HEIGHT_FIELD from "@salesforce/schema/Dog__c.Height__c";
import SPAYED_NEUTERED_FIELD from "@salesforce/schema/Dog__c.SpayedNeutered__c";
import BIRTHDATE_FIELD from "@salesforce/schema/Dog__c.Birthdate__c";
import STATUS_FIELD from "@salesforce/schema/Dog__c.Status__c";
import MICROCHIP_FIELD from "@salesforce/schema/Dog__c.MicrochipNumber__c";
import HEALTH_FIELD from "@salesforce/schema/Dog__c.LatestPhysicalExamOutcome__c";
import EXAM_DUE_FIELD from "@salesforce/schema/Dog__c.PhysicalExamDue__c";
import DA2PP_DUE_FIELD from "@salesforce/schema/Dog__c.VaccineDueDA2PP__c";
import PICTURE_FIELD from "@salesforce/schema/Dog__c.Picture__c";
import RABIES_DUE_FIELD from "@salesforce/schema/Dog__c.VaccineDueRabies__c";
import WEIGHT_FIELD from "@salesforce/schema/Dog__c.Weight__c";
import XRAY_FIELD from "@salesforce/schema/Dog__c.XrayRequired__c";

describe("c-new-dog-cmp", () => {
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

  it("displays header", async () => {
    // Create element
    const element = createElement("c-new-dog-cmp", {
      is: NewDogCmp,
    });
    document.body.appendChild(element);

    // open the modal
    const modalEl = element.shadowRoot.querySelector("c-modal-cmp");
    modalEl.openModal();

    // Wait for any asynchronous DOM updates
    await flushPromises();
    // Verify displayed greeting
    const div = element.shadowRoot.querySelector("div");
    expect(div.textContent).toBe("Dog Information");
  });

  it("renders given set of lightning-output-field`s in specific order", async () => {
    const INPUT_FIELDS = [
      NAME_FIELD.fieldApiName,
      BREED_FIELD.fieldApiName,
      GENDER_FIELD.fieldApiName,
      SPAYED_NEUTERED_FIELD.fieldApiName,
      HEIGHT_FIELD.fieldApiName,
      BIRTHDATE_FIELD.fieldApiName,
      STATUS_FIELD.fieldApiName,
      MICROCHIP_FIELD.fieldApiName,
      XRAY_FIELD.fieldApiName,
      WEIGHT_FIELD.fieldApiName,
      HEALTH_FIELD.fieldApiName,
      EXAM_DUE_FIELD.fieldApiName,
      DA2PP_DUE_FIELD.fieldApiName,
      RABIES_DUE_FIELD.fieldApiName,
      PICTURE_FIELD.fieldApiName,
    ];

    // Create component
    const element = createElement("c-new-dog-cmp", { is: NewDogCmp });
    document.body.appendChild(element);
    // open modal
    const modalEl = element.shadowRoot.querySelector("c-modal-cmp");
    modalEl.openModal();

    // Wait for any asynchronous DOM updates
    await flushPromises();

    // Select elements for validation
    const outputFieldNames = Array.from(
      element.shadowRoot.querySelectorAll("lightning-input-field")
    ).map((outputField) => outputField.fieldName.fieldApiName);
    expect(outputFieldNames).toEqual(INPUT_FIELDS);
  });
});