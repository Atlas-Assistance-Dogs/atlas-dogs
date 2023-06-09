@isTest
public with sharing class TestClearDateServiceStaffFields {

    @isTest
    public static void clearDate_StaffAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Staff', Type__c = 'Agreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT StaffAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.StaffAgreementReceived__c,
            'StaffAgreementReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_StaffApplication_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Staff', Type__c = 'Application');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT StaffApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.StaffApplicationReceived__c,
            'StaffApplicationReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_StaffI9_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Staff', Type__c = 'I9');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT StaffI9Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.StaffI9Received__c,
            'StaffI9Received__c not cleared'
        );
    }

    @isTest
    public static void clearDate_StaffOffer_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Staff', Type__c = 'Offer');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT StaffOfferReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.StaffOfferReceived__c,
            'StaffOfferReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_StaffResume_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Staff', Type__c = 'Resume');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT StaffResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.StaffResumeReceived__c,
            'StaffResumeReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_StaffW4_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Staff', Type__c = 'W4');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT StaffW4Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.StaffW4Received__c,
            'StaffW4Received__c not cleared'
        );
    }

    @isTest
    public static void clearDate_StaffW9_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Staff', Type__c = 'W9');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT StaffW9Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.StaffW9Received__c,
            'StaffW9Received__c not cleared'
        );
    }
}