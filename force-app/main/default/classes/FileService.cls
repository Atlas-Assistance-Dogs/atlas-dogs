public with sharing class FileService {
    // Update the date for the record tied to these files.
    // Must all be linked to the same entity
    public static void updateDates(List<ContentVersion> cvs) {
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
                updateDogDate(cvs, cntLink.LinkedEntityId);
            } else {
                // this is related to a contact
                updateContactDate(cvs, cntLink.LinkedEntityId);
            }
        }
    }
    // Update the date for the record tied to a file
    public static void updateDate(ContentVersion cv) {
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
            updateDate(cv, cntLink.LinkedEntityId);
        }
    }

    // Update the last date for a file
    public static void updateDate(ContentVersion cv, Id recordId) {
        if (cv.Category__c == null || cv.Type__c == null)
            return;

        if (cv.Category__c == 'Dog') {
            updateDogDate(new List<ContentVersion>{ cv }, recordId);
        } else {
            // this is related to a contact
            updateContactDate(new List<ContentVersion>{ cv }, recordId);
        }
    }
    // Update the last received date for the contact for the document category and type
    private static void updateContactDate(
        List<ContentVersion> cvs,
        Id recordId
    ) {
        Set<string> fields = new Set<string>();
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs) {
            string field = string.format(
                '{0}{1}Received__c',
                new List<Object>{ cv.Category__c, cv.Type__c.replace(' ', '') }
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

            if (
                cv.Category__c == 'Facilitator' &&
                cv.Type__c == 'Application'
            ) {
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

            if (cv.Category__c == 'Board' && cv.Type__c == 'CoI') {
                contact.BoardCoIReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Board' && cv.Type__c == 'ToN') {
                contact.BoardToNReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'PreApplication') {
                contact.ClientPreApplicationReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'ADSiM' && cv.Type__c == 'PreApplication') {
                contact.ADSiMPreApplicationReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'LOMI') {
                contact.ClientLOMIReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'VAPW') {
                contact.ClientVAPWReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'Survey') {
                contact.ClientSurveyReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'ProgAgreement') {
                contact.ClientProgAgreementReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'TSiM' && cv.Type__c == 'ProgAgreement') {
                contact.TSiMProgAgreementReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'ADSiM' && cv.Type__c == 'ProgAgreement') {
                contact.ADSiMProgAgreementReceived__c = cv.LastModifiedDate.date();
            }

            if (
                cv.Category__c == 'Facilitator' &&
                cv.Type__c == 'ProgAgreement'
            ) {
                contact.FacilitatorProgAgreementReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Trainer' && cv.Type__c == 'ProgAgreement') {
                contact.TrainerProgAgreementReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'CertAgreement') {
                contact.ClientCertAgreementReceived__c = cv.LastModifiedDate.date();
            }

            if (
                cv.Category__c == 'Facilitator' &&
                cv.Type__c == 'CertAgreement'
            ) {
                contact.FacilitatorCertAgreementReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Trainer' && cv.Type__c == 'CertAgreement') {
                contact.TrainerCertAgreementReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Facilitator' && cv.Type__c == 'Reference') {
                contact.FacilitatorReferenceReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Trainer' && cv.Type__c == 'Reference') {
                contact.TrainerReferenceReceived__c = cv.LastModifiedDate.date();
            }

            if (
                cv.Category__c == 'Facilitator' &&
                cv.Type__c == 'ProfGrowthPlan'
            ) {
                contact.FacilitatorProfGrowthPlanReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Facilitator' && cv.Type__c == 'Practicum') {
                contact.FacilitatorPracticumReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Facilitator' && cv.Type__c == 'InfrNotice') {
                contact.FacilitatorInfrNoticeReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Trainer' && cv.Type__c == 'InfrNotice') {
                contact.TrainerInfrNoticeReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Staff' && cv.Type__c == 'Offer') {
                contact.StaffOfferReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Staff' && cv.Type__c == 'W4') {
                contact.StaffW4Received__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Staff' && cv.Type__c == 'I9') {
                contact.StaffI9Received__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Volunteer' && cv.Type__c == 'ContactForm') {
                contact.VolunteerContactFormReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Board' && cv.Type__c == 'ContactForm') {
                contact.BoardContactFormReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Client' && cv.Type__c == 'ContactForm') {
                contact.ClientContactFormReceived__c = cv.LastModifiedDate.date();
            }

            if (
                cv.Category__c == 'Facilitator' &&
                cv.Type__c == 'ContactForm'
            ) {
                contact.FacilitatorContactFormReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Category__c == 'Trainer' && cv.Type__c == 'ContactForm') {
                contact.TrainerContactFormReceived__c = cv.LastModifiedDate.date();
            }
        }
        update contact;
    }

    // Update the last received date for the contact for the document type
    private static void updateDogDate(List<ContentVersion> cvs, Id recordId) {
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
                dog.HealthFormReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Type__c == 'Xray') {
                dog.XrayReceived__c = cv.LastModifiedDate.date();
            }

            if (cv.Type__c == 'VacExams') {
                dog.VacExamsReceived__c = cv.LastModifiedDate.date();
            }
        }
        update dog;
    }
}