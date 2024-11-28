import { api, LightningElement, wire } from "lwc";
import getSize from "@salesforce/apex/DogController.getSize";
import { refreshApex } from "@salesforce/apex";

const POUND_TO_KG = 0.45359237;
const INCHES_TO_CM = 2.54;

export default class DogSizeCmp extends LightningElement {
    @api recordId;

    options = [
        { label: "Imperial (inch/lb)", value: "imperial" },
        { label: "SI (cm/kg)", value: "si" }
    ];

    useSi = false;
    weight;
    height;
    wiredChecks;

    @wire(getSize, { recordId: "$recordId" })
    getSize(result) {
        this.wiredChecks = result;
        if (result.data) {
            this.useSi = result.data.useSiUnits;
            const size = result.data;
            // convert to US units (inch/lb)
            this.weight = size.weight;
            this.height = size.height;
        } else if (result.error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error!!",
                    message: result.error.message,
                    variant: "error"
                })
            );
        }
    }

    handleUnitChange(event) {
        this.useSi = !this.useSi;
    }

    get heightUnits() {
        return this.useSi ? "cm" : "in";
    }
    heightConversion = (value, from, to) => {
        if (from === to || !value) return value;
        if (from === "in") return value * INCHES_TO_CM;
        return value / INCHES_TO_CM;
    };
    handleHeightChange() {}

    get weightUnits() {
        return this.useSi ? "kg" : "lb";
    }

    weightConversion = (value, from, to) => {
        if (from === to || !value) return value;
        if (from === "lb") return value * POUND_TO_KG;
        return value / POUND_TO_KG;
    };
    handleWeightChange() {}
}
