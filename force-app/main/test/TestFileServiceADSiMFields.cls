@isTest
public with sharing class TestFileServiceADSiMFields {


    @isTest
    public static void updateDate_ADSiMApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMApplicationReceived__c,
            'ADSiMApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMApplicationReceived__c,
            'ADSiMApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ADSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMApplicationReceived__c,
            'ADSiMApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ADSiMContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_ADSiMContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_ADSiMContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_ADSiMPreApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMPreApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMPreApplicationReceived__c,
            'ADSiMPreApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMPreApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMPreApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMPreApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMPreApplicationReceived__c,
            'ADSiMPreApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMPreApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMPreApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ADSiMPreApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMPreApplicationReceived__c,
            'ADSiMPreApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ADSiMProgAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMProgAgreementReceived__c,
            'ADSiMProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMProgAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMProgAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMProgAgreementReceived__c,
            'ADSiMProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMProgAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMProgAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('ADSiM', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ADSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMProgAgreementReceived__c,
            'ADSiMProgAgreementReceived__c set to an older date'
        );
    }
}