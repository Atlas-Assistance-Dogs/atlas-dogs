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
        // check ShareWithTeam
        System.assert(cindy.ShareWithTeam__c);
        System.assert(marsha.ShareWithTeam__c);
        System.assert(mike.ShareWithTeam__c);
        System.assert(carol.ShareWithTeam__c);
    }

    static testMethod void shareContactBasedOnPositions_updatesShareForVolunteer() {
        // Arrange
        setupBradyBunch();
        ContactService.shareContactBasedOnPositions(cindy);
        cindy.Positions__c = 'Volunteer';

        // Act
        update cindy;

        // Assert
        // Get the contacts with lastest sharing fields
        cindy = getContactWithShares(cindy.Id);
        marsha = getContactWithShares(marsha.Id);
        mike = getContactWithShares(mike.Id);
        carol = getContactWithShares(carol.Id);
        // check ShareWithVolunteer
        System.assert(cindy.ShareWithVolunteer__c);
        System.assert(marsha.ShareWithVolunteer__c);
        System.assert(mike.ShareWithVolunteer__c);
        System.assert(carol.ShareWithVolunteer__c);
        // check ShareWithTeam
        System.assert(!cindy.ShareWithTeam__c);
        System.assert(!marsha.ShareWithTeam__c);
        System.assert(!mike.ShareWithTeam__c);
        System.assert(!carol.ShareWithTeam__c);
    }

    private static Contact getContactWithShares(Id contactId) {
        return [SELECT Id, ShareWithBoard__c, ShareWithPuppyRaiser__c, ShareWithStaff__c, ShareWithStandalonePrograms__c,
        ShareWithTeam__c, ShareWithTrainer__c, ShareWithVolunteer__c
        FROM Contact WHERE Id = :contactId];
    }

    private static Contact cindy;
    private static Contact marsha;
    private static Contact mike;
    private static Contact carol;
    private static Contact bobby;

    private static void setupBradyBunch() {
        TestUtilities.insertCategoryRules();

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
            npe4__Contact__c = marsha.Id,
            npe4__RelatedContact__c = cindy.Id,
            npe4__Type__c = 'Primary Emergency Contact',
            npe4__Status__c = 'Current'
        );
        npe4__Relationship__c emergency2 = new npe4__Relationship__c(
            npe4__Contact__c = mike.Id,
            npe4__RelatedContact__c = cindy.Id,
            npe4__Type__c = 'Secondary Emergency Contact',
            npe4__Status__c = 'Current'
        );
        npe4__Relationship__c guardian = new npe4__Relationship__c(
            npe4__Contact__c = carol.Id,
            npe4__RelatedContact__c = cindy.Id,
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
