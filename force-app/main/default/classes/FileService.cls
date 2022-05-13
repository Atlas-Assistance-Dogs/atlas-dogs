public with sharing class FileService {
    // Update the docDate for the record tied to these files.
    // Must all be linked to the same entity
    public static void updateDates(List<ContentVersion> cvs, Date docDate) {
        if (cvs == null || cvs.size() == 0)
            return;

        ContentVersion cv = [
            SELECT Id, ContentDocumentId, Category__c, Type__c
            FROM ContentVersion
            WHERE Id = :cvs[0].Id
            LIMIT 1
        ];
        Id recordId;
        // find the record tied to these cvs
        for (ContentDocumentLink cntLink : [
            SELECT Id, LinkedEntityId
            FROM ContentDocumentLink
            WHERE ContentDocumentId = :cv.ContentDocumentId
        ]) {
            // note there is a limit of one cv above, so we can update all of them here
            if (cv.Category__c == 'Dog') {
                updateDogDate(cvs, cntLink.LinkedEntityId, docDate);
            } else {
                // this is related to a contact
                updateContactDate(cvs, cntLink.LinkedEntityId, docDate);
            }
        }
    }
    // Update the date for the record tied to a file
    public static void updateDate(ContentVersion cv, Date docDate) {
        if (cv.Category__c == null || cv.Type__c == null)
            return; // nothing to do here
        cv = [
            SELECT Id, ContentDocumentId, Category__c, Type__c
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
            updateDate(cv, cntLink.LinkedEntityId, docDate);
        }
    }

    // Update the last docDate for a file
    public static void updateDate(ContentVersion cv, Id recordId, Date docDate) {
        if (cv.Category__c == null || cv.Type__c == null)
            return;

        if (cv.Category__c == 'Dog') {
            updateDogDate(new List<ContentVersion>{ cv }, recordId, docDate);
        } else {
            // this is related to a contact
            updateContactDate(new List<ContentVersion>{ cv }, recordId, docDate);
        }
    }
    // Update the last received docDate for the contact for the document category and type
    private static void updateContactDate(
        List<ContentVersion> cvs,
        Id recordId,
        Date docDate
    ) {
        Set<string> fields = new Set<string>();
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {
            string category = (cv.Type__c == 'ContactForm') ? '' : cv.Category__c;
            string field = string.format(
                '{0}{1}Received__c',
                new List<Object>{ category, cv.Type__c.replace(' ', '') }
            );
            fields.add(field);
            ids.add(cv.Id);
        }
        string fieldList = string.join(new List<string>(fields), ',');
        string query = string.format(
            'SELECT Id, {0} FROM Contact WHERE Id = :recordId',
            new List<Object>{ fieldList }
        );
        List<Contact> contacts = Database.query(query);

        if (contacts.size() == 0)
            return;
        Contact contact = contacts[0];
        // Get the LastModifiedDate, order asc so we update the field with the last received
        cvs = [
            SELECT LastModifiedDate, Category__c, Type__c
            FROM ContentVersion
            WHERE Id IN :ids
            ORDER BY LastModifiedDate
        ];

        for (ContentVersion cv : cvs) {
            if (cv.Category__c == 'Volunteer' && cv.Type__c == 'Application') {
                contact.VolunteerApplicationReceived__c = docDate;
            }

            if (cv.Category__c == 'Board' && cv.Type__c == 'Application') {
                contact.BoardApplicationReceived__c = docDate;
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'Application') {
                contact.ClientApplicationReceived__c = docDate;
            }

            if (cv.Category__c == 'TSiM' && cv.Type__c == 'Application') {
                contact.TSiMApplicationReceived__c = docDate;
            }

            if (cv.Category__c == 'ADSiM' && cv.Type__c == 'Application') {
                contact.ADSiMApplicationReceived__c = docDate;
            }

            if (
                cv.Category__c == 'Facilitator' &&
                cv.Type__c == 'Application'
            ) {
                contact.FacilitatorApplicationReceived__c = docDate;
            }

            if (cv.Category__c == 'Trainer' && cv.Type__c == 'Application') {
                contact.TrainerApplicationReceived__c = docDate;
            }

            if (cv.Category__c == 'Staff' && cv.Type__c == 'Application') {
                contact.StaffApplicationReceived__c = docDate;
            }

            if (cv.Category__c == 'Volunteer' && cv.Type__c == 'Agreement') {
                contact.VolunteerAgreementReceived__c = docDate;
            }

            if (cv.Category__c == 'Board' && cv.Type__c == 'Agreement') {
                contact.BoardAgreementReceived__c = docDate;
            }

            if (cv.Category__c == 'Staff' && cv.Type__c == 'Agreement') {
                contact.StaffAgreementReceived__c = docDate;
            }

            if (cv.Category__c == 'Volunteer' && cv.Type__c == 'Resume') {
                contact.VolunteerResumeReceived__c = docDate;
            }

            if (cv.Category__c == 'Board' && cv.Type__c == 'Resume') {
                contact.BoardResumeReceived__c = docDate;
            }

            if (cv.Category__c == 'Staff' && cv.Type__c == 'Resume') {
                contact.StaffResumeReceived__c = docDate;
            }

            if (cv.Category__c == 'Board' && cv.Type__c == 'CoI') {
                contact.BoardCoIReceived__c = docDate;
            }

            if (cv.Category__c == 'Board' && cv.Type__c == 'ToN') {
                contact.BoardToNReceived__c = docDate;
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'PreApplication') {
                contact.ClientPreApplicationReceived__c = docDate;
            }

            if (cv.Category__c == 'ADSiM' && cv.Type__c == 'PreApplication') {
                contact.ADSiMPreApplicationReceived__c = docDate;
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'LOMI') {
                contact.ClientLOMIReceived__c = docDate;
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'VAPW') {
                contact.ClientVAPWReceived__c = docDate;
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'Survey') {
                contact.ClientSurveyReceived__c = docDate;
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'ProgAgreement') {
                contact.ClientProgAgreementReceived__c = docDate;
            }

            if (cv.Category__c == 'TSiM' && cv.Type__c == 'ProgAgreement') {
                contact.TSiMProgAgreementReceived__c = docDate;
            }

            if (cv.Category__c == 'ADSiM' && cv.Type__c == 'ProgAgreement') {
                contact.ADSiMProgAgreementReceived__c = docDate;
            }

            if (
                cv.Category__c == 'Facilitator' &&
                cv.Type__c == 'ProgAgreement'
            ) {
                contact.FacilitatorProgAgreementReceived__c = docDate;
            }

            if (cv.Category__c == 'Trainer' && cv.Type__c == 'ProgAgreement') {
                contact.TrainerProgAgreementReceived__c = docDate;
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'CertAgreement') {
                contact.ClientCertAgreementReceived__c = docDate;
            }

            if (
                cv.Category__c == 'Facilitator' &&
                cv.Type__c == 'CertAgreement'
            ) {
                contact.FacilitatorCertAgreementReceived__c = docDate;
            }

            if (cv.Category__c == 'Trainer' && cv.Type__c == 'CertAgreement') {
                contact.TrainerCertAgreementReceived__c = docDate;
            }

            if (cv.Category__c == 'Facilitator' && cv.Type__c == 'Reference') {
                contact.FacilitatorReferenceReceived__c = docDate;
            }

            if (cv.Category__c == 'Trainer' && cv.Type__c == 'Reference') {
                contact.TrainerReferenceReceived__c = docDate;
            }

            if (
                cv.Category__c == 'Facilitator' &&
                cv.Type__c == 'ProfGrowthPlan'
            ) {
                contact.FacilitatorProfGrowthPlanReceived__c = docDate;
            }

            if (cv.Category__c == 'Facilitator' && cv.Type__c == 'Practicum') {
                contact.FacilitatorPracticumReceived__c = docDate;
            }

            if (cv.Category__c == 'Facilitator' && cv.Type__c == 'InfrNotice') {
                contact.FacilitatorInfrNoticeReceived__c = docDate;
            }

            if (cv.Category__c == 'Trainer' && cv.Type__c == 'InfrNotice') {
                contact.TrainerInfrNoticeReceived__c = docDate;
            }

            if (cv.Category__c == 'Staff' && cv.Type__c == 'Offer') {
                contact.StaffOfferReceived__c = docDate;
            }

            if (cv.Category__c == 'Staff' && cv.Type__c == 'W4') {
                contact.StaffW4Received__c = docDate;
            }

            if (cv.Category__c == 'Staff' && cv.Type__c == 'I9') {
                contact.StaffI9Received__c = docDate;
            }

            if (cv.Type__c == 'ContactForm') {
                contact.ContactFormReceived__c = docDate;
            }
        }
        update contact;
    }

    // Update the last received docDate for the contact for the document type
    private static void updateDogDate(List<ContentVersion> cvs, Id recordId, Date docDate) {
        // this is related to a dog
        Set<string> fields = new Set<string>();
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {
            string field = string.format(
                '{0}Received__c',
                new List<Object>{ cv.Type__c.replace(' ', '') }
            );
            fields.add(field);
            ids.add(cv.Id);
        }
        string fieldList = string.join(new List<string>(fields), ',');
        string query = string.format(
            'SELECT Id, {0} FROM Dog__c WHERE Id = :recordId',
            new List<Object>{ fieldList }
        );
        List<Dog__c> dogs = Database.query(query);

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];
        // Make sure we have LastModifiedDate, and last of these is last in
        // the list so we update the field correctly
        cvs = [
            SELECT LastModifiedDate, Type__c
            FROM ContentVersion
            WHERE Id IN :ids
            ORDER BY LastModifiedDate
        ];

        for (ContentVersion cv : cvs) {
            if (cv.Type__c == 'HealthForm') {
                dog.HealthFormReceived__c = docDate;
            }

            if (cv.Type__c == 'Xray') {
                dog.XrayReceived__c = docDate;
            }

            if (cv.Type__c == 'VacExams') {
                dog.VacExamsReceived__c = docDate;
            }
        }
        update dog;
    }
}