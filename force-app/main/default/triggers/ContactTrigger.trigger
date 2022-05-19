trigger ContactTrigger on Contact (before insert, before update) {
    for (Contact newContact : Trigger.new) {
        //Get Old Values
        Contact oldContact = trigger.oldMap.get(newContact.Id);
        
        // Check if value is updated
        if (oldContact.Email != newContact.Email) {
            newContact.npe01_HomeEmail__c = Email;
        }
    }
}