@isTest
public with sharing class TestFileServiceClientFields {

    private static Dog__c dog;
    private static Contact client;

    private static void createTeamMembers() {
        dog = new Dog__c(Name = 'Fido');
        insert dog;

        client = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert client;
    }

    @isTest
    public static void updateDate_ClientApplication_SetsDateWhenNull() {
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id);
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientApplicationReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientApplicationReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Application', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientApplicationReceived__c
            FROM Team__c
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
    public static void updateDate_ClientApplicationVideo_SetsDateWhenNull() {
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id);
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ApplicationVideo', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientApplicationVideoReceived__c
            FROM Team__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientApplicationVideoReceived__c,
            'ClientApplicationVideoReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientApplicationVideo_SetsDateWhenNewer() {
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientApplicationVideoReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ApplicationVideo', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientApplicationVideoReceived__c
            FROM Team__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientApplicationVideoReceived__c,
            'ClientApplicationVideoReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientApplicationVideo_LeavesDateWhenOlder() {
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientApplicationVideoReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ApplicationVideo', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientApplicationVideoReceived__c
            FROM Team__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientApplicationVideoReceived__c,
            'ClientApplicationVideoReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ClientCGCForm_SetsDateWhenNull() {
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id);
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'CGCForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientCGCFormReceived__c
            FROM Team__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientCGCFormReceived__c,
            'ClientCGCFormReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientCGCForm_SetsDateWhenNewer() {
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientCGCFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'CGCForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientCGCFormReceived__c
            FROM Team__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientCGCFormReceived__c,
            'ClientCGCFormReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ClientCGCForm_LeavesDateWhenOlder() {
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientCGCFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'CGCForm', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientCGCFormReceived__c
            FROM Team__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientCGCFormReceived__c,
            'ClientCGCFormReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ClientCertAgreement_SetsDateWhenNull() {
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id);
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientCertAgreementReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientCertAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientCertAgreementReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientCertAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'CertAgreement', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientCertAgreementReceived__c
            FROM Team__c
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
    public static void updateDate_ClientLOMI_SetsDateWhenNull() {
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id);
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'LOMI', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientLOMIReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientLOMIReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'LOMI', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientLOMIReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientLOMIReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'LOMI', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientLOMIReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id);
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientPreApplicationReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientPreApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientPreApplicationReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientPreApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'PreApplication', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientPreApplicationReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id);
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientProgAgreementReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientProgAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientProgAgreementReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientProgAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'ProgAgreement', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientProgAgreementReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id);
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Survey', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientSurveyReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientSurveyReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Survey', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientSurveyReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientSurveyReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'Survey', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientSurveyReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id);
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'VAPW', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientVAPWReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientVAPWReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'VAPW', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientVAPWReceived__c
            FROM Team__c
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
        createTeamMembers();
        Team__c record = new Team__c(Name = 'Test', Client__c = client.Id, Dog__c = dog.Id, ClientVAPWReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Client', 'VAPW', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT ClientVAPWReceived__c
            FROM Team__c
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