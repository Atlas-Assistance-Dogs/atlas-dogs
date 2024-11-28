import { api, LightningElement } from "lwc";

export default class FieldWithUnitsCmp extends LightningElement {
    @api name;
    @api label;
    // field value in base units
    @api value = 0;
    @api baseUnits = 'cm';
    @api units = 'in';
    @api conversion = (value, from, to) => { return value }

    get displayLabel() {
        return `${this.label} (${this.units})`;
    }
    get displayValue() {
        let value = this.conversion(Number(this.value), this.baseUnits, this.units);
        let rounded = Math.round(value);
        return rounded;
    }

    handleValueChange(event) {
        this.value = this.conversion(
            Number(event.detail.value),
            this.units,
            this.baseUnits
        );
        this.dispatchEvent(new CustomEvent("change", { detail: this.value }));
    }
}
