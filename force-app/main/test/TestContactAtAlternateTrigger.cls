@isTest
public with sharing class TestContactAtAlternateTrigger {

    private static Contact createContact() {
        Contact joe = new Contact(
            Email = 'joe-blew@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            npe01__HomeEmail__c = 'joe-blow@pump.com',
            npe01__AlternateEmail__c = 'joe-blew@pump.com',
            Phone = 'other-phone',
            HomePhone = 'home-phone',
            OtherPhone = 'other-phone',
            Contact__c = 'Alternate'
        );
        insert joe;
        return joe;
    }

    private static Contact getContact(Id id) {
        return [
            SELECT Email, FirstName, npe01__HomeEmail__c, npe01__AlternateEmail__c,
                Phone, HomePhone, OtherPhone,
                LastBoardTermStartDate__c, BoardTermValidUntil__c
            FROM Contact
            WHERE Id = :id LIMIT 1];
    }

    private static void assertEmail(string email, Id contactId) {
        Contact saved = getContact(contactId);
        System.assertEquals(email, saved.Email);
        System.assertEquals(email, saved.npe01__AlternateEmail__c);
    }

    @isTest
    static void update_setsEmail_WhenAltEmailSetAndContactAtOther() {
        Contact joe = createContact();

        joe.npe01__AlternateEmail__c = 'joe-blow@bikepump.com';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertEmail(joe.npe01__AlternateEmail__c, result.getId());
    }

    @isTest
    static void update_setsAltEmail_WhenEmailChangedAndContactAtOther() {
        Contact joe = createContact();

        joe.Email = 'joe-blow@bikepump.com';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertEmail(joe.Email, result.getId());
    }

    @isTest
    static void update_leavesEmail_WhenAltEmailClearedAndContactAtOther() {
        Contact joe = createContact();

        joe.npe01__AlternateEmail__c = '';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.Email, saved.Email);
        System.assert(String.isBlank(saved.npe01__AlternateEmail__c));
    }

    @isTest
    static void update_leavesEmail_WhenAltEmailNullAndContactAtOther() {
        Contact joe = createContact();

        joe.npe01__AlternateEmail__c = null;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.Email, saved.Email);
        System.assert(String.isBlank(saved.npe01__AlternateEmail__c));
    }

    @isTest
    static void update_leavesAltEmail_WhenEmailNullAndContactAtOther() {
        Contact joe = createContact();

        joe.Email = null;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.npe01__AlternateEmail__c, saved.npe01__AlternateEmail__c);
        System.assert(String.isBlank(saved.Email));
    }

    @isTest
    static void update_leavesAltEmail_WhenEmailBlankAndContactAtOther() {
        Contact joe = createContact();

        joe.Email = ' ';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.npe01__AlternateEmail__c, saved.npe01__AlternateEmail__c);
        System.assert(String.isBlank(saved.Email));
    }

    @isTest
    static void update_setsPhone_WhenOtherPhoneSetAndContactAtOther() {
        Contact joe = createContact();

        joe.OtherPhone = 'other-phone';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.OtherPhone, saved.Phone);
        System.assertEquals(joe.OtherPhone, saved.OtherPhone);
    }

    @isTest
    static void update_setsOtherPhone_WhenPhoneChangedAndContactAtOther() {
        Contact joe = createContact();

        joe.Phone = 'vacation-phone';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.Phone, saved.Phone);
        System.assertEquals(joe.Phone, saved.OtherPhone);
    }

    @isTest
    static void update_leavesPhone_WhenOtherPhoneClearedAndContactAtOther() {
        Contact joe = createContact();

        joe.OtherPhone = '';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.Phone, saved.Phone);
        System.assert(String.isBlank(saved.OtherPhone));
    }

    @isTest
    static void update_leavesPhone_WhenOtherPhoneNullAndContactAtOther() {
        Contact joe = createContact();

        joe.OtherPhone = null;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.Phone, saved.Phone);
        System.assert(String.isBlank(saved.OtherPhone));
    }

    @isTest
    static void update_leavesOtherPhone_WhenPhoneNullAndContactAtOther() {
        Contact joe = createContact();

        joe.Phone = null;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.OtherPhone, saved.OtherPhone);
        System.assert(String.isBlank(saved.Phone));
    }

    @isTest
    static void update_leavesOtherPhone_WhenPhoneBlankAndContactAtOther() {
        Contact joe = createContact();

        joe.Phone = ' ';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(joe.OtherPhone, saved.OtherPhone);
        System.assert(String.isBlank(saved.Phone));
    }
}