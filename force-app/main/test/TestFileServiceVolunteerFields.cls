@isTest
public with sharing class TestFileServiceVolunteerFields {


    @isTest
    public static void updateDate_VolunteerApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerApplicationReceived__c,
            'VolunteerApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerApplicationReceived__c,
            'VolunteerApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT VolunteerApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerApplicationReceived__c,
            'VolunteerApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_VolunteerContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'ContactForm', Date.today(), record.Id);
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
    public static void updateDate_VolunteerContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'ContactForm', Date.today(), record.Id);
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
    public static void updateDate_VolunteerContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'ContactForm', Date.today(), record.Id);
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
    public static void updateDate_VolunteerAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerAgreementReceived__c,
            'VolunteerAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerAgreementReceived__c,
            'VolunteerAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT VolunteerAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerAgreementReceived__c,
            'VolunteerAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_VolunteerResume_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerResumeReceived__c,
            'VolunteerResumeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerResume_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerResumeReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerResumeReceived__c,
            'VolunteerResumeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerResume_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerResumeReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Volunteer', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT VolunteerResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerResumeReceived__c,
            'VolunteerResumeReceived__c set to an older date'
        );
    }
}