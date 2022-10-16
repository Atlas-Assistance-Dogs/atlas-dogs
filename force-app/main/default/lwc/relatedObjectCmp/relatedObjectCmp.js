import { LightningElement, wire, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { getRecord } from "lightning/uiRecordApi";
import DOG_OBJECT from "@salesforce/schema/Dog__c";

const MAX_DISPLAY = 6;
export default class RelatedObjectCmp extends NavigationMixin(
    LightningElement
) {
    @api viewAll = "";
    @api iconName = "standard:folder";
    @api title = "Related Objects";
    @api total = 0;
    @api max = MAX_DISPLAY;
    @api recordId;
    @api auraCompName;
    @api objectApiName;

    get any() {
        return !this.viewAll && this.total > 0;
    }

    get count() {
        if (this.viewAll) return "";

        if (this.total > this.max) {
            return ` (${this.max}+)`;
        }
        if (this.total > 0) {
            return ` (${this.total})`;
        }
        return "";
    }

    namespace() {
        const regx = /([^_]+)__([^_]+__c)/;
        const match = this.objectApiName.match(regx);
        return match ? match[1] : "c";
    }

    handleViewAll() {
        const nsp = this.namespace(DOG_OBJECT.objectApiName);
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
    // Added for view all
    name = "Sample";
    list = "Object";

    @wire(getRecord, { recordId: "$recordId", layoutTypes: "Compact" })
    wiredRecord({ error, data }) {
        this.record = data;
        if (error) {
            this.dispatchToast(error);
        } else if (data) {
            this.objectApiName = data.apiName;
            this.name =
                data.apiName === "Contact"
                    ? [
                          data.fields.FirstName.value,
                          data.fields.LastName.value
                      ].join(" ")
                    : data.fields.Name?.value ?? data.apiName;
            const parts = data.apiName.split("__").filter((x) => x !== "c");
            const objectName = parts[parts.length - 1];
            this.list = objectName + "s";
        }
    }

    // Helper
    dispatchToast(error) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: "Error loading contact",
                message: error,
                variant: "error"
            })
        );
    }

    navigateToList(event) {
        this[NavigationMixin.Navigate]({
            type: "standard__objectPage",
            attributes: {
                objectApiName: this.objectApiName,
                actionName: "list"
            }
        });
    }

    navigateToObject(event) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: this.recordId,
                objectApiName: this.objectApiName,
                actionName: "view"
            }
        });
    }
}
