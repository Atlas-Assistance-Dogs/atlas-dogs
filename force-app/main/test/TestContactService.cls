@isTest
public with sharing class TestContactService {
    // Test for the manualShareRead method
    static testMethod void shareContactBasedOnPositions_sharesClientAndRelatedContacts() {
        // Arrange
        TestUtilities.insertCategoryRules();

        // Select users for the test.
        List<User> users = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 2];
        Id user1Id = users[0].Id;
        Id user2Id = users[1].Id;

        // Create new Client
        Contact cindy = new Contact(
            FirstName = 'Cindy',
            LastName = 'Brady',
            Email = 'janet@brady.com',
            OwnerId = user1Id,
            Positions__c = 'Client'
        );

        // Create Emergency Contacts
        Contact marsha = new Contact(
            FirstName = 'Marsha',
            LastName = 'Brady',
            Email = 'marsha@brady.com'
        );
        Contact mike = new Contact(
            FirstName = 'Mike',
            LastName = 'Brady',
            Email = 'mike@brady.com'
        );

        // Create Guardian
        Contact carol = new Contact(
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

        // Act
        ContactService.shareContactBasedOnPositions(cindy);

        // Assert
        // Get the Client group Id
        Group clientGroup = [SELECT Id FROM Group WHERE Name = 'Team' LIMIT 1];
        assertGroupShare(cindy.Id, clientGroup.Id);
        assertGroupShare(marsha.Id, clientGroup.Id);
        assertGroupShare(mike.Id, clientGroup.Id);
        assertGroupShare(carol.Id, clientGroup.Id);
    }

    private static void assertGroupShare(Id contactId, Id groupId) {
        // Query job sharing records.
        List<ContactShare> shares = [
            SELECT Id, UserOrGroupId, ContactAccessLevel, RowCause
            FROM Contactshare
            WHERE ContactId = :contactId AND UserOrGroupId = :groupId
        ];

        // Test for only one manual share on job.
        System.assertEquals(
            1,
            shares.size(),
            'Set the object\'s sharing model to Private.'
        );

        // Test attributes of manual share.
        System.assertEquals(shares[0].ContactAccessLevel, 'Edit');
        System.assertEquals(shares[0].RowCause, 'Manual');
    }
}
