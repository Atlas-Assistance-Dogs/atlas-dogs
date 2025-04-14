@isTest
public with sharing class TestClearDateServiceNaFields {

    @isTest
    public static void clearDate_NaContactForm_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Na', Type__c = 'ContactForm');
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
    public static void clearDate_NaFirstAid_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Na', Type__c = 'FirstAid');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT FirstAidReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.FirstAidReceived__c,
            'FirstAidReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_NaMedia_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Na', Type__c = 'Media');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT MediaReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.MediaReceived__c,
            'MediaReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_NaParticipationAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Na', Type__c = 'ParticipationAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT ParticipationAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.ParticipationAgreementReceived__c,
            'ParticipationAgreementReceived__c not cleared'
        );
    }
}