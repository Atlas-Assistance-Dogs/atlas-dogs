@isTest
public with sharing class TestClearDateServicePuppyFields {

    @isTest
    public static void clearDate_PuppyApplication_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Puppy', Type__c = 'Application');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT PuppyApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyApplicationReceived__c,
            'PuppyApplicationReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_PuppyCertAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Puppy', Type__c = 'CertAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT PuppyCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyCertAgreementReceived__c,
            'PuppyCertAgreementReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_PuppyContactForm_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Puppy', Type__c = 'ContactForm');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

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
    public static void clearDate_PuppyContract_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Puppy', Type__c = 'Contract');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT PuppyContractReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyContractReceived__c,
            'PuppyContractReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_PuppyInfrNotice_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Puppy', Type__c = 'InfrNotice');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT PuppyInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyInfrNoticeReceived__c,
            'PuppyInfrNoticeReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_PuppyProgAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Puppy', Type__c = 'ProgAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT PuppyProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyProgAgreementReceived__c,
            'PuppyProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_PuppyReference_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Puppy', Type__c = 'Reference');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT PuppyReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyReferenceReceived__c,
            'PuppyReferenceReceived__c not set'
        );
    }
}