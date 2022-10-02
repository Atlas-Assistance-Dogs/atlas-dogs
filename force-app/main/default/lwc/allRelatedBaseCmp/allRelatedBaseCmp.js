import { LightningElement, api, wire } from "lwc";

import { getRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AllRelatedBaseCmp extends NavigationMixin(
    LightningElement
) {
    @api recordId = "00319000010uTqDAAU";

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
