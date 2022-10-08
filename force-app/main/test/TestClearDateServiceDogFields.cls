@isTest
public with sharing class TestClearDateServiceDogFields {

    @isTest
    public static void clearDate_DogHealthForm_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Dog', Type__c = 'HealthForm');
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT HealthFormReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.HealthFormReceived__c,
            'HealthFormReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_DogVacExams_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Dog', Type__c = 'VacExams');
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT VacExamsReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.VacExamsReceived__c,
            'VacExamsReceived__c not cleared'
        );
    }

    @isTest
    public static void clearDate_DogXray_SetsDateToNull() {
        ContentVersion cv = new ContentVersion(Category__c = 'Dog', Type__c = 'Xray');
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        ClearDateService.clear(cv, record.Id);

        record = [
            SELECT XrayReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            null,
            record.XrayReceived__c,
            'XrayReceived__c not cleared'
        );
    }
}