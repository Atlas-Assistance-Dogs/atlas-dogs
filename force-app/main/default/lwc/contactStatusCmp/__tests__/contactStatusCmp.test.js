import { createElement } from "lwc";
import ContactStatusCmp from "c/contactStatusCmp";
import { getRecord } from "lightning/uiRecordApi";
import getProgramAssignments from "@salesforce/apex/ContactController.getProgramAssignments";

// Import mock data to send through the wire adapter.
const mockSuperContact = require("./data/getSuperContact.json");
jest.mock("c/contactStatusIndicatorCmp");

// Mock Apex wire adapter
jest.mock(
    "@salesforce/apex/ContactController.getProgramAssignments",
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

    it("Super contact has expected status", () => {
        const expected = [
            { position: "Volunteer", status: "Active" },
            {
                position: "Team Facilitator",
                status: mockSuperContact.fields.FacilitatorStatus__c.value
            },
            {
                position: "Board",
                status: mockSuperContact.fields.BoardMemberStatus__c.value
            },
            {
                position: "Client",
                status: mockSuperContact.fields.ClientStatus__c.value
            },
            {
                position: "Trainer",
                status: mockSuperContact.fields.TrainerStatus__c.value
            }
        ];
        let superContact = { ...mockSuperContact };
        let daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - 100);
        superContact.fields.ClientCertAgreementReceived__c.value = daysAgo;
        superContact.fields.FacilitatorCertAgreementReceived__c.value = daysAgo;
        superContact.fields.TrainerCertAgreementReceived__c.value = daysAgo;
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getRecord.emit(superContact);
        getProgramAssignments.emit([]);

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

    it("Client has action soon", () => {
        let daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - 300);
        const client = {
            fields: {
                Positions__c: { value: "Client" },
                ClientStatus__c: { value: "Certified" },
                ClientCertAgreementReceived__c: { value: daysAgo }
            }
        };
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getRecord.emit(client);
        getProgramAssignments.emit([]);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(1);
            const indicator = indicators[0];
            expect(indicator.position).toBe("Client");
            expect(indicator.status).toBe("Action Needed Soon");
        });
    });

    it("Team Facilitator has action needed", () => {
        let daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - 370);
        const contact = {
            fields: {
                Positions__c: { value: "Team Facilitator" },
                FacilitatorStatus__c: { value: "Active" },
                FacilitatorCertAgreementReceived__c: { value: daysAgo }
            }
        };
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getRecord.emit(contact);
        getProgramAssignments.emit([]);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(1);
            const indicator = indicators[0];
            expect(indicator.position).toBe("Team Facilitator");
            expect(indicator.status).toBe("Action Needed");
        });
    });

    it("Trainer has action needed", () => {
        let daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - 365);
        const contact = {
            fields: {
                Positions__c: { value: "Trainer" },
                TrainerStatus__c: { value: "Active" },
                TrainerCertAgreementReceived__c: { value: daysAgo }
            }
        };
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getRecord.emit(contact);
        getProgramAssignments.emit([]);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(1);
            const indicator = indicators[0];
            expect(indicator.position).toBe("Trainer");
            expect(indicator.status).toBe("Action Needed");
        });
    });

    it("Trainer has action needed soon", () => {
        let daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - 364);
        const contact = {
            fields: {
                Positions__c: { value: "Trainer" },
                TrainerStatus__c: { value: "Active" },
                TrainerCertAgreementReceived__c: { value: daysAgo }
            }
        };
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getRecord.emit(contact);
        getProgramAssignments.emit([]);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(1);
            const indicator = indicators[0];
            expect(indicator.position).toBe("Trainer");
            expect(indicator.status).toBe("Action Needed Soon");
        });
    });

    it("Trainer is no longer active", () => {
        let daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - 400);
        const contact = {
            fields: {
                Positions__c: { value: "Trainer" },
                TrainerStatus__c: { value: "Inactive" },
                TrainerCertAgreementReceived__c: { value: daysAgo }
            }
        };
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getRecord.emit(contact);
        getProgramAssignments.emit([]);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(1);
            const indicator = indicators[0];
            expect(indicator.position).toBe("Trainer");
            expect(indicator.status).toBe("Inactive");
        });
    });

    it("Puppy Raiser has action needed", () => {
        let daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - 370);
        const contact = {
            fields: {
                Positions__c: { value: "Puppy Raiser" },
                PuppyRaiserStatus__c: { value: "Certified" },
                PuppyCertAgreementReceived__c: { value: daysAgo }
            }
        };
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getRecord.emit(contact);
        getProgramAssignments.emit([]);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(1);
            const indicator = indicators[0];
            expect(indicator.position).toBe("Puppy Raiser");
            expect(indicator.status).toBe("Action Needed");
        });
    });

    it("Contact has Other in training", () => {
        let daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - 370);
        const contact = {
            fields: {
                Positions__c: { value: null },
                PuppyRaiserStatus__c: { value: undefined },
                PuppyCertAgreementReceived__c: { value: undefined }
            }
        };
        const programAssignments = [
            {
                AssignedDate__c: new Date(),
                CompletionDate__c: undefined,
                ExpectedCompletion__c: new Date(),
                Program__c: "number",
                Program2__r: { Name: "Medical Alert", Standalone__c: true },
                Status__c: "In Progress"
            }
        ];
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getRecord.emit(contact);
        getProgramAssignments.emit(programAssignments);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(1);
            const indicator = indicators[0];
            expect(indicator.position).toBe("Other");
            expect(indicator.status).toBe("In Progress");
        });
    });

    it("Contact has Other in training when one program complete", () => {
        let daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - 370);
        const contact = {
            fields: {
                Positions__c: { value: null },
                PuppyRaiserStatus__c: { value: undefined },
                PuppyCertAgreementReceived__c: { value: undefined }
            }
        };
        const programAssignments = [
            {
                AssignedDate__c: new Date(),
                CompletionDate__c: undefined,
                ExpectedCompletion__c: new Date(),
                Program__c: "number",
                Program2__r: { Name: "Medical Alert", Standalone__c: true },
                Status__c: "In Progress"
            },
            {
                AssignedDate__c: new Date(),
                CompletionDate__c: undefined,
                ExpectedCompletion__c: new Date(),
                Program__c: "number",
                Program2__r: { Name: "Fitness", Standalone__c: true },
                Status__c: "Completed"
            },
            {
                AssignedDate__c: new Date(),
                CompletionDate__c: undefined,
                ExpectedCompletion__c: new Date(),
                Program__c: "number",
                Program2__r: { Name: "Fitness", Standalone__c: true },
                Status__c: "Discontinued"
            },
            {
                AssignedDate__c: new Date(),
                CompletionDate__c: undefined,
                ExpectedCompletion__c: new Date(),
                Program__c: "number",
                Program2__r: { Name: "Fitness", Standalone__c: true },
                Status__c: "Removed"
            }
        ];
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getRecord.emit(contact);
        getProgramAssignments.emit(programAssignments);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(1);
            const indicator = indicators[0];
            expect(indicator.position).toBe("Other");
            expect(indicator.status).toBe("In Progress");
        });
    });

    it("Contact has Other Decertifed/Suspended when all program complete", () => {
        let daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - 370);
        const contact = {
            fields: {
                Positions__c: { value: null },
                PuppyRaiserStatus__c: { value: undefined },
                PuppyCertAgreementReceived__c: { value: undefined }
            }
        };
        const programAssignments = [
            {
                AssignedDate__c: new Date(),
                CompletionDate__c: undefined,
                ExpectedCompletion__c: new Date(),
                Program__c: "number",
                Program2__r: { Name: "Fitness", Standalone__c: true },
                Status__c: "Completed"
            },
            {
                AssignedDate__c: new Date(),
                CompletionDate__c: undefined,
                ExpectedCompletion__c: new Date(),
                Program__c: "number",
                Program2__r: { Name: "Fitness", Standalone__c: true },
                Status__c: "Discontinued"
            },
            {
                AssignedDate__c: new Date(),
                CompletionDate__c: undefined,
                ExpectedCompletion__c: new Date(),
                Program__c: "number",
                Program2__r: { Name: "Fitness", Standalone__c: true },
                Status__c: "Removed"
            }
        ];
        const element = createElement("c-contact-status-cmp", {
            is: ContactStatusCmp
        });
        document.body.appendChild(element);

        // Emit mock record into the wired field
        getRecord.emit(contact);
        getProgramAssignments.emit(programAssignments);

        // Resolve a promise to wait for a rerender of the new content.
        return Promise.resolve().then(() => {
            const indicators = element.shadowRoot.querySelectorAll(
                "c-contact-status-indicator-cmp"
            );
            // Child is the mock, not the real component
            expect(indicators).not.toBeNull();
            expect(indicators.length).toBe(1);
            const indicator = indicators[0];
            expect(indicator.position).toBe("Other");
            expect(indicator.status).toBe("Decertifed/Suspended");
        });
    });
});
