import { LightningElement, api, wire } from 'lwc';
import getOwners from "@salesforce/apex/DogController.getOwners";

export default class EmailOwnersCmp extends LightningElement {
    @api recordIds;
    expanded = false;
    wiredOwners = null;

    @wire(getOwners, { recordIds: "$recordIds" })
    getOwners(result) {
        this.wiredOwners = result;
        this.items = result?.data?.map(owner => {
            return {
                label: owner.Name,
                name: owner.Id
            };
        });
    }

    handleItemRemove(event) {
        const name = event.detail.item.name;
        alert(name + ' pill was removed!');
        const index = event.detail.index;
        this.items.splice(index, 1);
    }

    handlePillExpansion() {
        this.expanded = !this.expanded;
    }

    handleClick() {
    }
}