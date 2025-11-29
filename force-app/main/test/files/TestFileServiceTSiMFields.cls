@isTest
public with sharing class TestFileServiceTSiMFields {


    @isTest
    public static void updateDate_TSiMApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('TSiM', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TSiMApplicationReceived__c,
            'TSiMApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_TSiMApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TSiMApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('TSiM', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TSiMApplicationReceived__c,
            'TSiMApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_TSiMApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TSiMApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('TSiM', 'Application', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TSiMApplicationReceived__c,
            'TSiMApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_TSiMProgAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('TSiM', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TSiMProgAgreementReceived__c,
            'TSiMProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_TSiMProgAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TSiMProgAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('TSiM', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TSiMProgAgreementReceived__c,
            'TSiMProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_TSiMProgAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TSiMProgAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('TSiM', 'ProgAgreement', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT TSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TSiMProgAgreementReceived__c,
            'TSiMProgAgreementReceived__c set to an older date'
        );
    }
}