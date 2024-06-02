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
    public static Contact shareContactBasedOnPositions(Contact person, Map<String, String> positionGroups) {
        // Create a set of the positions the user currently has
        Set<String> positions = new Set<String>();
        if (!String.isBlank(person.Positions__c)) {
            positions.addAll(person.Positions__c.split(';'));
        }
        Set<String> groups = new Set<String>();
        for (String position : positions) {
            String grp = positionGroups.get(position);
            if (grp != null) {
                groups.add(grp);
            }
        }

        // update this contact first, then its relations
        person = shareContactWithGroups(person, groups);
        return person;
    }

    // Get the positions of the contact relations
    private static Set<String> getRelationShipPositions(Contact record) {
        // Find who the contact is related to as an emergency contact
        npe4__Relationship__c[] related = [
            SELECT Id, npe4__Contact__r.Positions__c
            FROM npe4__Relationship__c
            WHERE
                (npe4__Type__c LIKE '%Emergency Contact'
                OR npe4__Type__c = 'Guardian')
                AND npe4__Status__c = 'Current'
                AND npe4__RelatedContact__c = :record.Id
        ];
        Set<String> positions = new Set<String>();
        if (!String.isBlank(record.Positions__c)) {
            positions.addAll(record.Positions__c.split(';'));
        }
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
    public static Map<String, String> getGroupsByPositions() {
        // Get the groups that can see each position
        List<CategoryRule__c> rules = [
            SELECT Group__c, Position__c
            FROM CategoryRule__c
            WHERE Position__c != null
        ];
        Map<String, String> groupNames = new Map<String, String>();
        for (CategoryRule__c rule : rules) {
            groupNames.put(rule.Position__c, rule.Group__c);
        }
        return groupNames;
    }

    private static Contact shareContactWithGroups(
        Contact contact,
        Set<String> groupNames
    ) {
        contact.ShareWithBoard__c = groupNames.contains('Board');
        contact.ShareWithPuppyRaiser__c = groupNames.contains('Puppy Raiser');
        contact.ShareWithStaff__c = groupNames.contains('Staff');
        contact.ShareWithStandalonePrograms__c = groupNames.contains('Standalone Programs');
        contact.ShareWithTeam__c = groupNames.contains('Team');
        contact.ShareWithTrainer__c = groupNames.contains('Trainer');
        contact.ShareWithVolunteer__c = groupNames.contains('Volunteer');
        return contact;
    }

    public static void setSharingFields() {
        List<Contact> contacts = [
            SELECT IsBoardMember__c, IsClient__c, IsPuppyRaiser__c, IsStaff__c, IsStandalone__c, IsTeamFacilitator__c, IsTrainer__c, IsVolunteer__c,
                    ShareWithBoard__c, ShareWithPuppyRaiser__c, ShareWithStaff__c, ShareWithStandalonePrograms__c, ShareWithTeam__c, ShareWithTrainer__c, ShareWithVolunteer__c
            FROM Contact
            WHERE IsBoardMember__c = TRUE OR IsClient__c = TRUE OR IsPuppyRaiser__c = TRUE OR IsStaff__c = TRUE OR IsStandalone__c = TRUE OR IsTeamFacilitator__c = TRUE OR IsTrainer__c = TRUE OR IsVolunteer__c = TRUE];

        Map<Id, Contact> contactMap = new Map<Id, Contact>();

        for (Contact person : contacts) {
            person.ShareWithBoard__c = person.IsBoardMember__c;
            person.ShareWithPuppyRaiser__c = person.IsPuppyRaiser__c;
            person.ShareWithStaff__c = person.IsStaff__c;
            person.ShareWithStandalonePrograms__c = person.IsStandalone__c;
            person.ShareWithTeam__c = person.IsClient__c || person.IsTeamFacilitator__c;
            person.ShareWithTrainer__c = person.IsTrainer__c;
            person.ShareWithVolunteer__c = person.IsVolunteer__c;
            contactMap.put(person.Id, person);
        }

        // Get related contacts
        npe4__Relationship__c[] related = [
            SELECT
                Id,
                npe4__RelatedContact__c,
                npe4__RelatedContact__r.Positions__c,
                npe4__RelatedContact__r.ShareWithBoard__c,
                npe4__RelatedContact__r.ShareWithPuppyRaiser__c,
                npe4__RelatedContact__r.ShareWithStaff__c,
                npe4__RelatedContact__r.ShareWithStandalonePrograms__c,
                npe4__RelatedContact__r.ShareWithTeam__c,
                npe4__RelatedContact__r.ShareWithTrainer__c,
                npe4__RelatedContact__r.ShareWithVolunteer__c,
                npe4__Contact__c
            FROM npe4__Relationship__c
            WHERE
                (npe4__Type__c LIKE '%Emergency Contact'
                OR npe4__Type__c = 'Guardian')
                AND npe4__Status__c = 'Current'
                AND npe4__Contact__c IN :contactMap.keySet()
        ];
        for (npe4__Relationship__c relation : related) {
            Contact shared = contactMap.get(relation.npe4__Contact__c);
            Contact share = contactMap.get(relation.npe4__RelatedContact__c);
            if (share == null) {
                share = relation.npe4__RelatedContact__r;
            }
            share.ShareWithBoard__c = share.ShareWithBoard__c || shared.ShareWithBoard__c;
            share.ShareWithPuppyRaiser__c = share.ShareWithPuppyRaiser__c || shared.ShareWithPuppyRaiser__c;
            share.ShareWithStaff__c = share.ShareWithStaff__c || share.ShareWithStaff__c;
            share.ShareWithStandalonePrograms__c = share.ShareWithStandalonePrograms__c || shared.ShareWithStandalonePrograms__c;
            share.ShareWithTeam__c = share.ShareWithTeam__c || shared.ShareWithTeam__c;
            share.ShareWithTrainer__c = share.ShareWithTrainer__c || shared.ShareWithTrainer__c;
            share.ShareWithVolunteer__c = share.ShareWithVolunteer__c || shared.ShareWithVolunteer__c;
            if (!contactMap.containsKey(relation.npe4__RelatedContact__c)) {
                contactMap.put(relation.npe4__RelatedContact__c, share);
            }
        }
        update contactMap.values();
    }
}
