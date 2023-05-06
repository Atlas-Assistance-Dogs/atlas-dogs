trigger ContactTrigger on Contact (before insert, before update) {
    for (Contact newContact : Trigger.new) {
        string oldEmail = null;
        if (Trigger.isUpdate) {
            //Get Old Value
            Contact oldContact = trigger.oldMap.get(newContact.Id);
            oldEmail = oldContact.Email;
        }
        
        // Check if Contact is set
        if (!String.isBlank(newContact.Contact__c)) {
            string contact = newContact.Contact__c;
            if (contact == 'Home') {
                if (!string.isBlank(newContact.npe01__HomeEmail__c)) {
                    newContact.Email = newContact.npe01__HomeEmail__c;
                }
                if (!string.isBlank(newContact.HomePhone)) {
                    newContact.Phone = newContact.HomePhone;
                }
            }
            else if (contact == 'Alternate') {
                if (!string.isBlank(newContact.npe01__AlternateEmail__c)) {
                    newContact.Email = newContact.npe01__AlternateEmail__c;
                }
                if (!string.isBlank(newContact.OtherPhone)) {
                    newContact.Phone = newContact.OtherPhone;
                }
            }
            else {
                // see if the type matches a relationship type
                List<npe4__Relationship__c> related = [
                    SELECT Id, npe4__RelatedContact__c, npe4__RelatedContact__r.Email, npe4__RelatedContact__r.Phone
                    FROM npe4__Relationship__c
                    WHERE npe4__Type__c = :contact AND npe4__Contact__c = :newContact.Id AND npe4__Status__c = 'Current'
                ];
                if (!related.isEmpty()) {
                    // use the first Contact that matches
                    Contact person = related[0].npe4__RelatedContact__r;
                    if (!string.isBlank(person.Email)) {
                        newContact.Email = person.Email;
                    }
                    if (!string.isBlank(person.Phone)) {
                        newContact.Phone = person.Phone;
                    }
                }
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
    }
}