trigger ContactTrigger on Contact (before insert, before update) {
    Map<String, String> positionGroups = ContactService.getGroupsByPositions();
    Map<Id, Contact> modifiedContacts = new Map<Id, Contact>();
    for (Contact newContact : Trigger.new) {
        string oldEmail = newContact.Email;
        string oldPhone = newContact.Phone;
        string oldPositions = null;
        if (Trigger.isUpdate) {
            //Get Old Value
            Contact oldContact = trigger.oldMap.get(newContact.Id);
            oldEmail = oldContact.Email;
            oldPhone = oldContact.Phone;
            oldPositions = oldContact.Positions__c;
        }
        
        // Check if Contact is set
        if (!String.isBlank(newContact.Contact__c)) {
            if (oldEmail != newContact.Email) {
                newContact = ContactService.updateContactAtEmail(newContact);
            }
            else {
                newContact = ContactService.updateEmail(newContact);
            }

            if (oldPhone != newContact.Phone) {
                newContact = ContactService.updateContactAtPhone(newContact);
            }
            else {
                newContact = ContactService.updatePhone(newContact);
            }
        }

        // Set PreferredName if not already set
        if (String.isBlank(newContact.PreferredName__c)) {
            newContact.PreferredName__c = newContact.FirstName;
        }

        // Set BoardTermValidUntil
        if (newContact.LastBoardTermStartDate__c != null) {
            integer month = newContact.LastBoardTermStartDate__c.month();
            Date minTerm = newContact.LastBoardTermStartDate__c.addYears(3);
            integer months = 0;
            if (month < 6) {
                months = 6 - month;
            }
            else if (month > 6) {
                months = 18 - month;
            }
            // We want to wind up at the last day of June in the year following 3 years of service.
            // So, months + 1 takes us to July, toStartOfMonth() takes us to July 1, and subtracting
            // a day takes us to June 30.
            newContact.BoardTermValidUntil__c = minTerm.addMonths(months + 1).toStartOfMonth().addDays(-1);
        }

        if (newContact.Positions__c != oldPositions || newContact.UpdateShareSettings__c) {
            newContact = ContactService.shareContactBasedOnPositions(newContact, positionGroups);
            newContact.UpdateShareSettings__c = false;
            if (!Trigger.isInsert) {
                modifiedContacts.put(newContact.Id, newContact);
            }
        }
    }

    if (!Trigger.isInsert) {
        // finish modifying these contacts
        // Find who the contacts are related to as emergency contacts or guardian
        npe4__Relationship__c[] relationships = [
            SELECT
                npe4__Contact__r.Positions__c,
                npe4__Contact__r.ShareWithBoard__c,
                npe4__Contact__r.ShareWithPuppyRaiser__c,
                npe4__Contact__r.ShareWithStaff__c,
                npe4__Contact__r.ShareWithStandalonePrograms__c,
                npe4__Contact__r.ShareWithTeam__c,
                npe4__Contact__r.ShareWithTrainer__c,
                npe4__Contact__r.ShareWithVolunteer__c,
                npe4__RelatedContact__c,
                npe4__RelatedContact__r.Positions__c,
                npe4__RelatedContact__r.ShareWithBoard__c,
                npe4__RelatedContact__r.ShareWithPuppyRaiser__c,
                npe4__RelatedContact__r.ShareWithStaff__c,
                npe4__RelatedContact__r.ShareWithStandalonePrograms__c,
                npe4__RelatedContact__r.ShareWithTeam__c,
                npe4__RelatedContact__r.ShareWithTrainer__c,
                npe4__RelatedContact__r.ShareWithVolunteer__c
            FROM npe4__Relationship__c
            WHERE
                (npe4__Type__c LIKE '%Emergency Contact'
                OR npe4__Type__c = 'Guardian')
                AND npe4__Status__c = 'Current'
                AND npe4__RelatedContact__c in :modifiedContacts.keySet()
        ];

        for (npe4__Relationship__c relationship : relationships) {
            Contact source = relationship.npe4__Contact__r;
            Contact relation = modifiedContacts.get(relationship.npe4__RelatedContact__c);
            if (relation != null) {
                relation.ShareWithBoard__c = relation.ShareWithBoard__c || source.ShareWithBoard__c;
                relation.ShareWithPuppyRaiser__c = relation.ShareWithPuppyRaiser__c || source.ShareWithPuppyRaiser__c;
                relation.ShareWithStaff__c = relation.ShareWithStaff__c || source.ShareWithStaff__c;
                relation.ShareWithStandalonePrograms__c = relation.ShareWithStandalonePrograms__c || source.ShareWithStandalonePrograms__c;
                relation.ShareWithTeam__c = relation.ShareWithTeam__c || source.ShareWithTeam__c;
                relation.ShareWithTrainer__c = relation.ShareWithTrainer__c || source.ShareWithTrainer__c;
                relation.ShareWithVolunteer__c = relation.ShareWithVolunteer__c || source.ShareWithVolunteer__c;
            }
        }
    }
}