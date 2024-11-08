import { api, LightningElement } from "lwc";

export function FieldInfo(
    label,
    value,
    baseUnits,
    currentUnits,
    availableUnits,
    conversion
) {
    this.label = label;
    this.value = value;
    this.baseUnits = baseUnits;
    this.currentUnits = currentUnits;
    this.availableUnits = availableUnits;
    this.conversion = conversion;
}

export default class FieldWithUnits extends LightningElement {
    // field value in base units
    @api info = new FieldInfo(0, 'kg', 'kg', ['lb', 'kg'], () => {});

    get options() {
        return this.info.availableUnits?.map((name) => {
            return { label: name, value: name };
        });
    }

    get displayValue() {
        return this.info?.conversion(
            this.info?.value,
            this.info?.baseUnits,
            this.info?.currentUnits
        );
    }

    handleValueChange(event) {
        this.value = this.info?.conversion(
            event.detail.value,
            this.info.currentUnits,
            this.info.baseUnits
        );
        this.dispatchEvent(new CustomEvent("change", { detail: this.value }));
    }
    handleUnitChange(event) {
        oldUnits = this.info.currentUnits;
        this.info.currentUnits = event.detail.value;
    }
}
