trigger ContactTrigger on Contact (before insert, before update) {
    Map<String, String> positionGroups = ContactService.getGroupsByPositions();
    Set<Id> modifiedContacts = new Set<Id>();
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
            System.debug(newContact.Id);
            ContactService.shareContactBasedOnPositions(newContact, positionGroups);
            if (!Trigger.isInsert) {
                modifiedContacts.add(newContact.Id);
            }
            newContact.UpdateShareSettings__c = false;
        }
    }

    if (!Trigger.isInsert) {
        // finish modifying these contacts
        Map<Id, Contact> contactMap = ContactService.shareContactsBasedOnRelations(modifiedContacts);

        for (Contact newContact : Trigger.new) {
            Contact changes = contactMap.get(newContact.Id);
            if (changes != null) {
                System.debug(newContact.Id);
                newContact.ShareWithBoard__c = changes.ShareWithBoard__c;
                newContact.ShareWithPuppyRaiser__c = changes.ShareWithPuppyRaiser__c;
                newContact.ShareWithStaff__c = changes.ShareWithStaff__c;
                newContact.ShareWithStandalonePrograms__c = changes.ShareWithStandalonePrograms__c;
                newContact.ShareWithTeam__c = changes.ShareWithTeam__c;
                newContact.ShareWithTrainer__c = changes.ShareWithTrainer__c;
                newContact.ShareWithVolunteer__c = changes.ShareWithVolunteer__c;
            }
        }
    }
}