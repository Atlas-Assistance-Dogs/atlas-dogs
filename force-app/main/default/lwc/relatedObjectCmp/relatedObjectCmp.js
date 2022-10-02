import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

const MAX_DISPLAY = 6;
export default class RelatedObjectCmp extends NavigationMixin(
    LightningElement
) {
    @api iconName = "standard:folder";
    @api title = "Related Objects";
    @api total = 0;
    @api max = MAX_DISPLAY;
    @api recordId;
    @api fieldName;
    @api auraCompName;

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
        return "";
    }

    namespace(fieldApiName) {
        const regx = /([^_]+)__([^_]+__c)/;
        const match = fieldApiName.match(regx);
        return match ? match[1] : "c";
    }

    handleViewAll() {
        const nsp = this.namespace(this.fieldName);
        const component = `${nsp}__${this.auraCompName}`;
        // Navigate to the component.
        this[NavigationMixin.Navigate]({
            type: "standard__component",
            attributes: {
                componentName: component
            },
            state: {
                c__id: this.recordId
            }
        });
    }
}
