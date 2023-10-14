public with sharing class ContactService {
    // This copies the contact email and phone to the ContactAt email & phone,
    // as long as the Email and Phone are not blank and ContactAt is Home or Alternate
    public static Contact updateContactAtEmail(Contact newContact) {
        string contact = newContact.Contact__c;
        if (contact == 'Home' && !string.isBlank(newContact.Email)) {
            newContact.npe01__HomeEmail__c = newContact.Email;
        } else if (
            contact == 'Alternate' && !string.isBlank(newContact.Email)
        ) {
            newContact.npe01__AlternateEmail__c = newContact.Email;
        }
        return newContact;
    }

    public static Contact updateContactAtPhone(Contact newContact) {
        string contact = newContact.Contact__c;
        if (contact == 'Home' && !string.isBlank(newContact.Phone)) {
            newContact.HomePhone = newContact.Phone;
        } else if (
            contact == 'Alternate' && !string.isBlank(newContact.Phone)
        ) {
            newContact.OtherPhone = newContact.Phone;
        }
        return newContact;
    }

    // Update email based on the ContactAt value
    public static Contact updateEmail(Contact newContact) {
        string contact = newContact.Contact__c;
        if (contact == 'Home') {
            if (!string.isBlank(newContact.npe01__HomeEmail__c)) {
                newContact.Email = newContact.npe01__HomeEmail__c;
            }
        } else if (contact == 'Alternate') {
            if (!string.isBlank(newContact.npe01__AlternateEmail__c)) {
                newContact.Email = newContact.npe01__AlternateEmail__c;
            }
        } else {
            // see if the type matches a relationship type
            List<npe4__Relationship__c> related = [
                SELECT
                    Id,
                    npe4__RelatedContact__c,
                    npe4__RelatedContact__r.Email
                FROM npe4__Relationship__c
                WHERE
                    npe4__Type__c = :contact
                    AND npe4__Contact__c = :newContact.Id
                    AND npe4__Status__c = 'Current'
            ];
            if (!related.isEmpty()) {
                // use the first Contact that matches
                Contact person = related[0].npe4__RelatedContact__r;
                if (!string.isBlank(person.Email)) {
                    newContact.Email = person.Email;
                }
            }
        }
        return newContact;
    }

    // Update the Contact's phone based on the current value from ContactAt
    public static Contact updatePhone(Contact newContact) {
        string contact = newContact.Contact__c;
        if (contact == 'Home') {
            if (!string.isBlank(newContact.HomePhone)) {
                newContact.Phone = newContact.HomePhone;
            }
        } else if (contact == 'Alternate') {
            if (!string.isBlank(newContact.OtherPhone)) {
                newContact.Phone = newContact.OtherPhone;
            }
        } else {
            // see if the type matches a relationship type
            List<npe4__Relationship__c> related = [
                SELECT
                    Id,
                    npe4__RelatedContact__c,
                    npe4__RelatedContact__r.Phone
                FROM npe4__Relationship__c
                WHERE
                    npe4__Type__c = :contact
                    AND npe4__Contact__c = :newContact.Id
                    AND npe4__Status__c = 'Current'
            ];
            if (!related.isEmpty()) {
                // use the first Contact that matches
                Contact person = related[0].npe4__RelatedContact__r;
                if (!string.isBlank(person.Phone)) {
                    newContact.Phone = person.Phone;
                }
            }
        }
        return newContact;
    }

    // Update the email of a related contact
    public static void updateRelatedContactEmailPhone(
        Contact current,
        Boolean changedEmail,
        Boolean changedPhone
    ) {
        System.debug(current.Id);
        List<npe4__Relationship__c> related = [
            SELECT
                Id,
                npe4__Contact__c,
                npe4__Type__c,
                npe4__RelatedContact__c,
                npe4__Contact__r.Email,
                npe4__RelatedContact__r.Phone,
                npe4__Contact__r.Contact__c
            FROM npe4__Relationship__c
            WHERE
                npe4__RelatedContact__c = :current.Id
                AND npe4__Status__c = 'Current'
        ];
        if (!related.isEmpty()) {
            List<Contact> contacts = new List<Contact>();
            for (npe4__Relationship__c relationship : related) {
                if (
                    relationship.npe4__Contact__r.Contact__c ==
                    relationship.npe4__Type__c
                ) {
                    if (changedEmail) {
                        relationship.npe4__Contact__r.Email = current.Email;
                    }
                    if (changedPhone) {
                        relationship.npe4__Contact__r.Phone = current.Phone;
                    }
                    contacts.add(relationship.npe4__Contact__r);
                }
            }
            update contacts;
        }
    }

    // Share the contact with the appropriate groups based on which positions they have,
    // and the positions they are emergency contacts for
    public static void shareContactBasedOnPositions(Contact person) {
        // Create a set of the positions the user currently has
        Set<String> positions = new Set<String>();
        if (!String.isBlank(person.Positions__c)) {
            positions.addAll(person.Positions__c.split(';'));
        }
        Set<String> groups = getGroupsForPositions(positions);

        // update this contact first, then its relations
        updateContactSharedGroups(person, groups);

        Set<Id> relatedContactIds = getRelatedContactsToShare(person.Id);
        for (Id relatedId : relatedContactIds) {
            Set<String> relatedPositions = getRelationShipPositions(relatedId);
            Set<String> relatedGroups = getGroupsForPositions(relatedPositions);
            updateContactSharedGroups(relatedId, relatedGroups);
        }
    }

    // Share the appropriate related contacts
    public static Set<Id> getRelatedContactsToShare(Id recordId) {
        // Find who the contact is related to as emergency contacts or guardian
        npe4__Relationship__c[] related = [
            SELECT Id, npe4__RelatedContact__c
            FROM npe4__Relationship__c
            WHERE
                (npe4__Type__c LIKE '%Emergency Contact' OR npe4__Type__c = 'Guardian')
                AND npe4__Status__c = 'Current'
                AND npe4__Contact__c = :recordId
        ];
        Set<Id> contactIds = new Set<Id>();
        for (npe4__Relationship__c relation : related) {
            contactIds.add(relation.npe4__RelatedContact__c);
        }
        return contactIds;
    }

    // Get the positions of the contact relations
    private static Set<String> getRelationShipPositions(Id recordId) {
        // Find who the contact is related to as an emergency contact
        npe4__Relationship__c[] related = [
            SELECT Id, npe4__Contact__r.Positions__c
            FROM npe4__Relationship__c
            WHERE
                (npe4__Type__c LIKE '%Emergency Contact' OR npe4__Type__c = 'Guardian')
                AND npe4__Status__c = 'Current'
                AND npe4__RelatedContact__c = :recordId
        ];
        Set<String> positions = new Set<String>();
        for (npe4__Relationship__c relation : related) {
            if (String.isBlank(relation.npe4__Contact__r.Positions__c)) {
                continue;
            }
            String[] pos = relation.npe4__Contact__r.Positions__c.split(';');
            positions.addAll(pos);
        }
        return positions;
    }

    // Get the groups that the category rules assign for the positions
    private static Set<String> getGroupsForPositions(Set<String> positions) {
        // Get the groups that can see each position
        List<CategoryRule__c> rules = [
            SELECT Group__c
            FROM CategoryRule__c
            WHERE Position__c IN :positions
        ];
        Set<String> groupNames = new Set<String>();
        for (CategoryRule__c rule : rules) {
            groupNames.add(rule.Group__c);
        }
        return groupNames;
    }

    private static void shareContactWithGroups(Contact contact, Set<String> groupNames) {
        contact.ShareWithBoard__c = groupNames.contains('Board');
        contact.ShareWithPuppyRaiser__c = groupNames.contains('Puppy Raiser');
        contact.ShareWithStaff__c = groupNames.contains('Staff');
        contact.ShareWithStandalonePrograms__c = groupNames.contains('Standalone Programs');
        contact.ShareWithTeam__c = groupNames.contains('Team');
        contact.ShareWithTrainer__c = groupNames.contains('Trainer');
        contact.ShareWithVolunteer__c = groupNames.contains('Volunteer');
    }
}
