import { LightningElement, api } from "lwc";

export default class ContactStatusIndicatorCmp extends LightningElement {
  @api status;
  @api position;

  get image() {
    switch (this.status) {
      case "Initial Inquiry":
      case "Prospective":
        return "standard:question_feed";
      case "Onboarding":
        return "standard:flow";
      case "In ADSiM":
      case "In Training":
      case "In Progress":
        return "standard:education";
      case "Certified-Active":
      case "Certified":
      case "Active":
      case "Completed":
        return "standard:task2";
      case "Action Needed Soon":
        return "custom:custom82";
      case "Action Needed":
        return "standard:actions_and_buttons";
      case "Inactive":
      case "On Hold": // retained to allow production transition
      case "Suspended":
      case "Discontinued":
        return "standard:waits";
      default:
        return "standard:empty";
    }
  }
}
