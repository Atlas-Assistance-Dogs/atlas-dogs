import { createElement } from 'lwc';
import FieldWithUnits from 'c/fieldWithUnits';
import { FieldInfo } from '../fieldWithUnits';

describe('c-field-with-units', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('should display value in current units', () => {
        // Arrange
        const element = createElement('c-field-with-units', {
            is: FieldWithUnits
        });
        element.info = new FieldInfo('Weight', 24, 'kg', 'kg', ['kg', 'lb'], (value, fromUnits, toUnits) => {
            if (fromUnits == 'kg' && toUnits == 'lb') {
                return 2.2 * value;
            } else if (fromUnits == 'lb' && toUnits == 'kg') {
                return value / 2.2;
            }
            return value;
        })

        // Act
        document.body.appendChild(element);

        // Assert
        const input = element.shadowRoot.querySelector('lightning-input');
        expect(input.value).toBe(24);
    });

    it("should display value in current units", () => {
        // Arrange
        const element = createElement("c-field-with-units", {
            is: FieldWithUnits
        });
        element.info = new FieldInfo(
            "Weight",
            24,
            "kg",
            "lb",
            ["kg", "lb"],
            (value, fromUnits, toUnits) => {
                if (fromUnits == "kg" && toUnits == "lb") {
                    return 2.2 * value;
                } else if (fromUnits == "lb" && toUnits == "kg") {
                    return value / 2.2;
                }
                return value;
            }
        );

        // Act
        document.body.appendChild(element);

        // Assert
        const input = element.shadowRoot.querySelector("lightning-input");
        expect(input.value).toBe(24 * 2.2);
    });
});