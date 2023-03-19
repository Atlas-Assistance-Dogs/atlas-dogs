import { LightningElement, track, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateRecords from "@salesforce/apex/FileController.updateRecords";
import getCategoriesForObject from "@salesforce/apex/CategoryRuleController.getCategoriesForObject";
import { NavigationMixin } from "lightning/navigation";

import CATEGORY_FIELD from "@salesforce/schema/ContentVersion.Category__c";
import TYPE_FIELD from "@salesforce/schema/ContentVersion.Type__c";
import DATE_FIELD from "@salesforce/schema/ContentVersion.Date__c";

export default class DocumentUploadCmp extends NavigationMixin(LightningElement) {
    @api recordId;
    @track fileUploadList = [];
    @track fileIDs = [];
    isErrorMessage = false;
    message = "";
    fileName;
    category = "Client";
    type = 'Contact Form';
    categories = [];
    types = [];

    fields = {
        category: CATEGORY_FIELD,
        type: TYPE_FIELD,
        date: DATE_FIELD
    };

    get acceptedFormats() {
        return [
            ".pdf",
            ".png",
            ".jpg",
            ".jpeg",
            ".doc",
            ".docx",
            ".txt",
            ".xlsx",
            ".xls",
            ".csv",
            ".mov",
            ".mp4",
            ".zip"
        ];
    }
    categories = [];
    category = null;

    @wire(getCategoriesForObject, { recordId: "$recordId" })
    getCategories({ error, result }) {
        if (result) {
            this.categories = result.data.map((x) => {
                return { label: x, value: x };
            });
            if (this.categories.length == 1) {
                this.category = this.categories[0];
            }
        } else if (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error!!",
                    message: error.body.message,
                    variant: "error"
                })
            );
        }
    }

    handleCategoryChange(event) {
        this.category = event.detail.value;
    }

    handleTypeChange(event) {
        this.type = event.detail.value;
    }

    @api
    openModal() {
        this.message = "";
        this.template.querySelector("c-modal-cmp").openModal();
    }
    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleUploadFinished(event) {
        this.isErrorMessage = false;
        this.message = "File Uploaded Successfully";
        const uploadedFiles = event.detail.files.map((doc) => doc.documentId);
        this.updateFiles(
            this.template.querySelector(".category").value,
            this.template.querySelector(".type").value,
            this.template.querySelector(".date").value,
            uploadedFiles
        );
    }

    handleSubmit(event) {
        event.preventDefault();
        this.closeModal();
    }

    updateFiles(category, docType, date, files) {
        updateRecords({
            category: category,
            docType: docType,
            docDate: date,
            docIds: files
        })
            .then((data) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Files Assigned to Category and Type",
                        message: data,
                        variant: "success"
                    })
                );
                this.dispatchEvent(new CustomEvent("update"));
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error!!",
                        message: error.body.message,
                        variant: "error"
                    })
                );
            });
    }
}
