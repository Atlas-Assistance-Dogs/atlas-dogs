trigger ContactTrigger on Contact (before insert, before update) {
    Map<Id, Contact> modifiedContacts = new Map<Id, Contact>();
    Map<String, String> positionGroups = ContactService.getGroupsByPositions();
    for (Contact newContact : Trigger.new) {
        string oldEmail = newContact.Email;
        string oldPhone = newContact.Phone;
        string oldPositions = null;
        Date oldBoardDate = null;
        Date oldFirstAidDate = null;
        if (Trigger.isUpdate) {
            //Get Old Value
            Contact oldContact = trigger.oldMap.get(newContact.Id);
            oldEmail = oldContact.Email;
            oldPhone = oldContact.Phone;
            oldPositions = oldContact.Positions__c;
            oldBoardDate = oldContact.LastBoardTermStartDate__c;
            oldFirstAidDate = oldContact.FirstAidReceived__c;
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
        ContactService.setBoardTermValidUntil(newContact, oldBoardDate);

        // we've got the update going, so make sure UpdateForRelated__c is false
        newContact.UpdateForRelated__c = false;


        if (newContact.Positions__c != oldPositions || newContact.UpdateSharing__c) {
            newContact = ContactService.shareContactBasedOnPositions(newContact, positionGroups);
            newContact.UpdateSharing__c = false;
            if (!Trigger.isInsert) {
                modifiedContacts.put(newContact.Id, newContact);
            }
        }

        ContactService.updateFirstAidValidUntil(newContact, oldFirstAidDate);
    }

    if (!Trigger.isInsert) {
        // finish modifying these contacts
        // Find who the contacts are related to as emergency contacts or guardian
        npe4__Relationship__c[] relationships = [
            SELECT
                npe4__Contact__r.Positions__c,
                npe4__Contact__r.ShareBoard__c,
                npe4__Contact__r.SharePuppyRaiser__c,
                npe4__Contact__r.ShareStaff__c,
                npe4__Contact__r.ShareStandalonePrograms__c,
                npe4__Contact__r.ShareTeam__c,
                npe4__Contact__r.ShareTrainer__c,
                npe4__Contact__r.ShareVolunteer__c,
                npe4__RelatedContact__c,
                npe4__RelatedContact__r.Positions__c,
                npe4__RelatedContact__r.ShareBoard__c,
                npe4__RelatedContact__r.SharePuppyRaiser__c,
                npe4__RelatedContact__r.ShareStaff__c,
                npe4__RelatedContact__r.ShareStandalonePrograms__c,
                npe4__RelatedContact__r.ShareTeam__c,
                npe4__RelatedContact__r.ShareTrainer__c,
                npe4__RelatedContact__r.ShareVolunteer__c
            FROM npe4__Relationship__c
            WHERE
                (npe4__Type__c LIKE '%Emergency Contact'
                OR npe4__Type__c = 'Guardian')
                AND npe4__Status__c = 'Current'
                AND npe4__RelatedContact__c in :modifiedContacts.keySet()
        ];

        for (npe4__Relationship__c relationship : relationships) {
            Contact source = relationship.npe4__Contact__r;
            Contact relation = modifiedContacts.get(relationship.npe4__RelatedContact__c);
            if (relation != null) {
                relation.ShareBoard__c = relation.ShareBoard__c || source.ShareBoard__c;
                relation.SharePuppyRaiser__c = relation.SharePuppyRaiser__c || source.SharePuppyRaiser__c;
                relation.ShareStaff__c = relation.ShareStaff__c || source.ShareStaff__c;
                relation.ShareStandalonePrograms__c = relation.ShareStandalonePrograms__c || source.ShareStandalonePrograms__c;
                relation.ShareTeam__c = relation.ShareTeam__c || source.ShareTeam__c;
                relation.ShareTrainer__c = relation.ShareTrainer__c || source.ShareTrainer__c;
                relation.ShareVolunteer__c = relation.ShareVolunteer__c || source.ShareVolunteer__c;
            }
        }
    }
}