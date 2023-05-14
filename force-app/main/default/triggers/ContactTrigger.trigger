trigger ContactTrigger on Contact (before insert, before update) {
    for (Contact newContact : Trigger.new) {
        string oldEmail = newContact.Email;
        string oldPhone = newContact.Phone;
        if (Trigger.isUpdate) {
            //Get Old Value
            Contact oldContact = trigger.oldMap.get(newContact.Id);
            oldEmail = oldContact.Email;
            oldPhone = oldContact.Phone;
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

        // if email changes, copy to appropriate related contacts
        Boolean changedEmail = oldEmail != newContact.Email;
        Boolean changedPhone = oldPhone != newContact.Phone;
        if (changedEmail || changedPhone) {
            ContactService.updateRelatedContactEmailPhone(newContact, changedEmail, changedPhone);
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
    }
}