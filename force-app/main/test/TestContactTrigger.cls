@isTest
public with sharing class TestContactTrigger {
    public TestContactTrigger() {

    }

    private static Contact getContact(Id id) {
        return [
            SELECT Email, FirstName, npe01__HomeEmail__c, npe01__AlternateEmail__c,
                Phone, HomePhone, OtherPhone,
                LastBoardTermStartDate__c, BoardTermValidUntil__c
            FROM Contact
            WHERE Id = :id LIMIT 1];
    }

    @isTest
    static void insert_LeavesEmailPhone_WhenHomeNotSetAndContactAtEmpty() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            Phone = 'generic-phone'
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.Email, saved.Email);
        System.assertEquals(joe.Phone, saved.Phone);
        System.assert(string.isBlank(saved.npe01__HomeEmail__c));
        System.assert(string.isBlank(saved.npe01__AlternateEmail__c));
        System.assert(string.isBlank(saved.HomePhone));
        System.assert(string.isBlank(saved.OtherPhone));
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
        System.assertEquals(Date.newInstance(2026, 1, 31), saved.BoardTermValidUntil__c);
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

        Date start = Date.newInstance(2023, 6, 6);
        joe.LastBoardTermStartDate__c = start;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(Date.newInstance(2026, 6, 30), saved.BoardTermValidUntil__c);
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
        System.assertEquals(Date.newInstance(2025, 7, 31), saved.BoardTermValidUntil__c);
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
        System.assertEquals(Date.newInstance(2025, 12, 31), saved.BoardTermValidUntil__c);
    }
}
