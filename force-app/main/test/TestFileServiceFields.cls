@isTest
public with sharing class TestFileServiceFields {
    private static ContentVersion createLink(
        string category,
        string type,
        Date docDate,
        Id recordId
    ) {
        ContentVersion cv = new ContentVersion(
            Title = 'Test Category Type',
            PathOnClient = 'TestDocument3.jpg',
            Origin = 'H',
            VersionData = Blob.valueOf('Document Body 3'),
            Category__c = category,
            Type__c = type,
            Date__c = docDate
        );
        insert cv;

        ContentVersion temp = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :cv.Id
            LIMIT 1
        ];

        ContentDocumentLink link = new ContentDocumentLink(
            ContentDocumentId = temp.ContentDocumentId,
            LinkedEntityId = recordId
        );
        insert link;

        return cv;
    }


    @isTest
    public static void updateDate_DogHealthForm_SetsDateWhenNull() {
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        ContentVersion cv = createLink('Dog', 'HealthForm', Date.today(), record.Id);
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
        ContentVersion cv = createLink('Dog', 'HealthForm', Date.today(), record.Id);
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
        ContentVersion cv = createLink('Dog', 'HealthForm', Date.today(), record.Id);
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
    public static void updateDate_DogVacExams_SetsDateWhenNull() {
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        ContentVersion cv = createLink('Dog', 'VacExams', Date.today(), record.Id);
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
        ContentVersion cv = createLink('Dog', 'VacExams', Date.today(), record.Id);
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
        ContentVersion cv = createLink('Dog', 'VacExams', Date.today(), record.Id);
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

    @isTest
    public static void updateDate_DogXray_SetsDateWhenNull() {
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        ContentVersion cv = createLink('Dog', 'Xray', Date.today(), record.Id);
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
        ContentVersion cv = createLink('Dog', 'Xray', Date.today(), record.Id);
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
        ContentVersion cv = createLink('Dog', 'Xray', Date.today(), record.Id);
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
    public static void updateDate_ADSiMApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('ADSiM', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMApplicationReceived__c,
            'ADSiMApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('ADSiM', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMApplicationReceived__c,
            'ADSiMApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('ADSiM', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ADSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMApplicationReceived__c,
            'ADSiMApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ADSiMPreApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('ADSiM', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMPreApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMPreApplicationReceived__c,
            'ADSiMPreApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMPreApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMPreApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('ADSiM', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMPreApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMPreApplicationReceived__c,
            'ADSiMPreApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMPreApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMPreApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('ADSiM', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ADSiMPreApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMPreApplicationReceived__c,
            'ADSiMPreApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ADSiMProgAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('ADSiM', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMProgAgreementReceived__c,
            'ADSiMProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMProgAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMProgAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('ADSiM', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ADSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMProgAgreementReceived__c,
            'ADSiMProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMProgAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ADSiMProgAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('ADSiM', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ADSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ADSiMProgAgreementReceived__c,
            'ADSiMProgAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ADSiMContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('ADSiM', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_ADSiMContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('ADSiM', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_ADSiMContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('ADSiM', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_BoardAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Board', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT BoardAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardAgreementReceived__c,
            'BoardAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_BoardAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', BoardAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Board', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT BoardAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardAgreementReceived__c,
            'BoardAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_BoardAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', BoardAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Board', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT BoardAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardAgreementReceived__c,
            'BoardAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_BoardApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Board', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT BoardApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardApplicationReceived__c,
            'BoardApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_BoardApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', BoardApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Board', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT BoardApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardApplicationReceived__c,
            'BoardApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_BoardApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', BoardApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Board', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT BoardApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardApplicationReceived__c,
            'BoardApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_BoardCoI_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Board', 'CoI', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT BoardCoIReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardCoIReceived__c,
            'BoardCoIReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_BoardCoI_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', BoardCoIReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Board', 'CoI', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT BoardCoIReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardCoIReceived__c,
            'BoardCoIReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_BoardCoI_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', BoardCoIReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Board', 'CoI', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT BoardCoIReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardCoIReceived__c,
            'BoardCoIReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_BoardResume_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Board', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT BoardResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardResumeReceived__c,
            'BoardResumeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_BoardResume_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', BoardResumeReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Board', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT BoardResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardResumeReceived__c,
            'BoardResumeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_BoardResume_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', BoardResumeReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Board', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT BoardResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardResumeReceived__c,
            'BoardResumeReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_BoardToN_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Board', 'ToN', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT BoardToNReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardToNReceived__c,
            'BoardToNReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_BoardToN_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', BoardToNReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Board', 'ToN', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT BoardToNReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardToNReceived__c,
            'BoardToNReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_BoardToN_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', BoardToNReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Board', 'ToN', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT BoardToNReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardToNReceived__c,
            'BoardToNReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_BoardContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Board', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_BoardContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Board', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_BoardContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Board', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_ClientApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Client', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientApplicationReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Client', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientApplicationReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Client', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ClientApplicationReceived__c
            FROM Contact
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
    public static void updateDate_ClientCertAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Client', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientCertAgreementReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientCertAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Client', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientCertAgreementReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientCertAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Client', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ClientCertAgreementReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Client', 'LOMI', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientLOMIReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientLOMIReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Client', 'LOMI', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientLOMIReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientLOMIReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Client', 'LOMI', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ClientLOMIReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Client', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientPreApplicationReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientPreApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Client', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientPreApplicationReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientPreApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Client', 'PreApplication', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ClientPreApplicationReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Client', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientProgAgreementReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientProgAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Client', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientProgAgreementReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientProgAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Client', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ClientProgAgreementReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Client', 'Survey', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientSurveyReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientSurveyReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Client', 'Survey', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientSurveyReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientSurveyReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Client', 'Survey', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ClientSurveyReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Client', 'VAPW', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientVAPWReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientVAPWReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Client', 'VAPW', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT ClientVAPWReceived__c
            FROM Contact
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
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ClientVAPWReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Client', 'VAPW', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT ClientVAPWReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.ClientVAPWReceived__c,
            'ClientVAPWReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_ClientContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Client', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_ClientContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Client', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_ClientContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Client', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_FacilitatorApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Facilitator', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
        ContentVersion cv = createLink('Facilitator', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_FacilitatorInfrNotice_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Facilitator', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
        ContentVersion cv = createLink('Facilitator', 'Practicum', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'Practicum', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'Practicum', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
        ContentVersion cv = createLink('Facilitator', 'ProfGrowthPlan', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'ProfGrowthPlan', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'ProfGrowthPlan', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
        ContentVersion cv = createLink('Facilitator', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
        ContentVersion cv = createLink('Facilitator', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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

    @isTest
    public static void updateDate_FacilitatorContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Facilitator', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Facilitator', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_PuppyApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Puppy', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT PuppyApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyApplicationReceived__c,
            'PuppyApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_PuppyApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', PuppyApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Puppy', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT PuppyApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyApplicationReceived__c,
            'PuppyApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_PuppyApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', PuppyApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Puppy', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT PuppyApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyApplicationReceived__c,
            'PuppyApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_PuppyCertAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Puppy', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT PuppyCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyCertAgreementReceived__c,
            'PuppyCertAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_PuppyCertAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', PuppyCertAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Puppy', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT PuppyCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyCertAgreementReceived__c,
            'PuppyCertAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_PuppyCertAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', PuppyCertAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Puppy', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT PuppyCertAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyCertAgreementReceived__c,
            'PuppyCertAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_PuppyInfrNotice_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Puppy', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT PuppyInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyInfrNoticeReceived__c,
            'PuppyInfrNoticeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_PuppyInfrNotice_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', PuppyInfrNoticeReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Puppy', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT PuppyInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyInfrNoticeReceived__c,
            'PuppyInfrNoticeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_PuppyInfrNotice_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', PuppyInfrNoticeReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Puppy', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT PuppyInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyInfrNoticeReceived__c,
            'PuppyInfrNoticeReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_PuppyProgAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Puppy', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT PuppyProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyProgAgreementReceived__c,
            'PuppyProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_PuppyProgAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', PuppyProgAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Puppy', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT PuppyProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyProgAgreementReceived__c,
            'PuppyProgAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_PuppyProgAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', PuppyProgAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Puppy', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT PuppyProgAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyProgAgreementReceived__c,
            'PuppyProgAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_PuppyReference_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Puppy', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT PuppyReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyReferenceReceived__c,
            'PuppyReferenceReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_PuppyReference_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', PuppyReferenceReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Puppy', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT PuppyReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyReferenceReceived__c,
            'PuppyReferenceReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_PuppyReference_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', PuppyReferenceReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Puppy', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT PuppyReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.PuppyReferenceReceived__c,
            'PuppyReferenceReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_PuppyContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Puppy', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_PuppyContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Puppy', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_PuppyContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Puppy', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_StaffAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Staff', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffAgreementReceived__c,
            'StaffAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Staff', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffAgreementReceived__c,
            'StaffAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Staff', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT StaffAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffAgreementReceived__c,
            'StaffAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Staff', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffApplicationReceived__c,
            'StaffApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Staff', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffApplicationReceived__c,
            'StaffApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Staff', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT StaffApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffApplicationReceived__c,
            'StaffApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffI9_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Staff', 'I9', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffI9Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffI9Received__c,
            'StaffI9Received__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffI9_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffI9Received__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Staff', 'I9', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffI9Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffI9Received__c,
            'StaffI9Received__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffI9_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffI9Received__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Staff', 'I9', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT StaffI9Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffI9Received__c,
            'StaffI9Received__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffOffer_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Staff', 'Offer', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffOfferReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffOfferReceived__c,
            'StaffOfferReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffOffer_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffOfferReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Staff', 'Offer', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffOfferReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffOfferReceived__c,
            'StaffOfferReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffOffer_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffOfferReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Staff', 'Offer', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT StaffOfferReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffOfferReceived__c,
            'StaffOfferReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffResume_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Staff', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffResumeReceived__c,
            'StaffResumeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffResume_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffResumeReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Staff', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffResumeReceived__c,
            'StaffResumeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffResume_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffResumeReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Staff', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT StaffResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffResumeReceived__c,
            'StaffResumeReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffW4_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Staff', 'W4', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffW4Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffW4Received__c,
            'StaffW4Received__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffW4_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffW4Received__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Staff', 'W4', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT StaffW4Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffW4Received__c,
            'StaffW4Received__c not set'
        );
    }

    @isTest
    public static void updateDate_StaffW4_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', StaffW4Received__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Staff', 'W4', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT StaffW4Received__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.StaffW4Received__c,
            'StaffW4Received__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_StaffContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Staff', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_StaffContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Staff', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_StaffContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Staff', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_StandaloneApplication_Ignores() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Standalone', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());
    }

    @isTest
    public static void updateDate_TrainerApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Trainer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Trainer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Trainer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
        ContentVersion cv = createLink('Trainer', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Trainer', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Trainer', 'CertAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_TrainerInfrNotice_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Trainer', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Trainer', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Trainer', 'InfrNotice', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_TrainerProgAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Trainer', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Trainer', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
        ContentVersion cv = createLink('Trainer', 'ProgAgreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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

    @isTest
    public static void updateDate_TrainerReference_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Trainer', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT TrainerReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerReferenceReceived__c,
            'TrainerReferenceReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_TrainerReference_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerReferenceReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Trainer', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT TrainerReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerReferenceReceived__c,
            'TrainerReferenceReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_TrainerReference_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', TrainerReferenceReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Trainer', 'Reference', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT TrainerReferenceReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.TrainerReferenceReceived__c,
            'TrainerReferenceReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_TrainerContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Trainer', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_TrainerContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Trainer', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_TrainerContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Trainer', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
    public static void updateDate_VolunteerAgreement_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Volunteer', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerAgreementReceived__c,
            'VolunteerAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerAgreement_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerAgreementReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Volunteer', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerAgreementReceived__c,
            'VolunteerAgreementReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerAgreement_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerAgreementReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Volunteer', 'Agreement', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT VolunteerAgreementReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerAgreementReceived__c,
            'VolunteerAgreementReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_VolunteerApplication_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Volunteer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerApplicationReceived__c,
            'VolunteerApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerApplication_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerApplicationReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Volunteer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerApplicationReceived__c,
            'VolunteerApplicationReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerApplication_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerApplicationReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Volunteer', 'Application', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT VolunteerApplicationReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerApplicationReceived__c,
            'VolunteerApplicationReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_VolunteerResume_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Volunteer', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerResumeReceived__c,
            'VolunteerResumeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerResume_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerResumeReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Volunteer', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

        record = [
            SELECT VolunteerResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerResumeReceived__c,
            'VolunteerResumeReceived__c not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerResume_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', VolunteerResumeReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Volunteer', 'Resume', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

        record = [
            SELECT VolunteerResumeReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.VolunteerResumeReceived__c,
            'VolunteerResumeReceived__c set to an older date'
        );
    }

    @isTest
    public static void updateDate_VolunteerContactForm_SetsDateWhenNull() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com');
        insert record;
        ContentVersion cv = createLink('Volunteer', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_VolunteerContactForm_SetsDateWhenNewer() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today().addDays(-1));
        insert record;
        ContentVersion cv = createLink('Volunteer', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today());

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
    public static void updateDate_VolunteerContactForm_LeavesDateWhenOlder() {
        Contact record = new Contact(FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com', ContactFormReceived__c = Date.today());
        insert record;
        ContentVersion cv = createLink('Volunteer', 'ContactForm', Date.today(), record.Id);
        FileService.updateDate(cv, record.Id, Date.today().addDays(-1));

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
}