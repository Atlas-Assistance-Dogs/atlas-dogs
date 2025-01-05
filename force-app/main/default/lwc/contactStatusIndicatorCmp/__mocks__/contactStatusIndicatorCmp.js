import { LightningElement, api } from "lwc";

export default class ContactStatusIndicatorCmp extends LightningElement {
  @api status;
  @api position;
}
