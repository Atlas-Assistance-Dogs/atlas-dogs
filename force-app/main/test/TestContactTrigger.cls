@isTest
public with sharing class TestContactTrigger {
    public TestContactTrigger() {

    }

    private static Contact getContact(Id id) {
        return [SELECT Email, FirstName, npe01__HomeEmail__c,LastBoardTermStartDate__c,BoardTermValidUntil__c FROM Contact WHERE Id = :id LIMIT 1];
    }

    @isTest
    static void insert_setsEmail_WhenHomeEmailSetAndContactAtHome() {
        Contact joe = new Contact(
            Email = 'joe@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            npe01__HomeEmail__c = 'joe-blow@pump.com',
            Contact__c = 'Home'
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.npe01__HomeEmail__c, saved.Email);
        System.assertEquals(joe.npe01__HomeEmail__c, saved.npe01__HomeEmail__c);
    }

    @isTest
    static void update_setsBoardTermEnd_whenStartInJanuary() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            LastBoardTermStartDate__c = null
        );
        insert joe;

        Date start = Date.newInstance(2023, 1, 1);
        joe.LastBoardTermStartDate__c = start;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(saved.BoardTermValidUntil__c, Date.newInstance(2026, 6, 30));
    }

    @isTest
    static void update_setsBoardTermEnd_whenStartJune() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            LastBoardTermStartDate__c = null
        );
        insert joe;

        Date start = Date.newInstance(2023, 6, 30);
        joe.LastBoardTermStartDate__c = start;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(saved.BoardTermValidUntil__c, Date.newInstance(2026, 6, 30));
    }

    @isTest
    static void update_setsBoardTermEnd_whenStartJuly() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            LastBoardTermStartDate__c = null
        );
        insert joe;

        Date start = Date.newInstance(2022, 7, 4);
        joe.LastBoardTermStartDate__c = start;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(saved.BoardTermValidUntil__c, Date.newInstance(2026, 6, 30));
    }

    @isTest
    static void update_setsBoardTermEnd_whenStartDecember() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            LastBoardTermStartDate__c = null
        );
        insert joe;

        Date start = Date.newInstance(2022, 12, 25);
        joe.LastBoardTermStartDate__c = start;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(saved.BoardTermValidUntil__c, Date.newInstance(2026, 6, 30));
    }
}
