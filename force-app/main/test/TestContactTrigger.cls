@isTest
public with sharing class TestContactTrigger {
    public TestContactTrigger() {

    }

    private static Contact getContact(Id id) {
        return [SELECT Email, FirstName, npe01__HomeEmail__c FROM Contact WHERE Id = :id LIMIT 1];
    }

    @isTest
    static void insert_setsHomeEmail_WhenEmailSet() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow'
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(saved.Email, saved.npe01__HomeEmail__c);
        System.assertEquals(joe.Email, saved.npe01__HomeEmail__c);
    }
/*
    @isTest
    static void update_setsHomeEmail_WhenEmailChanged() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow'
        );
        insert joe;

        joe.Email = 'another-email@pump.com';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(saved.Email, saved.npe01__HomeEmail__c);
        System.assertEquals(joe.Email, saved.npe01__HomeEmail__c);
    }
    */
}
