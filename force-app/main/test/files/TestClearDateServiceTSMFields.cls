@isTest
public with sharing class TestClearDateServiceTSMFields {

    @isTest
    public static void clearDate_TSMApplication_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'TSM', Type__c = 'Application');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT TSMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.TSMApplicationReceived__c,
            'TSMApplicationReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_TSMProgAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'TSM', Type__c = 'ProgAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT TSMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.TSMProgAgreementReceived__c,
            'TSMProgAgreementReceived__c not cleared'
        );
    }
}