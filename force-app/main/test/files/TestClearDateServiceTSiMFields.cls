@isTest
public with sharing class TestClearDateServiceTSiMFields {

    @isTest
    public static void clearDate_TSiMApplication_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'TSiM', Type__c = 'Application');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT TSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.TSiMApplicationReceived__c,
            'TSiMApplicationReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_TSiMProgAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'TSiM', Type__c = 'ProgAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT TSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.TSiMProgAgreementReceived__c,
            'TSiMProgAgreementReceived__c not cleared'
        );
    }
}