trigger ContactTriggerAfter on Contact(after update) {
    for (Contact newContact : Trigger.new) {
        string oldEmail = newContact.Email;
        string oldPhone = newContact.Phone;
        string oldPositions = newContact.Positions__c;
        if (Trigger.isUpdate) {
            //Get Old Value
            Contact oldContact = Trigger.oldMap.get(newContact.Id);
            oldEmail = oldContact.Email;
            oldPhone = oldContact.Phone;
            oldPositions = oldContact.Positions__c;
        }

        // if email changes, copy to appropriate related contacts
        Boolean changedEmail =
            !String.isBlank(newContact.Email) && oldEmail != newContact.Email;
        Boolean changedPhone =
            !String.isBlank(newContact.Phone) && oldPhone != newContact.Phone;
        if (changedEmail || changedPhone) {
            ContactService.updateRelatedContactEmailPhone(
                newContact,
                changedEmail,
                changedPhone
            );
        }
    }
}
