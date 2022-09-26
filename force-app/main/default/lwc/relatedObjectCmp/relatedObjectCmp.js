import { LightningElement, api } from "lwc";

const MAX_DISPLAY = 6;
export default class RelatedObjectCmp extends LightningElement {
    @api iconName = "standard:folder";
    @api title = "Related Objects";
    @api total = 0;
    @api max = MAX_DISPLAY;

    get any() {
        return this.total > 0;
    }

    get count() {
        if (this.total > this.max) {
            return ` (${this.max}+)`;
        }
        if (this.total > 0) {
            return ` (${this.total})`;
        }
        return '';
    }
}