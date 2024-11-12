@isTest
private class TestBackgroundCheckRepository {

    @isTest
    static void getMatchingChecksForContacts_returnsEmpty_whenContactsIsNull() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(null, null);

        System.assert(result.isEmpty());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsEmpty_whenContactsIsEmpty() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>(), null);

        System.assert(result.isEmpty());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsEmpty_whenContactsAndDateAreEmpty() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>(), Date.today());

        System.assert(result.isEmpty());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsEmpty_whenContactsButNoBgChecks() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();
        List<Id> contactIds = MockCallData.contactids;

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>(contactIds), Date.today());

        System.assert(result.isEmpty());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsEmpty_whenCheckBeforeThreshold() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();
        Date threshold = Date.today().addMonths(-11);
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Credit Check Required'
        );
        insert bluey;
        BackgroundCheck__c check = new BackgroundCheck__c(
            Contact__c = bluey.Id,
            Status__c = 'Pass',
            Type__c = 'Credit',
            Date__c = threshold.addDays(-1)
        );
        insert check;

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>{ bluey.Id }, threshold);

        System.assert(result.isEmpty());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsEmpty_whenCheckAtThreshold() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();
        Date threshold = Date.today().addMonths(-11);
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Credit Check Required'
        );
        insert bluey;
        BackgroundCheck__c check = new BackgroundCheck__c(
            Contact__c = bluey.Id,
            Status__c = 'Pass',
            Type__c = 'Credit',
            Date__c = threshold
        );
        insert check;

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>{ bluey.Id }, threshold);

        System.assert(result.isEmpty());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsCheck_whenCheckAfterThreshold() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();
        Date threshold = Date.today().addMonths(-11);
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Credit Check Required'
        );
        insert bluey;
        BackgroundCheck__c check = new BackgroundCheck__c(
            Contact__c = bluey.Id,
            Status__c = 'Pass',
            Type__c = 'Credit',
            Date__c = threshold.addDays(1)
        );
        insert check;

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>{ bluey.Id }, threshold);

        System.assertEquals(1, result.size());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsEmpty_whenTypeMisMatch() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();
        Date threshold = Date.today().addMonths(-11);
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Credit Check Required'
        );
        Contact bingo = new Contact(
            FirstName = 'Bingo',
            LastName = 'Heeler',
            Email = 'bingo@test.com',
            VolunteerAccess__c = 'Background Check Required'
        );

        insert new Contact[]{ bluey, bingo };
        BackgroundCheck__c check1 = new BackgroundCheck__c(
            Contact__c = bluey.Id,
            Type__c = 'Criminal',
            Date__c = threshold.addDays(1)
        );
        BackgroundCheck__c check2 = new BackgroundCheck__c(
            Contact__c = bingo.Id,
            Type__c = 'Credit',
            Date__c = threshold.addDays(1)
        );
        insert new BackgroundCheck__c[] { check1, check2 };

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>{ bingo.Id, bluey.Id }, threshold);

        System.assert(result.isEmpty());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsCheck_whenTypeMatch() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();
        Date threshold = Date.today().addMonths(-11);
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Credit Check Required'
        );
        Contact bingo = new Contact(
            FirstName = 'Bingo',
            LastName = 'Heeler',
            Email = 'bingo@test.com',
            VolunteerAccess__c = 'Background Check Required'
        );

        insert new Contact[]{ bluey, bingo };
        BackgroundCheck__c check1 = new BackgroundCheck__c(
            Contact__c = bingo.Id,
            Type__c = 'Criminal',
            Date__c = threshold.addDays(1)
        );
        BackgroundCheck__c check2 = new BackgroundCheck__c(
            Contact__c = bluey.Id,
            Type__c = 'Credit',
            Date__c = threshold.addDays(1)
        );
        insert new BackgroundCheck__c[] { check1, check2 };

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>{ bingo.Id, bluey.Id }, threshold);

        System.assertEquals(2, result.size());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsCheck_whenBothRequired() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();
        Date threshold = Date.today().addMonths(-11);
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Credit Check Required;Background Check Required'
        );
        insert bluey;
        BackgroundCheck__c check = new BackgroundCheck__c(
            Contact__c = bluey.Id,
            Status__c = 'Pass',
            Type__c = 'Credit',
            Date__c = threshold.addDays(1)
        );
        insert check;

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>{ bluey.Id }, threshold);

        System.assertEquals(1, result.size());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsCriminalCheck_whenBothRequired() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();
        Date threshold = Date.today().addMonths(-11);
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Credit Check Required;Background Check Required'
        );
        insert bluey;
        BackgroundCheck__c check = new BackgroundCheck__c(
            Contact__c = bluey.Id,
            Status__c = 'Pass',
            Type__c = 'Criminal',
            Date__c = threshold.addDays(1)
        );
        insert check;

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>{ bluey.Id }, threshold);

        System.assertEquals(1, result.size());
    }
    @isTest
    static void getMatchingChecksForContacts_returnsChecks_whenBothRequired() {
        BackgroundCheckRepository repo = new BackgroundCheckRepository();
        Date threshold = Date.today().addMonths(-11);
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Credit Check Required;Background Check Required'
        );
        insert bluey;
        BackgroundCheck__c[] checks = new BackgroundCheck__c[]{
            new BackgroundCheck__c(
                Contact__c = bluey.Id,
                Status__c = 'Pass',
                Type__c = 'Credit',
                Date__c = threshold.addDays(1)
            ),
            new BackgroundCheck__c(
                Contact__c = bluey.Id,
                Status__c = 'Pass',
                Type__c = 'Criminal',
                Date__c = threshold.addDays(1)
            )
        };
        insert checks;

        List<BackgroundCheck__c> result = repo.getMatchingChecksForContacts(new Set<Id>{ bluey.Id }, threshold);

        System.assertEquals(2, result.size());
    }
}