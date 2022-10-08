public with sharing class ClearDateService {

    // Update the date for the record tied to a file
    public static void clear(ContentVersion cv, Id recordId){
        if (String.isBlank(cv.Category__c) || String.isBlank(cv.Type__c))
            return;
        // note there is a limit of one cv above, so we can update all of them here
        if (cv.Category__c == 'Dog'){
            clearDogDate(cv, recordId);
        } else{
            // this is related to a contact
            clearContactDate(cv, recordId);
        }
    }

    //#region Generated

    private static void clearContactDate(ContentVersion cv, Id recordId) {
        if (cv.Category__c == 'Standalone') return;
 
        string field;
        if (cv.Type__c == 'ContactForm') {
            field = 'ContactFormReceived__c';
        }
        else {
            field = string.format('{0}{1}Received__c', new List<Object>{ cv.Category__c, cv.Type__c.replace(' ', '') });
        }
        string query = string.format('SELECT Id, {0} FROM Contact WHERE Id = :recordId', new List<Object>{ field });
        List<Contact> contacts = Database.query(query);

        if (contacts.size() == 0)
            return;
        Contact contact = contacts[0];
        
        if (cv.Category__c == 'ADSiM'){
            clearADSiMDate(cv, contact);
        }
        
        if (cv.Category__c == 'Board'){
            clearBoardDate(cv, contact);
        }
        
        if (cv.Category__c == 'Client'){
            clearClientDate(cv, contact);
        }
        
        if (cv.Category__c == 'Facilitator'){
            clearFacilitatorDate(cv, contact);
        }
        
        if (cv.Category__c == 'Puppy'){
            clearPuppyDate(cv, contact);
        }
        
        if (cv.Category__c == 'Staff'){
            clearStaffDate(cv, contact);
        }
        
        if (cv.Category__c == 'Trainer'){
            clearTrainerDate(cv, contact);
        }
        
        if (cv.Category__c == 'Volunteer'){
            clearVolunteerDate(cv, contact);
        }

        if (cv.Type__c == 'ContactForm'){
            contact.ContactFormReceived__c = null;
        }
        update contact;
    }

    // Clear the last date when the category is ADSiM
    private static void clearADSiMDate(ContentVersion cv, Contact contact) {
        if (cv.Type__c == 'Application'){
            contact.ADSiMApplicationReceived__c = null;
        }

        if (cv.Type__c == 'PreApplication'){
            contact.ADSiMPreApplicationReceived__c = null;
        }

        if (cv.Type__c == 'ProgAgreement'){
            contact.ADSiMProgAgreementReceived__c = null;
        }
    }

    // Clear the last date when the category is Board
    private static void clearBoardDate(ContentVersion cv, Contact contact) {
        if (cv.Type__c == 'Agreement'){
            contact.BoardAgreementReceived__c = null;
        }

        if (cv.Type__c == 'Application'){
            contact.BoardApplicationReceived__c = null;
        }

        if (cv.Type__c == 'CoI'){
            contact.BoardCoIReceived__c = null;
        }

        if (cv.Type__c == 'Resume'){
            contact.BoardResumeReceived__c = null;
        }

        if (cv.Type__c == 'ToN'){
            contact.BoardToNReceived__c = null;
        }
    }

    // Clear the last date when the category is Client
    private static void clearClientDate(ContentVersion cv, Contact contact) {
        if (cv.Type__c == 'Application'){
            contact.ClientApplicationReceived__c = null;
        }

        if (cv.Type__c == 'CertAgreement'){
            contact.ClientCertAgreementReceived__c = null;
        }

        if (cv.Type__c == 'LOMI'){
            contact.ClientLOMIReceived__c = null;
        }

        if (cv.Type__c == 'PreApplication'){
            contact.ClientPreApplicationReceived__c = null;
        }

        if (cv.Type__c == 'ProgAgreement'){
            contact.ClientProgAgreementReceived__c = null;
        }

        if (cv.Type__c == 'Survey'){
            contact.ClientSurveyReceived__c = null;
        }

        if (cv.Type__c == 'VAPW'){
            contact.ClientVAPWReceived__c = null;
        }
    }

    // Clear the last date when the category is Facilitator
    private static void clearFacilitatorDate(ContentVersion cv, Contact contact) {
        if (cv.Type__c == 'Application'){
            contact.FacilitatorApplicationReceived__c = null;
        }

        if (cv.Type__c == 'CertAgreement'){
            contact.FacilitatorCertAgreementReceived__c = null;
        }

        if (cv.Type__c == 'InfrNotice'){
            contact.FacilitatorInfrNoticeReceived__c = null;
        }

        if (cv.Type__c == 'Practicum'){
            contact.FacilitatorPracticumReceived__c = null;
        }

        if (cv.Type__c == 'ProfGrowthPlan'){
            contact.FacilitatorProfGrowthPlanReceived__c = null;
        }

        if (cv.Type__c == 'ProgAgreement'){
            contact.FacilitatorProgAgreementReceived__c = null;
        }

        if (cv.Type__c == 'Reference'){
            contact.FacilitatorReferenceReceived__c = null;
        }
    }

    // Clear the last date when the category is Puppy
    private static void clearPuppyDate(ContentVersion cv, Contact contact) {
        if (cv.Type__c == 'Application'){
            contact.PuppyApplicationReceived__c = null;
        }

        if (cv.Type__c == 'CertAgreement'){
            contact.PuppyCertAgreementReceived__c = null;
        }

        if (cv.Type__c == 'Contract'){
            contact.PuppyContractReceived__c = null;
        }

        if (cv.Type__c == 'InfrNotice'){
            contact.PuppyInfrNoticeReceived__c = null;
        }

        if (cv.Type__c == 'ProgAgreement'){
            contact.PuppyProgAgreementReceived__c = null;
        }

        if (cv.Type__c == 'Reference'){
            contact.PuppyReferenceReceived__c = null;
        }
    }

    // Clear the last date when the category is Staff
    private static void clearStaffDate(ContentVersion cv, Contact contact) {
        if (cv.Type__c == 'Agreement'){
            contact.StaffAgreementReceived__c = null;
        }

        if (cv.Type__c == 'Application'){
            contact.StaffApplicationReceived__c = null;
        }

        if (cv.Type__c == 'I9'){
            contact.StaffI9Received__c = null;
        }

        if (cv.Type__c == 'Offer'){
            contact.StaffOfferReceived__c = null;
        }

        if (cv.Type__c == 'Resume'){
            contact.StaffResumeReceived__c = null;
        }

        if (cv.Type__c == 'W4'){
            contact.StaffW4Received__c = null;
        }

        if (cv.Type__c == 'W9'){
            contact.StaffW9Received__c = null;
        }
    }

    // Clear the last date when the category is Trainer
    private static void clearTrainerDate(ContentVersion cv, Contact contact) {
        if (cv.Type__c == 'Application'){
            contact.TrainerApplicationReceived__c = null;
        }

        if (cv.Type__c == 'CertAgreement'){
            contact.TrainerCertAgreementReceived__c = null;
        }

        if (cv.Type__c == 'InfrNotice'){
            contact.TrainerInfrNoticeReceived__c = null;
        }

        if (cv.Type__c == 'ProgAgreement'){
            contact.TrainerProgAgreementReceived__c = null;
        }

        if (cv.Type__c == 'Reference'){
            contact.TrainerReferenceReceived__c = null;
        }
    }

    // Clear the last date when the category is Volunteer
    private static void clearVolunteerDate(ContentVersion cv, Contact contact) {
        if (cv.Type__c == 'Agreement'){
            contact.VolunteerAgreementReceived__c = null;
        }

        if (cv.Type__c == 'Application'){
            contact.VolunteerApplicationReceived__c = null;
        }

        if (cv.Type__c == 'Resume'){
            contact.VolunteerResumeReceived__c = null;
        }
    }

    private static void clearDogDate(ContentVersion cv, Id recordId) {
        string  field = string.format('{0}Received__c', new List<Object>{ cv.Type__c.replace(' ', '') });
        string query = string.format('SELECT Id, {0} FROM Dog__c WHERE Id = :recordId', new List<Object>{ field });
        List<Dog__c> dogs = Database.query(query);

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];

        if (cv.Type__c == 'HealthForm'){
            dog.HealthFormReceived__c = null;
        }

        if (cv.Type__c == 'VacExams'){
            dog.VacExamsReceived__c = null;
        }

        if (cv.Type__c == 'Xray'){
            dog.XrayReceived__c = null;
        }

        update dog;
    }
    //#endregion Generated code
}