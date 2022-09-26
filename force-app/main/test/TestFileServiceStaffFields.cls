@isTest
public with sharing class TestFileServiceStaffFields {


    @isTest
    public static void updateDate_StaffAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffAgreementReceived__c,
            'StaffAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffAgreementReceived__c,
            'StaffAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Agreement', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffAgreementReceived__c,
            'StaffAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffApplicationReceived__c,
            'StaffApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffApplicationReceived__c,
            'StaffApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Application', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffApplicationReceived__c,
            'StaffApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ContactFormReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ContactFormReceived__c,
            'ContactFormReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ContactFormReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ContactFormReceived__c,
            'ContactFormReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'ContactForm', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ContactFormReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ContactFormReceived__c,
            'ContactFormReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffI9_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'I9', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffI9Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffI9Received__c,
            'StaffI9Received__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffI9_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffI9Received__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'I9', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffI9Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffI9Received__c,
            'StaffI9Received__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffI9_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffI9Received__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'I9', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffI9Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffI9Received__c,
            'StaffI9Received__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffOffer_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Offer', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffOfferReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffOfferReceived__c,
            'StaffOfferReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffOffer_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffOfferReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Offer', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffOfferReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffOfferReceived__c,
            'StaffOfferReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffOffer_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffOfferReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Offer', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffOfferReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffOfferReceived__c,
            'StaffOfferReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffResume_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffResumeReceived__c,
            'StaffResumeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffResume_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffResumeReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffResumeReceived__c,
            'StaffResumeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffResume_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffResumeReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'Resume', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffResumeReceived__c,
            'StaffResumeReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffW4_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'W4', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffW4Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffW4Received__c,
            'StaffW4Received__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffW4_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffW4Received__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'W4', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffW4Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffW4Received__c,
            'StaffW4Received__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffW4_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffW4Received__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Staff', 'W4', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT StaffW4Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffW4Received__c,
            'StaffW4Received__c set to an older date'
        );
    }
}