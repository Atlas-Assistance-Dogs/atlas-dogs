import { LightningElement, api } from 'lwc';
export default class fileUploadLWC extends LightningElement {
    @api recordID;

    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

 
	handleUploadFinished(event) {
		this.files = event.detail.files;
		this.files.forEach((file) => {
			console.log('Uploaded => ', file.documentId, file.name);
		});
	}

}