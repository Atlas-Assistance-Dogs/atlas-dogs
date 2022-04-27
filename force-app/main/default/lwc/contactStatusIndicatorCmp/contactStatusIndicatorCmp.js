import { LightningElement, api } from "lwc";

export default class ContactStatusIndicatorCmp extends LightningElement {
    @api status;
    @api position;

    get image() {
        switch (this.status) {
            case "Initial Inquiry":
                return "/img/icon/omni24.png";
            case "Onboarding":
                return "/img/icon/sossession32.png";
            case "In Training":
            case "Prospective":
                return "/img/icon/csquestions32.png";
            case "Certified":
            case "Active":
                return "/img/msg_icons/confirm32.png";
            case "Inactive":
                return "/img/icon/resourceAbsence32.png";
            case "Suspended":
                return "/img/msg_icons/error32.png";
            default:
                return "/img/x.gif";
        }
    }
}
