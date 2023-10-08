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

    // Share the contact with the appropriate groups based on which contacts they are emergency contacts for
    public static boolean shareContactBasedOnEmergencyRelationShips(Id recordId) {
        // Find who the contact is related to as an emergency contact
        npe4__Relationship__c[] related = [
            SELECT Id, npe4__Contact__r.Positions__c
            FROM npe4__Relationship__c
            WHERE
                npe4__Type__c LIKE '%Emergency Contact'
                AND npe4__Status__c = 'Current'
                AND npe4__RelatedContact__c = :recordId
        ];
        Set<String> positions = new Set<String>();
        for (npe4__Relationship__c relation : related) {
            String[] pos = relation.npe4__Contact__r.Positions__c.split(';');
            positions.addAll(pos);
        }
        Group[] groups = getGroupsForPositions(positions);
        return shareContactWithGroups(recordId, groups);
    }

    private static List<Group> getGroupsForPositions(Set<String> positions) {
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
        List<Group> groups = [
            SELECT Id, Name
            FROM Group
            WHERE Name IN :groupNames
        ];
        return groups;
    }

    private static boolean shareContactWithGroups(Id recordId, Group[] groups) {
        // Create new sharing objects for the contact based on the related contacts
        List<ContactShare> shares = new List<ContactShare>();

        for (Group grp : groups) {
            ContactShare share = new ContactShare();

            // Set the ID of record being shared.
            share.ContactId = recordId;

            // Set the ID of user or group being granted access.
            share.UserOrGroupId = grp.Id;

            // Set the access level.
            share.ContactAccessLevel = 'Edit';

            // Set rowCause to 'manual' for manual sharing.
            // This line can be omitted as 'manual' is the default value for sharing objects.
            share.RowCause = Schema.ContactShare.RowCause.Manual;

            shares.add(share);
        }
        // Insert the sharing record and capture the save result.
        // The false parameter allows for partial processing if multiple records passed
        // into the operation.
        List<Database.SaveResult> srs = Database.insert(shares, false);
        Boolean success = true;
        for (Database.SaveResult sr : srs) {
            // Process the save results.
            if (!sr.isSuccess()) {
                // Get first save result error.
                Database.Error err = sr.getErrors()[0];

                // Check if the error is related to trival access level.
                // Access level must be more permissive than the object's default.
                // These sharing records are not required and thus an insert exception is acceptable.
                if (
                    err.getStatusCode() ==
                    StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&
                    err.getMessage().contains('AccessLevel')
                ) {
                    // Indicates success.
                } else {
                    // Indicates failure.
                    success = false;
                }
            }
        }
        return success;
    }

    // Share the contact with the appropriate groups based on which positions they have
    public static boolean shareContactBasedOnPositions(Contact person) {
        Set<String> positions = new Set<String>(person.Positions__c.split(';'));
        Group[] groups = getGroupsForPositions(positions);
        return shareContactWithGroups(person.Id, groups);
    }
}
