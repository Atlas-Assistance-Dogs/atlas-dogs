trigger ContactTrigger on Contact (before insert, after update) {
    for (Contact newContact : Trigger.new) {
        string oldEmail = null;
        if (Trigger.isUpdate) {
            //Get Old Value
            Contact oldContact = trigger.oldMap.get(newContact.Id);
            oldEmail = oldContact.Email;
        }
        
        // Check if value is updated
        if (oldEmail != newContact.Email) {
            newContact.npe01__HomeEmail__c = newContact.Email;
        }

        // Set PreferredName if not already set
        if (String.isBlank(newContact.PreferredName__c)) {
            newContact.PreferredName__c = newContact.FirstName;
        }
    }
}