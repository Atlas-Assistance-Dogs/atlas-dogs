import { createElement } from "lwc";
import ContactStatusCmp from "c/contactStatusCmp";
import { getRecord } from "lightning/uiRecordApi";
import getPositionStatus from "@salesforce/apex/PositionStatusController.getPositionStatusForContact";

// Import mock data to send through the wire adapter.
const mockSuperContact = require("./data/getSuperContact.json");
jest.mock("c/contactStatusIndicatorCmp");

// Mock Apex wire adapter
jest.mock(
    "@salesforce/apex/PositionStatusController.getPositionStatusForContact",
    () => {
        const {
            createApexTestWireAdapter
        } = require("@salesforce/sfdx-lwc-jest");
        return {
            default: createApexTestWireAdapter(jest.fn())
        };
    },
    { virtual: true }
);

describe("c-contact-status-cmp", () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        // Prevent data saved on mocks from leaking between tests
        jest.clearAllMocks();
    });

    // Helper function to wait until the microtask queue is empty. This is needed for promise
    // timing when calling imperative Apex.
    async function flushPromises() {
        return Promise.resolve();
    }

    it("renders without errors", () => {
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getPositionStatus.emit(null);
        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            expect(indicators).toBeDefined();
        });
    });

    it("shows expected status for super concact", () => {
        const expected = mockSuperContact.roles;
        let superContact = [...mockSuperContact.roles];
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getPositionStatus.emit(superContact);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(expected.length);
            for (var idx = 0; idx < indicators.length; idx++) {
                const indicator = indicators[idx];
                const expected1 = expected[idx];
                expect(indicator.position).toBe(expected1.position);
                expect(indicator.status).toBe(expected1.status);
            }
        });
    });

    it("shows just one", () => {
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getPositionStatus.emit(mockSuperContact.roles.slice(0, 1));

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(1);
            const indicator = indicators[0];
            expect(indicator.position).toBe(mockSuperContact.roles[0].position);
            expect(indicator.status).toBe(mockSuperContact.roles[0].status);
        });
    });

    it("shows none", () => {
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getPositionStatus.emit([]);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators).toHaveLength(0);
        });
    });
});
