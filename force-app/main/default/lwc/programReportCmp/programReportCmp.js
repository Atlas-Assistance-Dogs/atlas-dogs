import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import getReport from "@salesforce/apex/ProgramAssignmentController.getReport";
import { refreshApex } from "@salesforce/apex";

import ASSIGNED_DATE_FIELD from "@salesforce/schema/ProgramAssignment__c.AssignedDate__c";
import CONTACT_FIELD from "@salesforce/schema/ProgramAssignment__c.Contact__c";
import PRONOUN_FIELD from "@salesforce/schema/Contact.Pronoun__c";
import PREFERRED_NAME_FIELD from "@salesforce/schema/Contact.PreferredName__c";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import ADDRESS_FIELD from "@salesforce/schema/Contact.MailingAddress";
import ABILITY_STATUS_FIELD from "@salesforce/schema/Contact.AbilityStatus__c";
import SPECIFIED_ABILITY_STATUS_FIELD from "@salesforce/schema/Contact.SpecifiedAbilityStatus__c";
import DOG_AGE_FIELD from "@salesforce/schema/Dog__c.AgeYears__c";
import DOG_BREED_FIELD from "@salesforce/schema/Dog__c.Breed__c";
import DOG_GENDER_FIELD from "@salesforce/schema/Dog__c.Gender__c";
import STATUS_FIELD from "@salesforce/schema/ProgramAssignment__c.Status__c";

const COLS = [
    { label: "Status", fieldName: STATUS_FIELD.fieldApiName },
    {
        label: "Assigned Date",
        fieldName: ASSIGNED_DATE_FIELD.fieldApiName,
        type: "date-local"
    },
    {
        label: "Contact Name",
        fieldName: "contactName",
        type: "button",
        typeAttributes: {
            name: "contact",
            label: { fieldName: "contactName" },
            variant: "base"
        }
    },
    {
        label: "Preferred Name",
        fieldName: PREFERRED_NAME_FIELD.fieldApiName
    },
    {
        label: "Pronoun",
        fieldName: PRONOUN_FIELD.fieldApiName
    },
    { label: "Email", fieldName: EMAIL_FIELD.fieldApiName },
    { label: "Address", fieldName: "address" },
    { label: "Ability Status", fieldName: ABILITY_STATUS_FIELD.fieldApiName },
    {
        label: "Specified Ability Status",
        fieldName: SPECIFIED_ABILITY_STATUS_FIELD.fieldApiName
    },
    {
        label: "Dog Name",
        fieldName: "dogName",
        type: "button",
        typeAttributes: {
            name: "dog",
            label: { fieldName: "dogName" },
            variant: "base"
        }
    },
    {
        label: "Age",
        fieldName: DOG_AGE_FIELD.fieldApiName
    },
    {
        label: "Breed",
        fieldName: DOG_BREED_FIELD.fieldApiName
    },
    {
        label: "Gender",
        fieldName: DOG_GENDER_FIELD.fieldApiName
    }
];

export default class ProgramReportCmp extends NavigationMixin(
    LightningElement
) {
    @api program;
    @api viewAll;
    columns = COLS;
    data = [];
    wiredReport;
    total = 0;

    defaultSortDirection = "asc";
    sortDirection = "asc";
    sortedBy;

    // Used to sort the 'Age' column
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.data];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === "asc" ? 1 : -1));
        this.data = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case "contact":
                this.navigateToRecord(row[CONTACT_FIELD.fieldApiName]);
                break;
            case "dog":
                this.navigateToRecord(row.dogId);
                break;
        }
    }

    navigateToRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                recordId: recordId,
                actionName: "view"
            }
        });
    }

    @wire(getReport, { name: "$program" })
    getReprt(result) {
        this.wiredReport = result;
        this.data = null;
        if (result.data) {
            this.data = result.data.items.map((info) => {
                var row = Object.assign({}, info.pa, info.contact, info.dog);
                row.contactName = info.contact.Name;
                const address = info.contact[ADDRESS_FIELD.fieldApiName];
                row.address = `${address.city}, ${address.state}`;
                row.dogName = info.dog.Name;
                row.dogId = info.dog.Id;
                row.Name = info.pa.Name;
                row.Id = info.pa.Id;
                return row;
            });
            if (this.data.length === 0) {
                this.data = null;
                this.total = 0;
            }
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

    handleChange() {
        refreshApex(this.wiredCeus);
    }

    createCsv(cols, data) {
        const header = cols.map(c => c.label).join(',');
        const rows = data.map(x => {
            const rowData = cols.map(c => {
                let text = '';
                if (c.fieldName) {
                    text = x[c.fieldName];
                }
                else {
                    text = x[c.typeAttributes.fieldName];
                }
                if (typeof text === 'string' && text.includes(',')) {
                    return `"${text}"`;
                }
                return text;
            });
            return rowData.join(',');
        });
        return [header].concat(rows).join('\n');
    }

    download() {
        const filename = `${this.program}.csv`;
        const content = this.createCsv(this.columns, this.data);
        var element = document.createElement("a");
        element.setAttribute(
            "href",
            "data:text/plain;charset=utf-8," + encodeURIComponent(content)
        );
        element.setAttribute("download", filename);

        element.style.display = "none";
        document.body.appendChild(element);

        element.click();

        document.body.removeChild(element);
    }
}
