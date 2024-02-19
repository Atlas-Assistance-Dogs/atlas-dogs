import { LightningElement, api, wire } from 'lwc';
import getOwners from "@salesforce/apex/DogController.getOwners";

export default class EmailOwnersCmp extends LightningElement {
    @api recordIds;
    items = [
        {
            label: 'Contact1',
            href: 'https://www.example.com',
            name: 'contact1'
        },
        {
            label: 'Contact2',
            href: 'https://www.example.com',
            name: 'contact2'
        }
    ];
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