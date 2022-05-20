public with sharing class FileService{
    // Update the docDate for the record tied to these files.
    // Must all be linked to the same entity
    public static void updateDates(List<ContentVersion> cvs, Date docDate){
        if (cvs == null || cvs.size() == 0)
            return;
        ContentVersion cv = [SELECT Id, ContentDocumentId, Category__c, Type__c
                             FROM ContentVersion
                             WHERE Id = :cvs[0].Id
                             LIMIT 1];
        Id recordId;
        // find the record tied to these cvs
        for (ContentDocumentLink cntLink : [SELECT Id, LinkedEntityId
                                            FROM ContentDocumentLink
                                            WHERE ContentDocumentId = :cv.ContentDocumentId]){
            // note there is a limit of one cv above, so we can update all of them here
            if (cv.Category__c == 'Dog'){
                updateDogDate(cvs, cntLink.LinkedEntityId, docDate);
            } else{
                // this is related to a contact
                updateContactDate(cvs, cntLink.LinkedEntityId, docDate);
            }
        }
    }

    // Update the date for the record tied to a file
    public static void updateDate(ContentVersion cv, Date docDate){
        if (cv.Category__c == null || cv.Type__c == null)
            return;
        // nothing to do here
        cv = [SELECT Id, ContentDocumentId, Category__c, Type__c
              FROM ContentVersion
              WHERE Id = :cv.Id
              LIMIT 1];
        // find the record tied to this cv
        for (ContentDocumentLink cntLink : [SELECT Id, LinkedEntityId
                                            FROM ContentDocumentLink
                                            WHERE ContentDocumentId = :cv.ContentDocumentId]){
            updateDate(cv, cntLink.LinkedEntityId, docDate);
        }
    }

    // Update the last docDate for a file
    public static void updateDate(ContentVersion cv, Id recordId, Date docDate){
        if (cv.Category__c == null || cv.Type__c == null)
            return;
        if (cv.Category__c == 'Dog'){
            updateDogDate(new List<ContentVersion>{ cv }, recordId, docDate);
        } else{
            // this is related to a contact
            updateContactDate(new List<ContentVersion>{ cv }, recordId, docDate);
        }
    }

    // Determine if the proposed date is later than the current.
    // Never is considered before everything else.
    private static Boolean isLater(Date current, Date proposed){
        return current == null || current < proposed;
    }

    // Update the last received docDate for the contact for the document category and type
    private static void updateContactDate(List<ContentVersion> cvs, Id recordId, Date docDate){
        Set<string> fields = new Set<string>();
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs){
            string category = (cv.Type__c == 'ContactForm') ? '' : cv.Category__c;
            string field = string.format('{0}{1}Received__c', new List<Object>{ category, cv.Type__c.replace(' ', '') });
            fields.add(field);
            ids.add(cv.Id);
        }
        string fieldList = string.join(new List<string>(fields), ',');
        string query = string.format('SELECT Id, {0} FROM Contact WHERE Id = :recordId', new List<Object>{ fieldList });
        List<Contact> contacts = Database.query(query);

        if (contacts.size() == 0)
            return;
        Contact contact = contacts[0];
        // Get the Date, order asc so we update the field with the last received
        cvs = [SELECT Category__c, Type__c, Date__c
               FROM ContentVersion
               WHERE Id IN:ids
               ORDER BY Date__c];

        for (ContentVersion cv : cvs){
            if (cv.Category__c == 'ADSiM'){
                if (cv.Type__c == 'Application' && isLater(contact.ADSiMApplicationReceived__c, docDate)){
                    contact.ADSiMApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'PreApplication' && isLater(contact.ADSiMPreApplicationReceived__c, docDate)){
                    contact.ADSiMPreApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'ProgAgreement' && isLater(contact.ADSiMProgAgreementReceived__c, docDate)){
                    contact.ADSiMProgAgreementReceived__c = docDate;
                }
            }

            if (cv.Category__c == 'Board'){
                if (cv.Type__c == 'Agreement' && isLater(contact.BoardAgreementReceived__c, docDate)){
                    contact.BoardAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'Application' && isLater(contact.BoardApplicationReceived__c, docDate)){
                    contact.BoardApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'CoI' && isLater(contact.BoardCoIReceived__c, docDate)){
                    contact.BoardCoIReceived__c = docDate;
                }

                if (cv.Type__c == 'Resume' && isLater(contact.BoardResumeReceived__c, docDate)){
                    contact.BoardResumeReceived__c = docDate;
                }

                if (cv.Type__c == 'ToN' && isLater(contact.BoardToNReceived__c, docDate)){
                    contact.BoardToNReceived__c = docDate;
                }
            }

            if (cv.Category__c == 'Client'){
                if (cv.Type__c == 'Application' && isLater(contact.ClientApplicationReceived__c, docDate)){
                    contact.ClientApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'CertAgreement' && isLater(contact.ClientCertAgreementReceived__c, docDate)){
                    contact.ClientCertAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'LOMI' && isLater(contact.ClientLOMIReceived__c, docDate)){
                    contact.ClientLOMIReceived__c = docDate;
                }

                if (cv.Type__c == 'PreApplication' && isLater(contact.ClientPreApplicationReceived__c, docDate)){
                    contact.ClientPreApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'ProgAgreement' && isLater(contact.ClientProgAgreementReceived__c, docDate)){
                    contact.ClientProgAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'Survey' && isLater(contact.ClientSurveyReceived__c, docDate)){
                    contact.ClientSurveyReceived__c = docDate;
                }

                if (cv.Type__c == 'VAPW' && isLater(contact.ClientVAPWReceived__c, docDate)){
                    contact.ClientVAPWReceived__c = docDate;
                }
            }

            if (cv.Category__c == 'Facilitator'){
                if (cv.Type__c == 'Application' && isLater(contact.FacilitatorApplicationReceived__c, docDate)){
                    contact.FacilitatorApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'CertAgreement' && isLater(contact.FacilitatorCertAgreementReceived__c, docDate)){
                    contact.FacilitatorCertAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'InfrNotice' && isLater(contact.FacilitatorInfrNoticeReceived__c, docDate)){
                    contact.FacilitatorInfrNoticeReceived__c = docDate;
                }

                if (cv.Type__c == 'Practicum' && isLater(contact.FacilitatorPracticumReceived__c, docDate)){
                    contact.FacilitatorPracticumReceived__c = docDate;
                }

                if (cv.Type__c == 'ProfGrowthPlan' && isLater(contact.FacilitatorProfGrowthPlanReceived__c, docDate)){
                    contact.FacilitatorProfGrowthPlanReceived__c = docDate;
                }

                if (cv.Type__c == 'ProgAgreement' && isLater(contact.FacilitatorProgAgreementReceived__c, docDate)){
                    contact.FacilitatorProgAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'Reference' && isLater(contact.FacilitatorReferenceReceived__c, docDate)){
                    contact.FacilitatorReferenceReceived__c = docDate;
                }
            }

            if (cv.Category__c == 'Puppy'){
                if (cv.Type__c == 'Application' && isLater(contact.PuppyApplicationReceived__c, docDate)){
                    contact.PuppyApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'CertAgreement' && isLater(contact.PuppyCertAgreementReceived__c, docDate)){
                    contact.PuppyCertAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'InfrNotice' && isLater(contact.PuppyInfrNoticeReceived__c, docDate)){
                    contact.PuppyInfrNoticeReceived__c = docDate;
                }

                if (cv.Type__c == 'ProgAgreement' && isLater(contact.PuppyProgAgreementReceived__c, docDate)){
                    contact.PuppyProgAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'Reference' && isLater(contact.PuppyReferenceReceived__c, docDate)){
                    contact.PuppyReferenceReceived__c = docDate;
                }
            }

            if (cv.Category__c == 'Staff'){
                if (cv.Type__c == 'Agreement' && isLater(contact.StaffAgreementReceived__c, docDate)){
                    contact.StaffAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'Application' && isLater(contact.StaffApplicationReceived__c, docDate)){
                    contact.StaffApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'I9' && isLater(contact.StaffI9Received__c, docDate)){
                    contact.StaffI9Received__c = docDate;
                }

                if (cv.Type__c == 'Offer' && isLater(contact.StaffOfferReceived__c, docDate)){
                    contact.StaffOfferReceived__c = docDate;
                }

                if (cv.Type__c == 'Resume' && isLater(contact.StaffResumeReceived__c, docDate)){
                    contact.StaffResumeReceived__c = docDate;
                }

                if (cv.Type__c == 'W4' && isLater(contact.StaffW4Received__c, docDate)){
                    contact.StaffW4Received__c = docDate;
                }
            }

            if (cv.Category__c == 'TSiM'){
                if (cv.Type__c == 'Application' && isLater(contact.TSiMApplicationReceived__c, docDate)){
                    contact.TSiMApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'ProgAgreement' && isLater(contact.TSiMProgAgreementReceived__c, docDate)){
                    contact.TSiMProgAgreementReceived__c = docDate;
                }
            }

            if (cv.Category__c == 'Trainer'){
                if (cv.Type__c == 'Application' && isLater(contact.TrainerApplicationReceived__c, docDate)){
                    contact.TrainerApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'CertAgreement' && isLater(contact.TrainerCertAgreementReceived__c, docDate)){
                    contact.TrainerCertAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'InfrNotice' && isLater(contact.TrainerInfrNoticeReceived__c, docDate)){
                    contact.TrainerInfrNoticeReceived__c = docDate;
                }

                if (cv.Type__c == 'ProgAgreement' && isLater(contact.TrainerProgAgreementReceived__c, docDate)){
                    contact.TrainerProgAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'Reference' && isLater(contact.TrainerReferenceReceived__c, docDate)){
                    contact.TrainerReferenceReceived__c = docDate;
                }
            }

            if (cv.Category__c == 'Volunteer'){
                if (cv.Type__c == 'Agreement' && isLater(contact.VolunteerAgreementReceived__c, docDate)){
                    contact.VolunteerAgreementReceived__c = docDate;
                }

                if (cv.Type__c == 'Application' && isLater(contact.VolunteerApplicationReceived__c, docDate)){
                    contact.VolunteerApplicationReceived__c = docDate;
                }

                if (cv.Type__c == 'Resume' && isLater(contact.VolunteerResumeReceived__c, docDate)){
                    contact.VolunteerResumeReceived__c = docDate;
                }
            }

            if (cv.Type__c == 'ContactForm' && isLater(contact.ContactFormReceived__c, docDate)){
                contact.ContactFormReceived__c = docDate;
            }
        }
        update contact;
    }

    // Update the last received docDate for the contact for the document type
    private static void updateDogDate(List<ContentVersion> cvs, Id recordId, Date docDate){
        // this is related to a dog
        Set<string> fields = new Set<string>();
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs){
            string field = string.format('{0}Received__c', new List<Object>{ cv.Type__c.replace(' ', '') });
            fields.add(field);
            ids.add(cv.Id);
        }
        string fieldList = string.join(new List<string>(fields), ',');
        string query = string.format('SELECT Id, {0} FROM Dog__c WHERE Id = :recordId', new List<Object>{ fieldList });
        List<Dog__c> dogs = Database.query(query);

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];
        // Make sure we have Date__c, and last of these is last in
        // the list so we update the field correctly
        cvs = [SELECT Date__c, Type__c
               FROM ContentVersion
               WHERE Id IN:ids
               ORDER BY Date__c];

        for (ContentVersion cv : cvs){
            if (cv.Type__c == 'HealthForm' && isLater(dog.HealthFormReceived__c, docDate)){
                dog.HealthFormReceived__c = docDate;
            }

            if (cv.Type__c == 'Xray' && isLater(dog.XrayReceived__c, docDate)){
                dog.XrayReceived__c = docDate;
            }

            if (cv.Type__c == 'VacExams' && isLater(dog.VacExamsReceived__c, docDate)){
                dog.VacExamsReceived__c = docDate;
            }
        }
        update dog;
    }

}