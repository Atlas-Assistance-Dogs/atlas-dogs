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
    public static Contact shareContactBasedOnPositions(
        Contact person,
        Map<String, String> positionGroups
    ) {
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
            SELECT GroupName__c, Position__c
            FROM CategoryRule__c
            WHERE Position__c != NULL
        ];
        Map<String, String> groupNames = new Map<String, String>();
        for (CategoryRule__c rule : rules) {
            groupNames.put(rule.Position__c, rule.GroupName__c);
        }
        return groupNames;
    }

    private static Contact shareContactWithGroups(
        Contact contact,
        Set<String> groupNames
    ) {
        contact.ShareBoard__c = groupNames.contains('Board');
        contact.SharePuppyRaiser__c = groupNames.contains('Puppy Raiser');
        contact.ShareStaff__c = groupNames.contains('Staff');
        contact.ShareStandalonePrograms__c = groupNames.contains(
            'Standalone Programs'
        );
        contact.ShareTeam__c = groupNames.contains('Team');
        contact.ShareTrainer__c = groupNames.contains('Trainer');
        contact.ShareVolunteer__c = groupNames.contains('Volunteer');
        return contact;
    }

    public static void setSharingFields() {
        List<Contact> contacts = [
            SELECT
                IsBoardMember__c,
                IsClient__c,
                IsPuppyRaiser__c,
                IsStaff__c,
                IsStandalone__c,
                IsTeamFacilitator__c,
                IsTrainer__c,
                IsVolunteer__c,
                ShareBoard__c,
                SharePuppyRaiser__c,
                ShareStaff__c,
                ShareStandalonePrograms__c,
                ShareTeam__c,
                ShareTrainer__c,
                ShareVolunteer__c
            FROM Contact
            WHERE
                IsBoardMember__c = TRUE
                OR IsClient__c = TRUE
                OR IsPuppyRaiser__c = TRUE
                OR IsStaff__c = TRUE
                OR IsStandalone__c = TRUE
                OR IsTeamFacilitator__c = TRUE
                OR IsTrainer__c = TRUE
                OR IsVolunteer__c = TRUE
        ];

        Map<Id, Contact> contactMap = new Map<Id, Contact>();

        for (Contact person : contacts) {
            person.ShareBoard__c = person.IsBoardMember__c;
            person.SharePuppyRaiser__c = person.IsPuppyRaiser__c;
            person.ShareStaff__c = person.IsStaff__c;
            person.ShareStandalonePrograms__c = person.IsStandalone__c;
            person.ShareTeam__c =
                person.IsClient__c || person.IsTeamFacilitator__c;
            person.ShareTrainer__c = person.IsTrainer__c;
            person.ShareVolunteer__c = person.IsVolunteer__c;
            contactMap.put(person.Id, person);
        }

        // Get related contacts
        npe4__Relationship__c[] related = [
            SELECT
                Id,
                npe4__RelatedContact__c,
                npe4__RelatedContact__r.Positions__c,
                npe4__RelatedContact__r.ShareBoard__c,
                npe4__RelatedContact__r.SharePuppyRaiser__c,
                npe4__RelatedContact__r.ShareStaff__c,
                npe4__RelatedContact__r.ShareStandalonePrograms__c,
                npe4__RelatedContact__r.ShareTeam__c,
                npe4__RelatedContact__r.ShareTrainer__c,
                npe4__RelatedContact__r.ShareVolunteer__c,
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
            share.ShareBoard__c = share.ShareBoard__c || shared.ShareBoard__c;
            share.SharePuppyRaiser__c =
                share.SharePuppyRaiser__c || shared.SharePuppyRaiser__c;
            share.ShareStaff__c = share.ShareStaff__c || share.ShareStaff__c;
            share.ShareStandalonePrograms__c =
                share.ShareStandalonePrograms__c ||
                shared.ShareStandalonePrograms__c;
            share.ShareTeam__c = share.ShareTeam__c || shared.ShareTeam__c;
            share.ShareTrainer__c =
                share.ShareTrainer__c || shared.ShareTrainer__c;
            share.ShareVolunteer__c =
                share.ShareVolunteer__c || shared.ShareVolunteer__c;
            if (!contactMap.containsKey(relation.npe4__RelatedContact__c)) {
                contactMap.put(relation.npe4__RelatedContact__c, share);
            }
        }
        update contactMap.values();
    }

    public static void setBoardTermValidUntil(
        Contact newContact,
        Date oldBoardDate
    ) {
        if (
            newContact.LastBoardTermStartDate__c != null &&
            newContact.LastBoardTermStartDate__c != oldBoardDate
        ) {
            AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
            // check to see if settings are missing
            if (settings.BoardTermEndMonth__c == null) {
                // TODO: get default value
                settings.BoardTermEndMonth__c = 4;
                upsert settings;
            }
            Integer endMonth = (Integer) settings.BoardTermEndMonth__c;
            integer month = newContact.LastBoardTermStartDate__c.month();
            Date minTerm = newContact.LastBoardTermStartDate__c.addYears(3);
            integer months = 0;
            if (month < endMonth) {
                months = endMonth - month;
            } else if (month > endMonth && endMonth > 0) {
                months = 12 + endMonth - month;
            }
            // We want to wind up at the last day of June in the year following 3 years of service.
            // So, months + 1 takes us to July, toStartOfMonth() takes us to July 1, and subtracting
            // a day takes us to June 30.
            newContact.BoardTermValidUntil__c = minTerm.addMonths(months + 1)
                .toStartOfMonth()
                .addDays(-1);
        }
    }

    public static void updateFirstAidValidUntil(
        Contact newContact,
        Date oldFirstAidDate
    ) {
        if (newContact.FirstAidReceived__c == null) {
            newContact.FirstAidValidUntil__c = null;
            return;
        }
        if (
            newContact.FirstAidReceived__c != null &&
            newContact.FirstAidReceived__c != oldFirstAidDate
        ) {
            AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
            // check to see if settings are missing
            if (settings.FirstAidRenewalYears__c == null) {
                // TODO: get default value
                settings.FirstAidRenewalYears__c = 2;
                upsert settings;
            }
            newContact.FirstAidValidUntil__c = newContact.FirstAidReceived__c.addYears(
                (integer) settings.FirstAidRenewalYears__c
            );
        }
    }

    class Dates {
        public Date initial { get; set; }
        public Date expiration { get; set; }
    }

    public static void updateCertValidUntil(Contact trainer) {
        // check to see if settings are missing
        Boolean updateSettings = false;
        AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
        if (settings.CertRenewalYears__c == null) {
            // TODO: get default value
            settings.CertRenewalYears__c = 1;
            updateSettings = true;
        }
        if (settings.EarlyRenewal__c == null) {
            // TODO: get default value
            settings.EarlyRenewal__c = 90;
            updateSettings = true;
        }
        if (settings.RenewalLeeway__c == null) {
            // TODO: get default value
            settings.RenewalLeeway__c = 30;
            updateSettings = true;
        }
        if (updateSettings) {
            upsert settings;
        }
        Integer years = (Integer) settings.CertRenewalYears__c;
        Integer early = (Integer) settings.EarlyRenewal__c;
        Integer leeway = (Integer) settings.RenewalLeeway__c;
        if (
            trainer.IsTrainer__c &&
            trainer.TrainerCertAgreementReceived__c != null
        ) {
            if (trainer.TrainerInitialCertificationDate__c == null) {
                trainer.TrainerInitialCertificationDate__c = trainer.TrainerCertAgreementReceived__c;
                trainer.TrainerCertValidUntil__c = trainer.TrainerCertAgreementReceived__c.addYears(1);
                return;
            }
            Integer days = trainer.TrainerCertAgreementReceived__c.daysBetween(trainer.TrainerCertValidUntil__c);
            if (days >= -early && days <= leeway) {
                trainer.TrainerCertValidUntil__c = trainer.TrainerCertValidUntil__c.addYears(years);
            }
        }
    }

    private static Dates getCertExpiration(
        Date initial,
        Date agreement,
        Integer early,
        Integer years,
        Integer leeway
    ) {
        Dates cdates = new Dates();
        cdates.initial = initial;
        if (agreement == null) {
            return cdates;
        }
        if (initial == null) {
            cdates.initial = agreement;
            cdates.expiration = agreement.addYears(years);
        } else {
            Integer moreYears = (agreement.daysBetween(initial) + 365 + leeway) / 365;
            cdates.expiration = initial.addYears(moreYears);
        }
        return cdates;
    }
}
