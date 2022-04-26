public with sharing class FileService {
    // Update the last received date for the contact for the document category and type
    public static void updateContactDate(Contact contact, ContentVersion cv) {
        if (cv.Category__c == 'Volunteer' && cv.Type__c == 'Application') {
            contact.VolunteerApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Board' && cv.Type__c == 'Application') {
            contact.BoardApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Client' && cv.Type__c == 'Application') {
            contact.ClientApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'TSiM' && cv.Type__c == 'Application') {
            contact.TSiMApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'ADSiM' && cv.Type__c == 'Application') {
            contact.ADSiMApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Facilitator' && cv.Type__c == 'Application') {
            contact.FacilitatorApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Trainer' && cv.Type__c == 'Application') {
            contact.TrainerApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Staff' && cv.Type__c == 'Application') {
            contact.StaffApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Volunteer' && cv.Type__c == 'Agreement') {
            contact.VolunteerAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Board' && cv.Type__c == 'Agreement') {
            contact.BoardAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Staff' && cv.Type__c == 'Agreement') {
            contact.StaffAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Volunteer' && cv.Type__c == 'Resume') {
            contact.VolunteerResumeReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Board' && cv.Type__c == 'Resume') {
            contact.BoardResumeReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Staff' && cv.Type__c == 'Resume') {
            contact.StaffResumeReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Board' && cv.Type__c == 'Conflict of Interest') {
            contact.BoardCoIReceived__c = cv.LastModifiedDate.date();
        }

        if (
            cv.Category__c == 'Board' &&
            cv.Type__c == 'Transmission of Notices'
        ) {
            contact.BoardToNReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Client' && cv.Type__c == 'Pre Application') {
            contact.ClientPreApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'TSiM' && cv.Type__c == 'Pre Application') {
            contact.TSiMPreApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'ADSiM' && cv.Type__c == 'Pre Application') {
            contact.ADSiMPreApplicationReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Client' && cv.Type__c == 'LOMI') {
            contact.ClientLOMIReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Client' && cv.Type__c == 'Veteran Paperwork') {
            contact.ClientVAPWReceived__c = cv.LastModifiedDate.date();
        }

        if (
            cv.Category__c == 'Client' &&
            cv.Type__c == 'Certification Survey'
        ) {
            contact.ClientSurveyReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Client' && cv.Type__c == 'Program Agreement') {
            contact.ClientProgAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'TSiM' && cv.Type__c == 'Program Agreement') {
            contact.TSiMProgAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'ADSiM' && cv.Type__c == 'Program Agreement') {
            contact.ADSiMProgAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (
            cv.Category__c == 'Facilitator' &&
            cv.Type__c == 'Program Agreement'
        ) {
            contact.FacilitatorProgAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Trainer' && cv.Type__c == 'Program Agreement') {
            contact.TrainerProgAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (
            cv.Category__c == 'Client' &&
            cv.Type__c == 'Certification Agreement'
        ) {
            contact.ClientCertAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (
            cv.Category__c == 'Facilitator' &&
            cv.Type__c == 'Certification Agreement'
        ) {
            contact.FacilitatorCertAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (
            cv.Category__c == 'Trainer' &&
            cv.Type__c == 'Certification Agreement'
        ) {
            contact.TrainerCertAgreementReceived__c = cv.LastModifiedDate.date();
        }

        if (
            cv.Category__c == 'Facilitator' &&
            cv.Type__c == 'Reference Letter'
        ) {
            contact.FacilitatorReferenceReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Trainer' && cv.Type__c == 'Reference Letter') {
            contact.TrainerReferenceReceived__c = cv.LastModifiedDate.date();
        }

        if (
            cv.Category__c == 'Facilitator' &&
            cv.Type__c == 'Professional Growth Plan'
        ) {
            contact.FacilitatorProfGrowthPlanReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Facilitator' && cv.Type__c == 'Practicum') {
            contact.FacilitatorPracticumReceived__c = cv.LastModifiedDate.date();
        }

        if (
            cv.Category__c == 'Facilitator' &&
            cv.Type__c == 'Infraction Notice'
        ) {
            contact.FacilitatorInfrNoticeReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Trainer' && cv.Type__c == 'Infraction Notice') {
            contact.TrainerInfrNoticeReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Staff' && cv.Type__c == 'Offer Letter') {
            contact.StaffOfferReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Staff' && cv.Type__c == 'W4') {
            contact.StaffW4Received__c = cv.LastModifiedDate.date();
        }

        if (cv.Category__c == 'Staff' && cv.Type__c == 'I9') {
            contact.StaffI9Received__c = cv.LastModifiedDate.date();
        }
        update contact;
    }

    // Update the last received date for the contact for the document type
    public static void updateDogDate(Dog__c dog, ContentVersion cv) {
        if (cv.Type__c == 'Vet Health Form') {
            dog.HealthFormReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Type__c == 'Vet Xray Report') {
            dog.XrayReceived__c = cv.LastModifiedDate.date();
        }

        if (cv.Type__c == 'Vaccinations and Exams') {
            dog.VacExamsReceived__c = cv.LastModifiedDate.date();
        }
        update dog;
    }
}
