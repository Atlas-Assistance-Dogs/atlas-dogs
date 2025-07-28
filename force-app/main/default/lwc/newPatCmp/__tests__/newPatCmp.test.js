import { createElement } from "lwc";
import NewPatCmp from "c/newPatCmp";
import PAT_OBJECT from "@salesforce/schema/PublicAccessTest__c";

describe("c-new-pat-cmp", () => {
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

  it("should show pat-form", async () => {
    // Arrange
    const RECORD_ID_INPUT = "0031700000pJRRSAA4";
    const element = createElement("c-new-pat-cmp", { is: NewPatCmp });
    element.recordId = RECORD_ID_INPUT;
    element.objectApiName = PAT_OBJECT.objectApiName;

    // Act
    document.body.appendChild(element);
    element.openModal();

    // Wait for any asynchronous DOM updates
    await flushPromises();
    // Assert
    expect(element.shadowRoot.querySelector("c-pat-form-cmp")).toBeTruthy();
  });
});
