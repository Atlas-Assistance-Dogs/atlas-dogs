import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class NewLead extends NavigationMixin(LightningElement) {

    handleSubmit(){
        const evt = new ShowToastEvent({
            title: "Record Submission",
            message: "Submitted",
            variant: "success"
        });
        this.dispatchEvent(evt);
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Lead created",
            message: "Lead created" ,
            variant: "success"
        });
        this.dispatchEvent(evt);

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                objectApiName: 'Lead',
                actionName: 'view'
            }
        });

    }

    handleCancel(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Lead',
                actionName: 'home'
            }
        });
    }

}