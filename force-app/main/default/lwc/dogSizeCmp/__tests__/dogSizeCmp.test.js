import { createElement } from "lwc";
import getSize from "@salesforce/apex/DogController.getSize";
import DogSizeCmp from "c/dogSizeCmp";

// Import mock data to send through the wire adapter.
const mockGetSize = require("./data/getSize.json");

jest.mock(
    "@salesforce/apex/DogController.getSize",
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

describe("c-dog-size-cmp", () => {
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

    it("should render without errors", async () => {
        // Arrange
        const element = createElement("c-dog-size-cmp", {
            is: DogSizeCmp
        });

        // Act
        document.body.appendChild(element);

        // Assert
        // const div = element.shadowRoot.querySelector('div');
        expect(1).toBe(1);
    });

    it.each([true, false])("should show whether SI is default", async (selected) => {
        // Arrange
        const element = createElement("c-dog-size-cmp", {
            is: DogSizeCmp
        });

        // Act
        document.body.appendChild(element);

        // Emit data from @wire
        getSize.emit({ ...mockGetSize, useSiUnits: selected });

        // Wait for any asynchronous DOM updates
        await flushPromises();

        // Assert
        const checkbox = element.shadowRoot.querySelector(
            "lightning-input:first-child"
        );
        expect(checkbox.checked).toBe(selected);
    });

    it.each([5, 22, 15, 500])(
        "should show correct height when $height",
        async (height) => {
            // Arrange
            const element = createElement("c-dog-size-cmp", {
                is: DogSizeCmp
            });

            // Act
            document.body.appendChild(element);

            // Emit data from @wire
            getSize.emit({ ...mockGetSize, height: height });

            // Wait for any asynchronous DOM updates
            await flushPromises();

            // Assert
            const input = element.shadowRoot.querySelectorAll(
                "c-field-with-units-cmp"
            )[0];
            expect(input.value).toBe(height);
        }
    );

    it.each([5, 22, 15, 500])(
        "should show correct weight when $height",
        async (weight) => {
            // Arrange
            const element = createElement("c-dog-size-cmp", {
                is: DogSizeCmp
            });

            // Act
            document.body.appendChild(element);

            // Emit data from @wire
            getSize.emit({ ...mockGetSize, weight: weight });

            // Wait for any asynchronous DOM updates
            await flushPromises();

            // Assert
            const input = element.shadowRoot.querySelectorAll(
                "c-field-with-units-cmp"
            )[1];
            expect(input.value).toBe(weight);
        }
    );
});
