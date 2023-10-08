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

        // Set PreferredName if not already set
        if (String.isBlank(newContact.PreferredName__c)) {
            newContact.PreferredName__c = newContact.FirstName;
        }

        // Set BoardTermValidUntil
        if (newContact.LastBoardTermStartDate__c != null) {
            integer month = newContact.LastBoardTermStartDate__c.month();
            Date minTerm = newContact.LastBoardTermStartDate__c.addYears(3);
            // We want to wind up at the last day of the month following 3 years of service.
            // So, months + 1 takes us to the next month, toStartOfMonth() takes us to the first day of the month, and subtracting
            // a day takes us back to the last day of the month they started in.
            newContact.BoardTermValidUntil__c = minTerm.addMonths(1).toStartOfMonth().addDays(-1);
        }
    }
}