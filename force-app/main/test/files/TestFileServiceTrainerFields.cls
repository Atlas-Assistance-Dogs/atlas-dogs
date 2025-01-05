@isTest
public with sharing class TestFileServiceTrainerFields {


    @isTest
    public static void updateDate_TrainerApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

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
    public static void updateDate_TrainerApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

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
    public static void updateDate_TrainerApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'Application', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TrainerApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerApplicationReceived__c,
            'TrainerApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_TrainerCertAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

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
    public static void updateDate_TrainerCertAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerCertAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

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
    public static void updateDate_TrainerCertAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerCertAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'CertAgreement', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TrainerCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerCertAgreementReceived__c,
            'TrainerCertAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_TrainerClientReference_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'ClientReference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TrainerClientReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerClientReferenceReceived__c,
            'TrainerClientReferenceReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_TrainerClientReference_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerClientReferenceReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'ClientReference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TrainerClientReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerClientReferenceReceived__c,
            'TrainerClientReferenceReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_TrainerClientReference_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerClientReferenceReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'ClientReference', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TrainerClientReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerClientReferenceReceived__c,
            'TrainerClientReferenceReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_TrainerInfrNotice_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

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
    public static void updateDate_TrainerInfrNotice_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerInfrNoticeReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

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
    public static void updateDate_TrainerInfrNotice_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerInfrNoticeReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'InfrNotice', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TrainerInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerInfrNoticeReceived__c,
            'TrainerInfrNoticeReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_TrainerProfReference_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'ProfReference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TrainerProfReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerProfReferenceReceived__c,
            'TrainerProfReferenceReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_TrainerProfReference_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerProfReferenceReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'ProfReference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TrainerProfReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerProfReferenceReceived__c,
            'TrainerProfReferenceReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_TrainerProfReference_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerProfReferenceReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'ProfReference', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TrainerProfReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerProfReferenceReceived__c,
            'TrainerProfReferenceReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_TrainerProgAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

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
    public static void updateDate_TrainerProgAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerProgAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

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
    public static void updateDate_TrainerProgAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerProgAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Trainer', 'ProgAgreement', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TrainerProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerProgAgreementReceived__c,
            'TrainerProgAgreementReceived__c set to an older date'
        );
    }
}