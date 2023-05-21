trigger ContactTriggerAfter on Contact (after update) {
    for (Contact newContact : Trigger.new) {
        string oldEmail = newContact.Email;
        string oldPhone = newContact.Phone;
        if (Trigger.isUpdate) {
            //Get Old Value
            Contact oldContact = trigger.oldMap.get(newContact.Id);
            oldEmail = oldContact.Email;
            oldPhone = oldContact.Phone;
        }

        // if email changes, copy to appropriate related contacts
        Boolean changedEmail = oldEmail != newContact.Email;
        Boolean changedPhone = oldPhone != newContact.Phone;
        if (Trigger.isAfter && Trigger.isUpdate && (changedEmail || changedPhone)) {
            ContactService.updateRelatedContactEmailPhone(newContact, changedEmail, changedPhone);
        }
    }
}