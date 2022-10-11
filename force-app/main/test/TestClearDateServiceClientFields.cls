@isTest
public with sharing class TestClearDateServiceClientFields {

    @isTest
    public static void clearDate_ClientApplication_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Client', Type__c = 'Application');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT ClientApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.ClientApplicationReceived__c,
            'ClientApplicationReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_ClientCertAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Client', Type__c = 'CertAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT ClientCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.ClientCertAgreementReceived__c,
            'ClientCertAgreementReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_ClientContactForm_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Client', Type__c = 'ContactForm');
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
            null,
            record.ContactFormReceived__c,
            'ContactFormReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_ClientLOMI_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Client', Type__c = 'LOMI');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT ClientLOMIReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.ClientLOMIReceived__c,
            'ClientLOMIReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_ClientPreApplication_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Client', Type__c = 'PreApplication');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT ClientPreApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.ClientPreApplicationReceived__c,
            'ClientPreApplicationReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_ClientProgAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Client', Type__c = 'ProgAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT ClientProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.ClientProgAgreementReceived__c,
            'ClientProgAgreementReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_ClientSurvey_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Client', Type__c = 'Survey');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT ClientSurveyReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.ClientSurveyReceived__c,
            'ClientSurveyReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_ClientVAPW_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Client', Type__c = 'VAPW');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT ClientVAPWReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.ClientVAPWReceived__c,
            'ClientVAPWReceived__c not cleared'
        );
    }
}