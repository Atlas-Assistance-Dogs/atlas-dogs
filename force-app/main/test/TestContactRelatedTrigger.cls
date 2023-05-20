
@isTest
public with sharing class TestContactRelatedTrigger {
    private static Contact joe;
    private static Contact cathy;

    private static void createContacts() {
        joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            npe01__HomeEmail__c = 'joe-blow@pump.com',
            npe01__AlternateEmail__c = 'joe-blew@pump.com',
            Phone = 'home-phone',
            HomePhone = 'home-phone',
            OtherPhone = 'other-phone',
            Contact__c = 'Guardian'
        );
        cathy = new Contact(
            Email = 'cathy-pipe@pump.com',
            FirstName = 'Cathy',
            LastName = 'Pipe',
            Phone = 'cathy-phone'
        );
        List<Contact> contacts = new List<Contact> { joe, cathy };
        insert contacts;
	    npe4__Relationship__c relationship = new npe4__Relationship__c(
            npe4__Contact__c = joe.Id,
            npe4__RelatedContact__c = cathy.Id,
            npe4__Type__c = 'Guardian',
            npe4__Status__c = 'Active'
        );
        insert relationship;
    }

    private static Contact getContact(Id id) {
        return [
            SELECT Email, FirstName, LastName, Phone
            FROM Contact
            WHERE Id = :id LIMIT 1];
    }

    private static void assertEmail(string email, Id contactId) {
        Contact saved = getContact(contactId);
        if (String.isBlank(email)) {
            System.assert(String.isBlank(saved.Email));
        }
        else {
            System.assertEquals(email, saved.Email);
        }
    }

    private static void assertPhone(string phone, Id contactId) {
        Contact saved = getContact(contactId);
        if (String.isBlank(phone)) {
            System.assert(String.isBlank(saved.Phone));
        }
        else {
            System.assertEquals(phone, saved.Phone);
        }
    }

    @isTest
    static void insert_leavesEmail_WhenContactAtGuardian() {
        Contact joe = new Contact(
            Email = 'joe@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            npe01__HomeEmail__c = 'joe-blow@pump.com',
            Contact__c = 'Guardian'
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertEmail(joe.Email, result.getId());
    }

    @isTest
    static void update_setsEmail_WhenGuardianEmailSetAndContactAtGuardian() {
        createContacts();
        cathy.Email = 'cathy-blow@bikepump.com';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(cathy, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertEmail(joe.Email, joe.Id);
    }

    @isTest
    static void update_leavesGuardianEmail_WhenEmailChangedAndContactAtGuardian() {
        createContacts();
        joe.Email = 'joe-blow@bikepump.com';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertEmail(joe.Email, result.getId());
        assertEmail(cathy.Email, cathy.Id);
    }

    @isTest
    static void update_leavesEmail_WhenGuardianEmailClearedAndContactAtGuardian() {
        createContacts();
        cathy.Email = '';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(cathy, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertEmail(joe.Email, joe.Id);
        assertEmail(cathy.Email, cathy.Id);
    }

    @isTest
    static void update_leavesEmail_WhenGuardianEmailNullAndContactAtGuardian() {
        createContacts();
        cathy.Email = null;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(cathy, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertEmail(joe.Email, joe.Id);
        assertEmail(cathy.Email, cathy.Id);
    }

    @isTest
    static void update_leavesGuardianEmail_WhenEmailNullAndContactAtGuardian() {
        createContacts();

        joe.Email = null;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertEmail(joe.Email, result.getId());
        assertEmail(cathy.Email, cathy.Id);
    }

    @isTest
    static void update_leavesGuardianEmail_WhenEmailBlankAndContactAtGuardian() {
        createContacts();
        joe.Email = ' ';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertEmail(joe.Email, result.getId());
        assertEmail(cathy.Email, cathy.Id);
    }

    @isTest
    static void update_setsPhone_WhenGuardianPhoneSetAndContactAtGuardian() {
        createContacts();
        cathy.Phone = 'vacation-phone';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(cathy, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertPhone(cathy.Phone, joe.Id);
        assertPhone(cathy.Phone, cathy.Id);
    }

    @isTest
    static void update_leavesGuardianPhone_WhenPhoneChangedAndContactAtGuardian() {
        createContacts();
        joe.Phone = 'vacation-phone';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertPhone(joe.Phone, result.getId());
        assertPhone(cathy.Phone, cathy.Id);
    }

    @isTest
    static void update_leavesPhone_WhenGuardianPhoneClearedAndContactAtGuardian() {
        createContacts();
        cathy.Phone = '';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(cathy, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertPhone(joe.Phone, joe.Id);
        assertPhone(cathy.Phone, cathy.Id);
    }

    @isTest
    static void update_leavesPhone_WhenGuardianPhoneNullAndContactAtGuardian() {
        createContacts();
        cathy.Phone = null;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(cathy, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = getContact(result.getId());
        System.assert(result.getErrors().size() == 0);
        assertPhone(joe.Phone, joe.Id);
        assertPhone(cathy.Phone, cathy.Id);
    }

    @isTest
    static void update_leavesGuardianPhone_WhenPhoneNullAndContactAtGuardian() {
        createContacts();
        joe.Phone = null;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertPhone(joe.Phone, joe.Id);
        assertPhone(cathy.Phone, cathy.Id);
    }

    @isTest
    static void update_leavesGuardianPhone_WhenPhoneBlankAndContactAtGuardian() {
        createContacts();
        joe.Phone = ' ';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(joe, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        assertPhone(joe.Phone, joe.Id);
        assertPhone(cathy.Phone, cathy.Id);
    }
}