import { LightningElement, api, wire, track } from "lwc";
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

// Import message service features required for subscribing and the message channel
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from "lightning/messageService";
import puppyLogForm from "@salesforce/messageChannel/puppyLogForm__c";

export default class NewPuppyLogCmp extends NavigationMixin(LightningElement) {
    @api objectApiName;
    @api recordId;
    @api contactId = "";
    message;
    title = "Puppy Raiser Log";

    // https://customization-business-8103-dev-ed.lightning.force.com/lightning/r/PuppyLog__c/a1A17000003kzz4EAA/edit?navigationLocation=RELATED_LIST_ROW&inContextOfRef={}&count=1
    @wire(CurrentPageReference)
    getTypeParameter(currentPageReference) {
        if (currentPageReference) {
            this.navigationLocation = currentPageReference.state?.navigationLocation;
            let base64Context = currentPageReference.state?.inContextOfRef;
            if (base64Context) {
                if (base64Context.startsWith("1\.")) {
                    base64Context = base64Context.substring(2);
                }
                let addressableContext = JSON.parse(window.atob(base64Context));

                this.parentAttributes = addressableContext.attributes;
            }
        }
    }

    @api
    openModal() {
        this.message = "";
        this.template.querySelector("c-modal-cmp").openModal();
    }
    closeModal() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleSubmit(event) {
        event.preventDefault();
        this.template
            .querySelector("c-puppy-log-form-cmp")
            .handleSubmit(event);
    }

    // Standard lifecycle hooks used run when loaded
    renderedCallback() {
        this.template.querySelector("c-modal-cmp").openModal();
    }

    handleSourceChange(event) {
        this.showSourceOther = event.detail.value === "Other";
    }
//0031700001Nx5veAAB
    onChanged(event) {
        this.dispatchEvent(new CustomEvent("changed"));
        this.closeModal();
        if (this.parentAttributes) {
            this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: this.parentAttributes
            });
        }
        else {
            this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: {
                    recordId: event.detail.id,
                    objectApiName: this.object,
                    actionName: "view"
                }
            });
        }
    }

    @wire(MessageContext)
    messageContext;

    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                puppyLogForm,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    // Handler for message received by component
    handleMessage(message) {
        this.recordId = message.recordId;
        refreshApex();
        this.openModal();
    }

    // Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }
}