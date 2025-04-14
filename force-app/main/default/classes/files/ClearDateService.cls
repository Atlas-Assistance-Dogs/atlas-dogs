public inherited sharing class ClearDateService {
  // Update the date for the record tied to a file
  public static void clear(ContentVersion cv, Id recordId) {
    if (String.isBlank(cv.Category__c) || String.isBlank(cv.Type__c))
      return;
    // note there is a limit of one cv above, so we can update all of them here
    if (cv.Category__c == 'Dog') {
      clearDogDate(cv, recordId);
    } else if (cv.Category__c == 'Client') {
      clearTeamDate(cv, recordId);
    } else {
      // this is related to a contact
      clearContactDate(cv, recordId);
    }
  }

  //#region Generated

    private static void clearContactDate(ContentVersion cv, Id recordId) {
        List<Contact> contacts = [
            SELECT Id,
                ADSiMApplicationReceived__c, ADSiMPreApplicationReceived__c, ADSiMProgAgreementReceived__c,
				BoardAgreementReceived__c, BoardApplicationReceived__c, BoardCoIReceived__c, BoardResumeReceived__c, BoardToNReceived__c,
				FacilitatorApplicationReceived__c, FacilitatorCertAgreementReceived__c, FacilitatorInfrNoticeReceived__c, FacilitatorPracticumReceived__c, FacilitatorProgAgreementReceived__c, FacilitatorReferenceReceived__c,
				ContactFormReceived__c, FirstAidReceived__c, MediaReceived__c, ParticipationAgreementReceived__c,
				PuppyApplicationReceived__c, PuppyCertAgreementReceived__c, PuppyContractReceived__c, PuppyInfrNoticeReceived__c, PuppyProgAgreementReceived__c, PuppyReferenceReceived__c,
				StaffAgreementReceived__c, StaffApplicationReceived__c, StaffI9Received__c, StaffOfferReceived__c, StaffResumeReceived__c, StaffW4Received__c, StaffW9Received__c,
				StandaloneApplicationReceived__c, StandaloneProgAgreementReceived__c,
				TrainerApplicationReceived__c, TrainerCertAgreementReceived__c, TrainerClientReferenceReceived__c, TrainerInfrNoticeReceived__c, TrainerProfReferenceReceived__c, TrainerProgAgreementReceived__c,
				VolunteerAgreementReceived__c, VolunteerApplicationReceived__c, VolunteerResumeReceived__c
            FROM Contact
            WHERE Id = :recordId];

        if (contacts.size() == 0)
            return;
        Contact contact = contacts[0];
        
        if (cv.Category__c == 'ADSiM') {
            clearADSiMDate(cv, contact);
        }
        
        if (cv.Category__c == 'Board') {
            clearBoardDate(cv, contact);
        }
        
        if (cv.Category__c == 'Facilitator') {
            clearFacilitatorDate(cv, contact);
        }
        
        if (cv.Category__c == 'Na') {
            clearNaDate(cv, contact);
        }
        
        if (cv.Category__c == 'Puppy') {
            clearPuppyDate(cv, contact);
        }
        
        if (cv.Category__c == 'Staff') {
            clearStaffDate(cv, contact);
        }
        
        if (cv.Category__c == 'Standalone') {
            clearStandaloneDate(cv, contact);
        }
        
        if (cv.Category__c == 'Trainer') {
            clearTrainerDate(cv, contact);
        }
        
        if (cv.Category__c == 'Volunteer') {
            clearVolunteerDate(cv, contact);
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

        if (cv.Type__c == 'ProgAgreement'){
            contact.FacilitatorProgAgreementReceived__c = null;
        }

        if (cv.Type__c == 'Reference'){
            contact.FacilitatorReferenceReceived__c = null;
        }
    }

    // Clear the last date when the category is Na
    private static void clearNaDate(ContentVersion cv, Contact contact) {
        if (cv.Type__c == 'ContactForm'){
            contact.ContactFormReceived__c = null;
        }

        if (cv.Type__c == 'FirstAid'){
            contact.FirstAidReceived__c = null;
        }

        if (cv.Type__c == 'Media'){
            contact.MediaReceived__c = null;
        }

        if (cv.Type__c == 'ParticipationAgreement'){
            contact.ParticipationAgreementReceived__c = null;
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

    // Clear the last date when the category is Standalone
    private static void clearStandaloneDate(ContentVersion cv, Contact contact) {
        if (cv.Type__c == 'Application'){
            contact.StandaloneApplicationReceived__c = null;
        }

        if (cv.Type__c == 'ProgAgreement'){
            contact.StandaloneProgAgreementReceived__c = null;
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

        if (cv.Type__c == 'ClientReference'){
            contact.TrainerClientReferenceReceived__c = null;
        }

        if (cv.Type__c == 'InfrNotice'){
            contact.TrainerInfrNoticeReceived__c = null;
        }

        if (cv.Type__c == 'ProfReference'){
            contact.TrainerProfReferenceReceived__c = null;
        }

        if (cv.Type__c == 'ProgAgreement'){
            contact.TrainerProgAgreementReceived__c = null;
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

    private static void clearTeamDate(ContentVersion cv, Id recordId) {
        List<Team__c> teams = [
            SELECT Id, Client__c, Dog__c,
                   ClientApplicationReceived__c, ClientApplicationVideoReceived__c, ClientCGCFormReceived__c, ClientCertAgreementReceived__c, ClientLOMIReceived__c, ClientMentalHealthFormReceived__c, ClientPreApplicationReceived__c, ClientProgAgreementReceived__c, ClientProvRelFormReceived__c, ClientSurveyReceived__c, ClientVAPWReceived__c,
					HealthFormReceived__c, XrayReceived__c
            FROM Team__c
            WHERE Id = :recordId];

        if (teams.size() == 0)
            return;
        Team__c team = teams[0];

        if (cv.Type__c == 'Application'){
            team.ClientApplicationReceived__c = null;
        }

        if (cv.Type__c == 'ApplicationVideo'){
            team.ClientApplicationVideoReceived__c = null;
        }

        if (cv.Type__c == 'CGCForm'){
            team.ClientCGCFormReceived__c = null;
        }

        if (cv.Type__c == 'CertAgreement'){
            team.ClientCertAgreementReceived__c = null;
        }

        if (cv.Type__c == 'LOMI'){
            team.ClientLOMIReceived__c = null;
        }

        if (cv.Type__c == 'MentalHealthForm'){
            team.ClientMentalHealthFormReceived__c = null;
        }

        if (cv.Type__c == 'PreApplication'){
            team.ClientPreApplicationReceived__c = null;
        }

        if (cv.Type__c == 'ProgAgreement'){
            team.ClientProgAgreementReceived__c = null;
        }

        if (cv.Type__c == 'ProvRelForm'){
            team.ClientProvRelFormReceived__c = null;
        }

        if (cv.Type__c == 'Survey'){
            team.ClientSurveyReceived__c = null;
        }

        if (cv.Type__c == 'VAPW'){
            team.ClientVAPWReceived__c = null;
        }

        if (cv.Type__c == 'HealthForm'){
            team.HealthFormReceived__c = null;
        }

        if (cv.Type__c == 'Xray'){
            team.XrayReceived__c = null;
        }

        update team;
    }

    private static void clearDogDate(ContentVersion cv, Id recordId) {
        List<Dog__c> dogs = [
            SELECT Id, VacExamsReceived__c
            FROM Dog__c
            WHERE Id = :recordId];

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];

        if (cv.Type__c == 'VacExams'){
            dog.VacExamsReceived__c = null;
        }

        update dog;
    }
    //#endregion Generated code
}
