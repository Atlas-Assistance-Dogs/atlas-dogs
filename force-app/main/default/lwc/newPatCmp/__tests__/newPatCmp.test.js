import { createElement } from "lwc";
import NewPatCmp from "c/newPatCmp";
import PAT_OBJECT from "@salesforce/schema/PublicAccessTest__c";
import flushPromises from "../../__tests__/flushPromises";

describe("c-new-pat-cmp", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

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
