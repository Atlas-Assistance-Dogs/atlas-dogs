import { LightningElement, api } from 'lwc';

export default class SelectOptionCmp extends LightningElement {
    @api items = [{
        label: 'Option',
        name: 'option',
        placeholder: 'Select Option',
        options: [
            {label: 'Option 1', value: 'Option 1'},
            {label: 'Option 2', value: 'Option 2'},
            {label: 'Option 3', value: 'Option 3'}
        ]}
    ];
    @api title;

    @api open(title, options) {
        if (title) {
            this.title = title;
        }
        if (options) {
            this.items = options;
        }       
        this.template.querySelector("c-modal-cmp").openModal();
    }

    handleCancel() {
        this.template.querySelector("c-modal-cmp").closeModal();
    }

    handleSubmit() {
        const boxes = this.template.querySelectorAll('lightning-combobox');
        let items = [];
        for (var idx = 0; idx < this.items.length; idx++) {
            const box = boxes[idx];
            items.push({name: box.name, value: box.value});
        }
        this.dispatchEvent(new CustomEvent("selected", { detail: items }));
        this.template.querySelector("c-modal-cmp").closeModal();
    }
}