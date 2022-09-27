@isTest
public with sharing class TestFileServiceFacilitatorFields {


    @isTest
    public static void updateDate_FacilitatorApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorApplicationReceived__c,
            'FacilitatorApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorApplicationReceived__c,
            'FacilitatorApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'Application', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorApplicationReceived__c,
            'FacilitatorApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_FacilitatorCertAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorCertAgreementReceived__c,
            'FacilitatorCertAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorCertAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorCertAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorCertAgreementReceived__c,
            'FacilitatorCertAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorCertAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorCertAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'CertAgreement', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorCertAgreementReceived__c,
            'FacilitatorCertAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_FacilitatorContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'ContactForm', Date.today(), record.Id);
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
    public static void updateDate_FacilitatorContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'ContactForm', Date.today(), record.Id);
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
    public static void updateDate_FacilitatorContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'ContactForm', Date.today().addDays(-1), record.Id);
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
    public static void updateDate_FacilitatorInfrNotice_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorInfrNoticeReceived__c,
            'FacilitatorInfrNoticeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorInfrNotice_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorInfrNoticeReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorInfrNoticeReceived__c,
            'FacilitatorInfrNoticeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorInfrNotice_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorInfrNoticeReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'InfrNotice', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorInfrNoticeReceived__c,
            'FacilitatorInfrNoticeReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_FacilitatorPracticum_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'Practicum', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorPracticumReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorPracticumReceived__c,
            'FacilitatorPracticumReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorPracticum_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorPracticumReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'Practicum', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorPracticumReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorPracticumReceived__c,
            'FacilitatorPracticumReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorPracticum_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorPracticumReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'Practicum', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorPracticumReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorPracticumReceived__c,
            'FacilitatorPracticumReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_FacilitatorProfGrowthPlan_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'ProfGrowthPlan', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorProfGrowthPlanReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorProfGrowthPlanReceived__c,
            'FacilitatorProfGrowthPlanReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorProfGrowthPlan_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorProfGrowthPlanReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'ProfGrowthPlan', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorProfGrowthPlanReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorProfGrowthPlanReceived__c,
            'FacilitatorProfGrowthPlanReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorProfGrowthPlan_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorProfGrowthPlanReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'ProfGrowthPlan', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorProfGrowthPlanReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorProfGrowthPlanReceived__c,
            'FacilitatorProfGrowthPlanReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_FacilitatorProgAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorProgAgreementReceived__c,
            'FacilitatorProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorProgAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorProgAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorProgAgreementReceived__c,
            'FacilitatorProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorProgAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorProgAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'ProgAgreement', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorProgAgreementReceived__c,
            'FacilitatorProgAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_FacilitatorReference_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorReferenceReceived__c,
            'FacilitatorReferenceReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorReference_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorReferenceReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorReferenceReceived__c,
            'FacilitatorReferenceReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorReference_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', FacilitatorReferenceReceived__c = Date.today());
        insert record;
        ContentVersion cv = TestFileServiceFields.createLink('Facilitator', 'Reference', Date.today().addDays(-1), record.Id);
        FileService.updateDate(cv, record.Id);

        record = [
            SELECT FacilitatorReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.FacilitatorReferenceReceived__c,
            'FacilitatorReferenceReceived__c set to an older date'
        );
    }
}