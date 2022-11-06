public with sharing class FileService{
    // Update the docDate for the record tied to these files.
    // Must all be linked to the same entity
    public static void updateDates(List<ContentVersion> cvs){
        if (cvs == null || cvs.size() == 0)
            return;
        ContentVersion cv = [SELECT Id, ContentDocumentId, Category__c, Type__c, Date__c
                             FROM ContentVersion
                             WHERE Id = :cvs[0].Id
                             LIMIT 1];
        Id recordId;
        // find the record tied to these cvs
        for (ContentDocumentLink cntLink : [SELECT Id, LinkedEntityId
                                            FROM ContentDocumentLink
                                            WHERE ContentDocumentId = :cv.ContentDocumentId]){
            if (String.isBlank(cv.Category__c) || String.isBlank(cv.Type__c)){
                continue;
            }
            // note there is a limit of one cv above, so we can update all of them here
            if (cv.Category__c == 'Dog'){
                updateDogDate(cvs, cntLink.LinkedEntityId);
            } else{
                // this is related to a contact
                updateContactDate(cvs, cntLink.LinkedEntityId);
            }
        }
    }

    // Update the date for the record tied to a file
    public static void updateDate(ContentVersion cv){
        if (String.isBlank(cv.Category__c) || String.isBlank(cv.Type__c))
            return;
        // nothing to do here
        cv = [SELECT Id, ContentDocumentId, Category__c, Type__c, Date__c
              FROM ContentVersion
              WHERE Id = :cv.Id
              LIMIT 1];
        // find the record tied to this cv
        for (ContentDocumentLink cntLink : [SELECT Id, LinkedEntityId
                                            FROM ContentDocumentLink
                                            WHERE ContentDocumentId = :cv.ContentDocumentId]){
            updateDate(cv, cntLink.LinkedEntityId);
        }
    }

    // Update the last docDate for a file
    public static void updateDate(ContentVersion cv, Id recordId){
        if (String.isBlank(cv.Category__c) || String.isBlank(cv.Type__c))
            return;
        if (cv.Category__c == 'Dog'){
            updateDogDate(new List<ContentVersion>{ cv }, recordId);
        } else{
            // this is related to a contact
            updateContactDate(new List<ContentVersion>{ cv }, recordId);
        }
    }

    // Determine if the proposed date is later than the current.
    // Never is considered before everything else.
    private static Boolean isLater(Date current, Date proposed){
        return current == null || current < proposed;
    }

    //#region Generated Contact

    // Update the last received docDate for the contact for the document category and type
    private static void updateContactDate(List<ContentVersion> cvs, Id recordId) {
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {
            ids.add(cv.Id);
        }
        List<Contact> contacts = [
            SELECT Id,
                ADSiMApplicationReceived__c, ADSiMPreApplicationReceived__c, ADSiMProgAgreementReceived__c,
				BoardAgreementReceived__c, BoardApplicationReceived__c, BoardCoIReceived__c, BoardResumeReceived__c, BoardToNReceived__c,
				ClientApplicationReceived__c, ClientCertAgreementReceived__c, ClientLOMIReceived__c, ClientPreApplicationReceived__c, ClientProgAgreementReceived__c, ClientSurveyReceived__c, ClientVAPWReceived__c,
				FacilitatorApplicationReceived__c, FacilitatorCertAgreementReceived__c, FacilitatorInfrNoticeReceived__c, FacilitatorPracticumReceived__c, FacilitatorProfGrowthPlanReceived__c, FacilitatorProgAgreementReceived__c, FacilitatorReferenceReceived__c,
				PuppyApplicationReceived__c, PuppyCertAgreementReceived__c, PuppyContractReceived__c, PuppyInfrNoticeReceived__c, PuppyProgAgreementReceived__c, PuppyReferenceReceived__c,
				StaffAgreementReceived__c, StaffApplicationReceived__c, StaffI9Received__c, StaffOfferReceived__c, StaffResumeReceived__c, StaffW4Received__c, StaffW9Received__c,
				TrainerApplicationReceived__c, TrainerCertAgreementReceived__c, TrainerInfrNoticeReceived__c, TrainerProgAgreementReceived__c, TrainerReferenceReceived__c,
				VolunteerAgreementReceived__c, VolunteerApplicationReceived__c, VolunteerResumeReceived__c,
				ContactFormReceived__c
            FROM Contact
            WHERE Id = :recordId];

        if (contacts.size() == 0)
            return;
        Contact contact = contacts[0];
        // Get the Date, order asc so we update the field with the last received
        cvs = [SELECT Category__c, Type__c, Date__c
               FROM ContentVersion
               WHERE Id IN:ids
               ORDER BY Date__c];

        for (ContentVersion cv : cvs) {        
            if (cv.Category__c == 'ADSiM'){
                updateADSiMDate(cv, contact);
            }
        
            if (cv.Category__c == 'Board'){
                updateBoardDate(cv, contact);
            }
        
            if (cv.Category__c == 'Client'){
                updateClientDate(cv, contact);
            }
        
            if (cv.Category__c == 'Facilitator'){
                updateFacilitatorDate(cv, contact);
            }
        
            if (cv.Category__c == 'Puppy'){
                updatePuppyDate(cv, contact);
            }
        
            if (cv.Category__c == 'Staff'){
                updateStaffDate(cv, contact);
            }
        
            if (cv.Category__c == 'Trainer'){
                updateTrainerDate(cv, contact);
            }
        
            if (cv.Category__c == 'Volunteer'){
                updateVolunteerDate(cv, contact);
            }

            if (cv.Type__c == 'ContactForm' && isLater(contact.ContactFormReceived__c, cv.Date__c)){
                contact.ContactFormReceived__c = cv.Date__c;
            }
        }
        update contact;
    }

    // Update the last date when the category is ADSiM
    private static void updateADSiMDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Application' && isLater(contact.ADSiMApplicationReceived__c, cv.Date__c)){
            contact.ADSiMApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'PreApplication' && isLater(contact.ADSiMPreApplicationReceived__c, cv.Date__c)){
            contact.ADSiMPreApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProgAgreement' && isLater(contact.ADSiMProgAgreementReceived__c, cv.Date__c)){
            contact.ADSiMProgAgreementReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Board
    private static void updateBoardDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Agreement' && isLater(contact.BoardAgreementReceived__c, cv.Date__c)){
            contact.BoardAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Application' && isLater(contact.BoardApplicationReceived__c, cv.Date__c)){
            contact.BoardApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CoI' && isLater(contact.BoardCoIReceived__c, cv.Date__c)){
            contact.BoardCoIReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Resume' && isLater(contact.BoardResumeReceived__c, cv.Date__c)){
            contact.BoardResumeReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ToN' && isLater(contact.BoardToNReceived__c, cv.Date__c)){
            contact.BoardToNReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Client
    private static void updateClientDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Application' && isLater(contact.ClientApplicationReceived__c, cv.Date__c)){
            contact.ClientApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CertAgreement' && isLater(contact.ClientCertAgreementReceived__c, cv.Date__c)){
            contact.ClientCertAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'LOMI' && isLater(contact.ClientLOMIReceived__c, cv.Date__c)){
            contact.ClientLOMIReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'PreApplication' && isLater(contact.ClientPreApplicationReceived__c, cv.Date__c)){
            contact.ClientPreApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProgAgreement' && isLater(contact.ClientProgAgreementReceived__c, cv.Date__c)){
            contact.ClientProgAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Survey' && isLater(contact.ClientSurveyReceived__c, cv.Date__c)){
            contact.ClientSurveyReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'VAPW' && isLater(contact.ClientVAPWReceived__c, cv.Date__c)){
            contact.ClientVAPWReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Facilitator
    private static void updateFacilitatorDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Application' && isLater(contact.FacilitatorApplicationReceived__c, cv.Date__c)){
            contact.FacilitatorApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CertAgreement' && isLater(contact.FacilitatorCertAgreementReceived__c, cv.Date__c)){
            contact.FacilitatorCertAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'InfrNotice' && isLater(contact.FacilitatorInfrNoticeReceived__c, cv.Date__c)){
            contact.FacilitatorInfrNoticeReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Practicum' && isLater(contact.FacilitatorPracticumReceived__c, cv.Date__c)){
            contact.FacilitatorPracticumReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProfGrowthPlan' && isLater(contact.FacilitatorProfGrowthPlanReceived__c, cv.Date__c)){
            contact.FacilitatorProfGrowthPlanReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProgAgreement' && isLater(contact.FacilitatorProgAgreementReceived__c, cv.Date__c)){
            contact.FacilitatorProgAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Reference' && isLater(contact.FacilitatorReferenceReceived__c, cv.Date__c)){
            contact.FacilitatorReferenceReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Puppy
    private static void updatePuppyDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Application' && isLater(contact.PuppyApplicationReceived__c, cv.Date__c)){
            contact.PuppyApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CertAgreement' && isLater(contact.PuppyCertAgreementReceived__c, cv.Date__c)){
            contact.PuppyCertAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Contract' && isLater(contact.PuppyContractReceived__c, cv.Date__c)){
            contact.PuppyContractReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'InfrNotice' && isLater(contact.PuppyInfrNoticeReceived__c, cv.Date__c)){
            contact.PuppyInfrNoticeReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProgAgreement' && isLater(contact.PuppyProgAgreementReceived__c, cv.Date__c)){
            contact.PuppyProgAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Reference' && isLater(contact.PuppyReferenceReceived__c, cv.Date__c)){
            contact.PuppyReferenceReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Staff
    private static void updateStaffDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Agreement' && isLater(contact.StaffAgreementReceived__c, cv.Date__c)){
            contact.StaffAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Application' && isLater(contact.StaffApplicationReceived__c, cv.Date__c)){
            contact.StaffApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'I9' && isLater(contact.StaffI9Received__c, cv.Date__c)){
            contact.StaffI9Received__c = cv.Date__c;
        }

        if (cv.Type__c == 'Offer' && isLater(contact.StaffOfferReceived__c, cv.Date__c)){
            contact.StaffOfferReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Resume' && isLater(contact.StaffResumeReceived__c, cv.Date__c)){
            contact.StaffResumeReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'W4' && isLater(contact.StaffW4Received__c, cv.Date__c)){
            contact.StaffW4Received__c = cv.Date__c;
        }

        if (cv.Type__c == 'W9' && isLater(contact.StaffW9Received__c, cv.Date__c)){
            contact.StaffW9Received__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Trainer
    private static void updateTrainerDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Application' && isLater(contact.TrainerApplicationReceived__c, cv.Date__c)){
            contact.TrainerApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CertAgreement' && isLater(contact.TrainerCertAgreementReceived__c, cv.Date__c)){
            contact.TrainerCertAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'InfrNotice' && isLater(contact.TrainerInfrNoticeReceived__c, cv.Date__c)){
            contact.TrainerInfrNoticeReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProgAgreement' && isLater(contact.TrainerProgAgreementReceived__c, cv.Date__c)){
            contact.TrainerProgAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Reference' && isLater(contact.TrainerReferenceReceived__c, cv.Date__c)){
            contact.TrainerReferenceReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Volunteer
    private static void updateVolunteerDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Agreement' && isLater(contact.VolunteerAgreementReceived__c, cv.Date__c)){
            contact.VolunteerAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Application' && isLater(contact.VolunteerApplicationReceived__c, cv.Date__c)){
            contact.VolunteerApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Resume' && isLater(contact.VolunteerResumeReceived__c, cv.Date__c)){
            contact.VolunteerResumeReceived__c = cv.Date__c;
        }
    }

    // Update the last received docDate for the dog for the document type
    private static void updateDogDate(List<ContentVersion> cvs, Id recordId) {
        // this is related to a dog
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {
            ids.add(cv.Id);
        }
        List<Dog__c> dogs = [
            SELECT Id, HealthFormReceived__c, VacExamsReceived__c, XrayReceived__c
            FROM Dog__c
            WHERE Id = :recordId];

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];
        // Make sure we have Date__c, and last of these is last in
        // the list so we update the field correctly
        cvs = [SELECT Date__c, Type__c
               FROM ContentVersion
               WHERE Id IN:ids
               ORDER BY Date__c];

        //#region Generated dog
        for (ContentVersion cv : cvs) {

        if (cv.Type__c == 'HealthForm' && isLater(dog.HealthFormReceived__c, cv.Date__c)){
            dog.HealthFormReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'VacExams' && isLater(dog.VacExamsReceived__c, cv.Date__c)){
            dog.VacExamsReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Xray' && isLater(dog.XrayReceived__c, cv.Date__c)){
            dog.XrayReceived__c = cv.Date__c;
        }
        }
        update dog;
    }
    //#endregion Generated code
}