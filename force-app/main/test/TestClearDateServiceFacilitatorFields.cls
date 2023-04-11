@isTest
public with sharing class TestClearDateServiceFacilitatorFields {

    @isTest
    public static void clearDate_FacilitatorApplication_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Facilitator', Type__c = 'Application');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT FacilitatorApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.FacilitatorApplicationReceived__c,
            'FacilitatorApplicationReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_FacilitatorCertAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Facilitator', Type__c = 'CertAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT FacilitatorCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.FacilitatorCertAgreementReceived__c,
            'FacilitatorCertAgreementReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_FacilitatorInfrNotice_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Facilitator', Type__c = 'InfrNotice');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT FacilitatorInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.FacilitatorInfrNoticeReceived__c,
            'FacilitatorInfrNoticeReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_FacilitatorPracticum_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Facilitator', Type__c = 'Practicum');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT FacilitatorPracticumReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.FacilitatorPracticumReceived__c,
            'FacilitatorPracticumReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_FacilitatorProfGrowthPlan_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Facilitator', Type__c = 'ProfGrowthPlan');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT FacilitatorProfGrowthPlanReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.FacilitatorProfGrowthPlanReceived__c,
            'FacilitatorProfGrowthPlanReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_FacilitatorProgAgreement_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Facilitator', Type__c = 'ProgAgreement');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT FacilitatorProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.FacilitatorProgAgreementReceived__c,
            'FacilitatorProgAgreementReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_FacilitatorReference_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Facilitator', Type__c = 'Reference');
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT FacilitatorReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.FacilitatorReferenceReceived__c,
            'FacilitatorReferenceReceived__c not cleared'
        );
    }
}