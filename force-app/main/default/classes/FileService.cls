public with sharing class FileService {
    // Update the docDate for the record tied to these CVs
    public static void updateDates(List<ContentVersion> cvs) {
        if (cvs == null || cvs.isEmpty()) {
            return;
        }
        Map<Id, ContentVersion> docMap = new Map<Id, ContentVersion>();
        for (ContentVersion cv : cvs) {
            docMap.put(cv.ContentDocumentId, cv);
        }
        List<ContentDocumentLink> cdls = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN :docmap.keySet()];
        Map<Id, List<ContentVersion>> entityDocs = new Map<Id, List<ContentVersion>>();
        for (ContentDocumentLink cdl: cdls) {
            ContentVersion cv = docMap.get(cdl.ContentDocumentId);
            if (entityDocs.containsKey(cdl.LinkedEntityId)) {
                entityDocs.get(cdl.LinkedEntityId).add(cv);
            }
            else {
                entityDocs.put(cdl.LinkedEntityId, new List<ContentVersion>{ cv });
            }
        }
        for (Id entityId: entityDocs.keySet()) {
            List<ContentVersion> docs = entityDocs.get(entityId);
            updateObjectDates(entityId, docs);
        }
    }
    
    // Update the docDate for the record tied to these files.
    public static void updateDates(List<ContentDocumentLink> cdls) {
        if (cdls == null || cdls.size() == 0)
            return;
        List<Id> docIds = new List<Id>();
        Map<Id, List<ContentDocumentLink>> entityMap = new Map<Id, List<ContentDocumentLink>>();
        for (ContentDocumentLink cdl: cdls) {
            docIds.add(cdl.ContentDocumentId);
            if (entityMap.containsKey(cdl.LinkedEntityId)) {
                entityMap.get(cdl.LinkedEntityId).add(cdl);
            }
            else {
                entityMap.put(cdl.LinkedEntityId, new List<ContentDocumentLink> { cdl });
            }
        }
        // make sure we have all the information we need for these documents
        Map<Id, ContentVersion> docMap = new Map<Id, ContentVersion>();
        for (ContentVersion cv: [
            SELECT Id, ContentDocumentId, Category__c, Type__c, Date__c
            FROM ContentVersion
            WHERE ContentDocumentId IN :docIds
        ]) {
            docMap.put(cv.ContentDocumentId, cv);
        }
        // Group the documents by entity, and update the entity
        for (Id entityId: entityMap.keySet()) {
            List<ContentDocumentLink> links = entityMap.get(entityId);
            List<ContentVersion> cvs = new List<ContentVersion>();
            for (ContentDocumentLink cdl: links) {
                cvs.add(docMap.get(cdl.ContentDocumentId));
            }
            updateObjectDates(entityId, cvs);
        }
    }

    // determine which object type is being updated and call the appropriate method
    private static void updateObjectDates(Id entityId, List<ContentVersion> cvs) {
        string objName = entityId.getSObjectType().getDescribe().getName();
        if (objName == Dog__c.class.getName()) {
            updateDogDates(cvs, entityId);
            linkDocumentsToTeams(cvs, entityId);
        }
        if (objName == Team__c.class.getName()) {
            updateTeamDates(cvs, entityId);
            AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
            if (settings.LinkFilesToTeamMembers__c) {
                linkDocumentsToTeamMember(cvs, entityId);
            }
        }
        if (objName == Contact.class.getName()) {
            updateContactDates(cvs, entityId);
        }
    }

    // Link any dog documents back to any teams they are on
    private static void linkDocumentsToTeams(List<ContentVersion> cvs, Id recordId) {
        List<Team__c> teams = [SELECT Client__c, Id FROM Team__c WHERE Dog__c = :recordId];
        for (Team__c team : teams) {
            List<ContentDocumentLink> links = new List<ContentDocumentLink>();
            for (ContentVersion cv : cvs) {
                if (cv.Type__c == 'VacExams') {
                    continue;
                }
                if (cv.Category__c == 'TeamDog') {
                    links.add(new ContentDocumentLink(
                        ContentDocumentId = cv.ContentDocumentId,
                        LinkedEntityId = team.Id
                    ));
                }
            }
            insertLinks(links, new List<Id> { team.Id }) ;
        }
    }

    // Link documents to the client and dog
    private static void linkDocumentsToTeamMember(List<ContentVersion> cvs, Id recordId) {
        List<Team__c> teams = [SELECT Client__c, Dog__c FROM Team__c WHERE Id = :recordId];
        if (teams.size() == 1) {
            Team__c team = teams[0];
            List<ContentDocumentLink> links = new List<ContentDocumentLink>();
            for (ContentVersion cv : cvs) {
                if (cv.Category__c == 'Client') {
                    links.add(new ContentDocumentLink(
                        ContentDocumentId = cv.ContentDocumentId,
                        LinkedEntityId = team.Client__c
                    ));
                }
                else if (cv.Category__c == 'TeamDog') {
                    links.add(new ContentDocumentLink(
                        ContentDocumentId = cv.ContentDocumentId,
                        LinkedEntityId = team.Dog__c
                    ));
                }
            }
            insertLinks(links, new List<Id> { team.Client__c, team.Dog__c });
        }
    }

    // Insert links that do not already exist
    public static void insertLinks(List<ContentDocumentLink> links, List<Id> entities) {
        List<ContentDocumentLink> currentLinks = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :entities];
        List<ContentDocumentLink> safeLinks = new List<ContentDocumentLink>();
        for (ContentDocumentLink newLink: links) {
            Boolean safe = true;
            for (ContentDocumentLink current: currentLinks) {
                if (newLink.ContentDocumentId == current.ContentDocumentId &&
                    newLink.LinkedEntityId == current.LinkedEntityId) {
                        safe = false;
                }
            }
            if (safe) {
                safeLinks.add(newLink);
            }
        }
        insert safeLinks;
    }

    // Update the date for the record tied to a file
    public static void updateDate(ContentVersion cv) {
        if (String.isBlank(cv.Category__c) || String.isBlank(cv.Type__c))
            return;
        // nothing to do here
        cv = [
            SELECT Id, ContentDocumentId, Category__c, Type__c, Date__c
            FROM ContentVersion
            WHERE Id = :cv.Id
            LIMIT 1
        ];
        // find the record tied to this cv
        for (ContentDocumentLink cntLink : [
            SELECT Id, LinkedEntityId
            FROM ContentDocumentLink
            WHERE ContentDocumentId = :cv.ContentDocumentId
        ]) {
            updateDate(cv, cntLink.LinkedEntityId);
        }
    }

    // Update the last docDate for a file
    public static void updateDate(ContentVersion cv, Id recordId) {
        if (String.isBlank(cv.Category__c) || String.isBlank(cv.Type__c))
            return;

        List<ContentVersion> cvs = new List<ContentVersion>{ cv };
        string objName = recordId.getSObjectType().getDescribe().getName();
        if (objName == Dog__c.class.getName()) {
            updateDogDates(cvs, recordId);
        }
        else if (objName == Team__c.class.getName()) {
            updateTeamDates(cvs, recordId);
            linkDocumentsToTeamMember(cvs, recordId);
        }
        else if (objName == Contact.class.getName()) {
            updateContactDates(cvs, recordId);
        }
}

    // Determine if the proposed date is later than the current.
    // Never is considered before everything else.
    private static Boolean isLater(Date current, Date proposed) {
        return current == null || current < proposed;
    }

    //#region Generated Contact

    // Update the last received docDate for the contact for the document category and type
    private static void updateContactDates(List<ContentVersion> cvs, Id recordId) {
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {
            ids.add(cv.Id);
        }
        List<Contact> contacts = [
            SELECT Id,
                ADSiMApplicationReceived__c, ADSiMPreApplicationReceived__c, ADSiMProgAgreementReceived__c,
				BoardAgreementReceived__c, BoardApplicationReceived__c, BoardCoIReceived__c, BoardResumeReceived__c, BoardToNReceived__c,
				FacilitatorApplicationReceived__c, FacilitatorCertAgreementReceived__c, FacilitatorInfrNoticeReceived__c, FacilitatorPracticumReceived__c, FacilitatorProgAgreementReceived__c, FacilitatorReferenceReceived__c,
				PuppyApplicationReceived__c, PuppyCertAgreementReceived__c, PuppyContractReceived__c, PuppyInfrNoticeReceived__c, PuppyProgAgreementReceived__c, PuppyReferenceReceived__c,
				StaffAgreementReceived__c, StaffApplicationReceived__c, StaffI9Received__c, StaffOfferReceived__c, StaffResumeReceived__c, StaffW4Received__c, StaffW9Received__c,
				TrainerApplicationReceived__c, TrainerCertAgreementReceived__c, TrainerClientReferenceReceived__c, TrainerInfrNoticeReceived__c, TrainerProfReferenceReceived__c, TrainerProgAgreementReceived__c,
				VolunteerAgreementReceived__c, VolunteerApplicationReceived__c, VolunteerResumeReceived__c,
				ContactFormReceived__c
            FROM Contact
            WHERE Id = :recordId
        ];

        if (contacts.size() == 0)
            return;
        Contact contact = contacts[0];
        // Get the Date, order asc so we update the field with the last received
        cvs = [
            SELECT Category__c, Type__c, Date__c
            FROM ContentVersion
            WHERE Id IN :ids
            ORDER BY Date__c
        ];

        for (ContentVersion cv : cvs) {        
            if (cv.Category__c == 'ADSiM') {
                updateADSiMDate(cv, contact);
            }
        
            if (cv.Category__c == 'Board') {
                updateBoardDate(cv, contact);
            }
        
            if (cv.Category__c == 'Facilitator') {
                updateFacilitatorDate(cv, contact);
            }
        
            if (cv.Category__c == 'Puppy') {
                updatePuppyDate(cv, contact);
            }
        
            if (cv.Category__c == 'Staff') {
                updateStaffDate(cv, contact);
            }
        
            if (cv.Category__c == 'Trainer') {
                updateTrainerDate(cv, contact);
            }
        
            if (cv.Category__c == 'Volunteer') {
                updateVolunteerDate(cv, contact);
            }

            if (cv.Type__c == 'ContactForm' && isLater(contact.ContactFormReceived__c, cv.Date__c)) {
                contact.ContactFormReceived__c = cv.Date__c;
            }
        }
        update contact;
    }

    // Update the last date when the category is ADSiM
    private static void updateADSiMDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Application' && isLater(contact.ADSiMApplicationReceived__c, cv.Date__c)) {
            contact.ADSiMApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'PreApplication' && isLater(contact.ADSiMPreApplicationReceived__c, cv.Date__c)) {
            contact.ADSiMPreApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProgAgreement' && isLater(contact.ADSiMProgAgreementReceived__c, cv.Date__c)) {
            contact.ADSiMProgAgreementReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Board
    private static void updateBoardDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Agreement' && isLater(contact.BoardAgreementReceived__c, cv.Date__c)) {
            contact.BoardAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Application' && isLater(contact.BoardApplicationReceived__c, cv.Date__c)) {
            contact.BoardApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CoI' && isLater(contact.BoardCoIReceived__c, cv.Date__c)) {
            contact.BoardCoIReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Resume' && isLater(contact.BoardResumeReceived__c, cv.Date__c)) {
            contact.BoardResumeReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ToN' && isLater(contact.BoardToNReceived__c, cv.Date__c)) {
            contact.BoardToNReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Facilitator
    private static void updateFacilitatorDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Application' && isLater(contact.FacilitatorApplicationReceived__c, cv.Date__c)) {
            contact.FacilitatorApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CertAgreement' && isLater(contact.FacilitatorCertAgreementReceived__c, cv.Date__c)) {
            contact.FacilitatorCertAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'InfrNotice' && isLater(contact.FacilitatorInfrNoticeReceived__c, cv.Date__c)) {
            contact.FacilitatorInfrNoticeReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Practicum' && isLater(contact.FacilitatorPracticumReceived__c, cv.Date__c)) {
            contact.FacilitatorPracticumReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProgAgreement' && isLater(contact.FacilitatorProgAgreementReceived__c, cv.Date__c)) {
            contact.FacilitatorProgAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Reference' && isLater(contact.FacilitatorReferenceReceived__c, cv.Date__c)) {
            contact.FacilitatorReferenceReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Puppy
    private static void updatePuppyDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Application' && isLater(contact.PuppyApplicationReceived__c, cv.Date__c)) {
            contact.PuppyApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CertAgreement' && isLater(contact.PuppyCertAgreementReceived__c, cv.Date__c)) {
            contact.PuppyCertAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Contract' && isLater(contact.PuppyContractReceived__c, cv.Date__c)) {
            contact.PuppyContractReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'InfrNotice' && isLater(contact.PuppyInfrNoticeReceived__c, cv.Date__c)) {
            contact.PuppyInfrNoticeReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProgAgreement' && isLater(contact.PuppyProgAgreementReceived__c, cv.Date__c)) {
            contact.PuppyProgAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Reference' && isLater(contact.PuppyReferenceReceived__c, cv.Date__c)) {
            contact.PuppyReferenceReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Staff
    private static void updateStaffDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Agreement' && isLater(contact.StaffAgreementReceived__c, cv.Date__c)) {
            contact.StaffAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Application' && isLater(contact.StaffApplicationReceived__c, cv.Date__c)) {
            contact.StaffApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'I9' && isLater(contact.StaffI9Received__c, cv.Date__c)) {
            contact.StaffI9Received__c = cv.Date__c;
        }

        if (cv.Type__c == 'Offer' && isLater(contact.StaffOfferReceived__c, cv.Date__c)) {
            contact.StaffOfferReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Resume' && isLater(contact.StaffResumeReceived__c, cv.Date__c)) {
            contact.StaffResumeReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'W4' && isLater(contact.StaffW4Received__c, cv.Date__c)) {
            contact.StaffW4Received__c = cv.Date__c;
        }

        if (cv.Type__c == 'W9' && isLater(contact.StaffW9Received__c, cv.Date__c)) {
            contact.StaffW9Received__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Trainer
    private static void updateTrainerDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Application' && isLater(contact.TrainerApplicationReceived__c, cv.Date__c)) {
            contact.TrainerApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CertAgreement' && isLater(contact.TrainerCertAgreementReceived__c, cv.Date__c)) {
            contact.TrainerCertAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ClientReference' && isLater(contact.TrainerClientReferenceReceived__c, cv.Date__c)) {
            contact.TrainerClientReferenceReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'InfrNotice' && isLater(contact.TrainerInfrNoticeReceived__c, cv.Date__c)) {
            contact.TrainerInfrNoticeReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProfReference' && isLater(contact.TrainerProfReferenceReceived__c, cv.Date__c)) {
            contact.TrainerProfReferenceReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProgAgreement' && isLater(contact.TrainerProgAgreementReceived__c, cv.Date__c)) {
            contact.TrainerProgAgreementReceived__c = cv.Date__c;
        }
    }

    // Update the last date when the category is Volunteer
    private static void updateVolunteerDate(ContentVersion cv, Contact contact) {

        if (cv.Type__c == 'Agreement' && isLater(contact.VolunteerAgreementReceived__c, cv.Date__c)) {
            contact.VolunteerAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Application' && isLater(contact.VolunteerApplicationReceived__c, cv.Date__c)) {
            contact.VolunteerApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Resume' && isLater(contact.VolunteerResumeReceived__c, cv.Date__c)) {
            contact.VolunteerResumeReceived__c = cv.Date__c;
        }
    }

    // Update the last received docDate for the team for the document type
    private static void updateTeamDates(List<ContentVersion> cvs, Id recordId) {
        // this is related to a team
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {
            ids.add(cv.Id);
        }
        List<Team__c> teams = [
            SELECT Id, Client__c, Dog__c,
                   ClientApplicationReceived__c, ClientApplicationVideoReceived__c, ClientCGCFormReceived__c, ClientCertAgreementReceived__c, ClientLOMIReceived__c, ClientPreApplicationReceived__c, ClientProgAgreementReceived__c, ClientSurveyReceived__c, ClientVAPWReceived__c,
				   HealthFormReceived__c, XrayReceived__c
            FROM Team__c
            WHERE Id = :recordId
        ];

        if (teams.size() == 0)
            return;
        Team__c team = teams[0];
        // Make sure we have Date__c, and last of these is last in
        // the list so we update the field correctly
        cvs = [SELECT Date__c, Type__c, ContentDocumentId
               FROM ContentVersion
               WHERE Id IN :ids
               ORDER BY Date__c
        ];

        //#region Generated team
        for (ContentVersion cv : cvs) {

        if (cv.Type__c == 'Application' && isLater(team.ClientApplicationReceived__c, cv.Date__c)) {
            team.ClientApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ApplicationVideo' && isLater(team.ClientApplicationVideoReceived__c, cv.Date__c)) {
            team.ClientApplicationVideoReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CGCForm' && isLater(team.ClientCGCFormReceived__c, cv.Date__c)) {
            team.ClientCGCFormReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'CertAgreement' && isLater(team.ClientCertAgreementReceived__c, cv.Date__c)) {
            team.ClientCertAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'LOMI' && isLater(team.ClientLOMIReceived__c, cv.Date__c)) {
            team.ClientLOMIReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'PreApplication' && isLater(team.ClientPreApplicationReceived__c, cv.Date__c)) {
            team.ClientPreApplicationReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'ProgAgreement' && isLater(team.ClientProgAgreementReceived__c, cv.Date__c)) {
            team.ClientProgAgreementReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Survey' && isLater(team.ClientSurveyReceived__c, cv.Date__c)) {
            team.ClientSurveyReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'VAPW' && isLater(team.ClientVAPWReceived__c, cv.Date__c)) {
            team.ClientVAPWReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'HealthForm' && isLater(team.HealthFormReceived__c, cv.Date__c)) {
            team.HealthFormReceived__c = cv.Date__c;
        }

        if (cv.Type__c == 'Xray' && isLater(team.XrayReceived__c, cv.Date__c)) {
            team.XrayReceived__c = cv.Date__c;
        }
        }
        update team;
    }

    // Update the last received docDate for the dog for the document type
    private static void updateDogDates(List<ContentVersion> cvs, Id recordId) {
        // this is related to a dog
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {
            ids.add(cv.Id);
        }
        List<Dog__c> dogs = [
            SELECT Id, VacExamsReceived__c
            FROM Dog__c
            WHERE Id = :recordId
        ];

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];
        // Make sure we have Date__c, and last of these is last in
        // the list so we update the field correctly
        cvs = [SELECT Date__c, Type__c
               FROM ContentVersion
               WHERE Id IN :ids
               ORDER BY Date__c
        ];

        //#region Generated dog
        for (ContentVersion cv : cvs) {

        if (cv.Type__c == 'VacExams' && isLater(dog.VacExamsReceived__c, cv.Date__c)) {
            dog.VacExamsReceived__c = cv.Date__c;
        }
        }
        update dog;
    }
    //#endregion Generated code
}