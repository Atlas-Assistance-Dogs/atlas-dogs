trigger ContactTrigger on Contact (before insert, before update) {
    Map<Id, Contact> modifiedContacts = new Map<Id, Contact>();
    for (Contact newContact : Trigger.new) {
        string oldEmail = newContact.Email;
        string oldPhone = newContact.Phone;
        string oldPositions = null;
        Date oldBoardDate = null;
        if (Trigger.isUpdate) {
            //Get Old Value
            Contact oldContact = trigger.oldMap.get(newContact.Id);
            oldEmail = oldContact.Email;
            oldPhone = oldContact.Phone;
            oldPositions = oldContact.Positions__c;
            oldBoardDate = oldContact.LastBoardTermStartDate__c;
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
        if (newContact.LastBoardTermStartDate__c != null && newContact.LastBoardTermStartDate__c != oldBoardDate) {
            AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
            // check to see if settings are missing
            if (settings.BoardTermEndMonth__c == null) {
                settings = new AtlasSettings__c();
                upsert settings;
                settings = AtlasSettings__c.getOrgDefaults();
            }
            Integer endMonth = (Integer)settings.BoardTermEndMonth__c;
            integer month = newContact.LastBoardTermStartDate__c.month();
            Date minTerm = newContact.LastBoardTermStartDate__c.addYears(3);
            integer months = 0;
            if (month < endMonth) {
                months = endMonth - month;
            }
            else if (month > endMonth && endMonth > 0) {
                months = 12 + endMonth - month;
            }
            // We want to wind up at the last day of June in the year following 3 years of service.
            // So, months + 1 takes us to July, toStartOfMonth() takes us to July 1, and subtracting
            // a day takes us to June 30.
            newContact.BoardTermValidUntil__c = minTerm.addMonths(months + 1).toStartOfMonth().addDays(-1);
        }

        // we've got the update going, so make sure UpdateForRelated__c is false
        newContact.UpdateForRelated__c = false;
    }
}