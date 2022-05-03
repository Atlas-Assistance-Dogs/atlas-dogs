import { LightningElement, api } from "lwc";

export default class RelatedObjectCmp extends LightningElement {
    @api iconName = "standard:folder";
    @api title = "Related Objects";
}