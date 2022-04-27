import { LightningElement, api } from "lwc";

export default class ContactStatusIndicatorCmp extends LightningElement {
    @api status;
    @api position;

    get image() {
        switch (this.status) {
            case "Initial Inquiry":
                return "/img/icon/questions32.png";
            case "Onboarding":
                return "/img/icon/sossession32.png";
            case "In Training":
            case "In Progress":
                return "/img/rypple/32-coaching.png";
            case "Prospective":
                return "/img/icon/livechatvisitor32.png";
            case "Certified":
            case "Active":
            case "Completed":
                return "/img/msg_icons/confirm32.png";
            case "Inactive":
            case "Discontinued":
                return "/img/msg_icons/warning32.png";
            case "Removed":
            case "Suspended":
                return "/img/msg_icons/error32.png";
            default:
                return "/img/x.gif";
        }
    }
}
