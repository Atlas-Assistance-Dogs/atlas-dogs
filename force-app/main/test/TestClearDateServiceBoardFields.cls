@isTest
public with sharing class TestClearDateServiceBoardFields {

    @isTest
    public static void clearDate_BoardAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Board', Type__c = 'Agreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT BoardAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardAgreementReceived__c,
            'BoardAgreementReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_BoardApplication_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Board', Type__c = 'Application');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT BoardApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardApplicationReceived__c,
            'BoardApplicationReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_BoardCoI_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Board', Type__c = 'CoI');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT BoardCoIReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardCoIReceived__c,
            'BoardCoIReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_BoardContactForm_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Board', Type__c = 'ContactForm');
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
    public static void clearDate_BoardResume_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Board', Type__c = 'Resume');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT BoardResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardResumeReceived__c,
            'BoardResumeReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_BoardToN_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Board', Type__c = 'ToN');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT BoardToNReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardToNReceived__c,
            'BoardToNReceived__c not set'
        );
    }
}