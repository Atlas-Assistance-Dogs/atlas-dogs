import { createElement } from "lwc";
import FieldWithUnitsCmp from "c/fieldWithUnitsCmp";

const POUND_TO_KG = 0.45359237;
const INCHES_TO_CM = 2.54;

const mockConversion = jest.fn((x) => x);
const mockHandler = jest.fn();

describe("c-field-with-units", () => {
    let element;
    beforeEach(() => {
        element = createElement("c-field-with-units-cmp", {
            is: FieldWithUnitsCmp
        });
        element.name = "weight";
        element.label = "Weight";
        element.value = 5;
        element.baseUnits = "kg";
        element.units = "lb";
        element.conversion = mockConversion;
        element.addEventListener("change", mockHandler);
    });
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        mockConversion.mockReset();
    });

    // Helper function to wait until the microtask queue is empty. This is needed for promise
    // timing when calling imperative Apex.
    async function flushPromises() {
        return Promise.resolve();
    }

    it.each(["lb", "kg"])("should display converted value", (units) => {
        // Arrange
        element.units = units;
        mockConversion.mockReturnValueOnce(15);

        // Act
        document.body.appendChild(element);

        // Assert
        const input = element.shadowRoot.querySelector("lightning-input");
        expect(input.value).toBe(15);
        expect(mockConversion).toHaveBeenCalledWith(5, "kg", units);
    });

    it.each(["lb", "kg", "in", "cm"])(
        "should display current units",
        (units) => {
            // Arrange
            element.units = units;

            // Act
            document.body.appendChild(element);

            // Assert
            const input = element.shadowRoot.querySelector("lightning-input");
            expect(input.label).toBe(`Weight (${units})`);
        }
    );

    it.each([0, 0.1, 0.01, 5555555.5])(
        "should emit event on change",
        async (value) => {
            // Act
            document.body.appendChild(element);
            mockConversion.mockReturnValueOnce(value + 1);

            // Assert
            const input = element.shadowRoot.querySelector("lightning-input");
            input.dispatchEvent(
                new CustomEvent("change", { detail: { value: value } })
            );

            // Wait for any asynchronous DOM updates
            await flushPromises();

            // Check that the select event was fired
            expect(mockConversion).toHaveBeenCalledWith(value, "lb", "kg");
            expect(mockHandler).toHaveBeenCalledWith(
                expect.objectContaining({ detail: value + 1 })
            );
        }
    );
});
