@isTest
public with sharing class TestFileServiceDogFields {


    @isTest
    public static void updateDate_DogHealthForm_SetsDateWhenNull() {
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'HealthForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT HealthFormReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.HealthFormReceived__c,
            'HealthFormReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_DogHealthForm_SetsDateWhenNewer() {
        Dog__c record = new Dog__c(Name = 'Fido', HealthFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'HealthForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT HealthFormReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.HealthFormReceived__c,
            'HealthFormReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_DogHealthForm_LeavesDateWhenOlder() {
        Dog__c record = new Dog__c(Name = 'Fido', HealthFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'HealthForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT HealthFormReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.HealthFormReceived__c,
            'HealthFormReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_DogXray_SetsDateWhenNull() {
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'Xray', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT XrayReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.XrayReceived__c,
            'XrayReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_DogXray_SetsDateWhenNewer() {
        Dog__c record = new Dog__c(Name = 'Fido', XrayReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'Xray', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT XrayReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.XrayReceived__c,
            'XrayReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_DogXray_LeavesDateWhenOlder() {
        Dog__c record = new Dog__c(Name = 'Fido', XrayReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'Xray', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT XrayReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.XrayReceived__c,
            'XrayReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_DogVacExams_SetsDateWhenNull() {
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'VacExams', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = TestFileServiceFields.createLink('Dog', 'VacExams', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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