import { LightningElement, api } from "lwc";

export default class ContactStatusIndicatorCmp extends LightningElement {
    @api status;
    @api position;

    get image() {
        switch (this.status) {
            case "Initial Inquiry":
                return "standard:question_feed";
            case "Onboarding":
                return "standard:flow";
            case "In ADSiM":
            case "In Training":
            case "In Progress":
                return "standard:education";
            case "Prospective":
                return "/img/icon/livechatvisitor32.png";
            case "Certified":
            case "Active":
            case "Completed":
                return "standard:task2";
            case "Inactive":
            case "On Hold":
            case "Discontinued":
                return "standard:waits";
            default:
                return "standard:empty";
        }
    }
}
