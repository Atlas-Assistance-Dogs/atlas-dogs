@isTest
public with sharing class TestFileServiceDogFields {


    @isTest
    public static void updateDate_DogVacExams_SetsDateWhenNull() {
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'VacExams', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT VacExamsReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VacExamsReceived__c,
            'VacExamsReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_DogVacExams_SetsDateWhenNewer() {
        Dog__c record = new Dog__c(Name = 'Fido', VacExamsReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'VacExams', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT VacExamsReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VacExamsReceived__c,
            'VacExamsReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_DogVacExams_LeavesDateWhenOlder() {
        Dog__c record = new Dog__c(Name = 'Fido', VacExamsReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'VacExams', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT VacExamsReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VacExamsReceived__c,
            'VacExamsReceived__c set to an older date'
        );
    }
}