@isTest
public with sharing class TestClearDateServiceTrainerFields {

    @isTest
    public static void clearDate_TrainerApplication_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Trainer', Type__c = 'Application');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT TrainerApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerApplicationReceived__c,
            'TrainerApplicationReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_TrainerCertAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Trainer', Type__c = 'CertAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT TrainerCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerCertAgreementReceived__c,
            'TrainerCertAgreementReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_TrainerContactForm_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Trainer', Type__c = 'ContactForm');
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
    public static void clearDate_TrainerInfrNotice_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Trainer', Type__c = 'InfrNotice');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT TrainerInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerInfrNoticeReceived__c,
            'TrainerInfrNoticeReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_TrainerProgAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Trainer', Type__c = 'ProgAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT TrainerProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerProgAgreementReceived__c,
            'TrainerProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void clearDate_TrainerReference_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Trainer', Type__c = 'Reference');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT TrainerReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerReferenceReceived__c,
            'TrainerReferenceReceived__c not set'
        );
    }
}