trigger ContactTriggerAfter on Contact(after update) {
    Set<Id> modified = new Set<Id>();
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

        if (newContact.Positions__c != oldPositions && !Trigger.isInsert) {
            modified.add(newContact.Id);
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
    
    // now update the modified contacts relations
    List<npe4__Relationship__c> relationships = [
        SELECT npe4__RelatedContact__c, npe4__RelatedContact__r.Name, npe4__RelatedContact__r.UpdateSharing__c
        FROM npe4__Relationship__c
        WHERE
            (npe4__Type__c LIKE '%Emergency Contact'
            OR npe4__Type__c = 'Guardian')
            AND npe4__Status__c = 'Current'
            AND npe4__Contact__c IN :modified
    ];
    Map<Id, Contact> related = new Map<Id, Contact>();
    for (npe4__Relationship__c relationship : relationships) {
        relationship.npe4__RelatedContact__r.UpdateSharing__c = true;
        related.put(
            relationship.npe4__RelatedContact__c,
            relationship.npe4__RelatedContact__r
        );
    }
    update related.values();
}
