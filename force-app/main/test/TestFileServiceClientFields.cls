@isTest
public with sharing class TestFileServiceClientFields {


    @isTest
    public static void updateDate_ClientApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientApplicationReceived__c,
            'ClientApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientApplicationReceived__c,
            'ClientApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Application', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientApplicationReceived__c,
            'ClientApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ClientCertAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientCertAgreementReceived__c,
            'ClientCertAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientCertAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientCertAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientCertAgreementReceived__c,
            'ClientCertAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientCertAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientCertAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'CertAgreement', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientCertAgreementReceived__c,
            'ClientCertAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ClientContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ContactForm', Date.today(), record.Id);
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
    public static void updateDate_ClientContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ContactForm', Date.today(), record.Id);
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
    public static void updateDate_ClientContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ContactForm', Date.today().addDays(-1), record.Id);
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
    public static void updateDate_ClientLOMI_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'LOMI', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientLOMIReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientLOMIReceived__c,
            'ClientLOMIReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientLOMI_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientLOMIReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'LOMI', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientLOMIReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientLOMIReceived__c,
            'ClientLOMIReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientLOMI_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientLOMIReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'LOMI', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientLOMIReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientLOMIReceived__c,
            'ClientLOMIReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ClientPreApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientPreApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientPreApplicationReceived__c,
            'ClientPreApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientPreApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientPreApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientPreApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientPreApplicationReceived__c,
            'ClientPreApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientPreApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientPreApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'PreApplication', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientPreApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientPreApplicationReceived__c,
            'ClientPreApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ClientProgAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientProgAgreementReceived__c,
            'ClientProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientProgAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientProgAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientProgAgreementReceived__c,
            'ClientProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientProgAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientProgAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ProgAgreement', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientProgAgreementReceived__c,
            'ClientProgAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ClientSurvey_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Survey', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientSurveyReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientSurveyReceived__c,
            'ClientSurveyReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientSurvey_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientSurveyReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Survey', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientSurveyReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientSurveyReceived__c,
            'ClientSurveyReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientSurvey_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientSurveyReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Survey', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientSurveyReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientSurveyReceived__c,
            'ClientSurveyReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ClientVAPW_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'VAPW', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientVAPWReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientVAPWReceived__c,
            'ClientVAPWReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientVAPW_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientVAPWReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'VAPW', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientVAPWReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientVAPWReceived__c,
            'ClientVAPWReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientVAPW_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientVAPWReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'VAPW', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientVAPWReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientVAPWReceived__c,
            'ClientVAPWReceived__c set to an older date'
        );
    }
}