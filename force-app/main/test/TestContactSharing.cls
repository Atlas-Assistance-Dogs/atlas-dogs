/*
 * This test class verifies code in ContactTrigger, RelationshipTrigger, and ContactService.
 * Because these three classes inter-relate so much (like Relationships),
 * Test for the desired combined behavior is here.
 */
@isTest
public with sharing class TestContactSharing    {
    // Test that the triggers produce the desired sharing
    static testMethod void shareContactBasedOnPositions_sharesClient() {
        // Arrange / Act
        setupBradyBunch();

        // Assert
        // Get the contacts with lastest sharing fields
        cindy = getContactWithShares(cindy.Id);
        marsha = getContactWithShares(marsha.Id);
        mike = getContactWithShares(mike.Id);
        carol = getContactWithShares(carol.Id);
        // check ShareTeam
        System.assert(cindy.ShareTeam__c);
        System.assert(marsha.ShareTeam__c);
        System.assert(mike.ShareTeam__c);
        System.assert(carol.ShareTeam__c);
    }

    @isTest
    static void shareContactBasedOnPositions_updatesShareForVolunteer() {
        // Arrange
        setupBradyBunch();
        cindy.Positions__c = 'Volunteer';

        // Act
        update cindy;

        // Assert
        // Get the contacts with lastest sharing fields
        cindy = getContactWithShares(cindy.Id);
        marsha = getContactWithShares(marsha.Id);
        mike = getContactWithShares(mike.Id);
        carol = getContactWithShares(carol.Id);
        // check ShareVolunteer
        System.assert(cindy.ShareVolunteer__c);
        System.assert(marsha.ShareVolunteer__c);
        System.assert(mike.ShareVolunteer__c);
        System.assert(carol.ShareVolunteer__c);
        // check ShareTeam
        System.assert(!cindy.ShareTeam__c);
        System.assert(!marsha.ShareTeam__c);
        System.assert(!mike.ShareTeam__c);
        System.assert(!carol.ShareTeam__c);
    }

    private static Contact getContactWithShares(Id contactId) {
        return [SELECT Id, ShareBoard__c, SharePuppyRaiser__c, ShareStaff__c, ShareStandalonePrograms__c,
        ShareTeam__c, ShareTrainer__c, ShareVolunteer__c
        FROM Contact WHERE Id = :contactId];
    }

    private static Contact cindy;
    private static Contact marsha;
    private static Contact mike;
    private static Contact carol;
    private static Contact bobby;

    private static void setupBradyBunch() {
        TestUtilities.insertCategoryRules();
        TestUtilities.insertRelationShipLookup();

        // Select users for the test.
        List<User> users = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 2];

        // Create new Client
        cindy = new Contact(
            FirstName = 'Cindy',
            LastName = 'Brady',
            Email = 'janet@brady.com',
            Positions__c = 'Client'
        );

        // Create Emergency Contacts
        marsha = new Contact(
            FirstName = 'Marsha',
            LastName = 'Brady',
            Email = 'marsha@brady.com'
        );
        mike = new Contact(
            FirstName = 'Mike',
            LastName = 'Brady',
            Email = 'mike@brady.com'
        );

        // Create Guardian
        carol = new Contact(
            FirstName = 'Carol',
            LastName = 'Brady',
            Email = 'carol@brady.com'
        );

        // insert the contacts
        insert new List<Contact>{ cindy, marsha, mike, carol };

        // create the relationships
        npe4__Relationship__c emergency1 = new npe4__Relationship__c(
            npe4__Contact__c = cindy.Id,
            npe4__RelatedContact__c = marsha.Id,
            npe4__Type__c = 'Primary Emergency Contact',
            npe4__Status__c = 'Current'
        );
        npe4__Relationship__c emergency2 = new npe4__Relationship__c(
            npe4__Contact__c = cindy.Id,
            npe4__RelatedContact__c = mike.Id,
            npe4__Type__c = 'Secondary Emergency Contact',
            npe4__Status__c = 'Current'
        );
        npe4__Relationship__c guardian = new npe4__Relationship__c(
            npe4__Contact__c = cindy.Id,
            npe4__RelatedContact__c = carol.Id,
            npe4__Type__c = 'Guardian',
            npe4__Status__c = 'Current'
        );
        insert new List<npe4__Relationship__c>{
            emergency1,
            emergency2,
            guardian
        };
    }
}
