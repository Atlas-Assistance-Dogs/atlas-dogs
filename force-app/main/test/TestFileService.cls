@isTest
public with sharing class TestFileService {
    private static ContentVersion createLink(
        string category,
        string type,
        Id recordId
    ) {
        ContentVersion cv = new ContentVersion(
            Title = 'Test Category Type',
            PathOnClient = 'TestDocument3.jpg',
            Origin = 'H',
            VersionData = Blob.valueOf('Document Body 3'),
            Category__c = category,
            Type__c = type
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
    public static void updateDate_Ignores_WhenNoCatType() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com'
        );
        insert contact;

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = contact.Id,
            Date__c = Date.today(),
            Status__c = 'Pass'
        );
        insert bgCheck;

        ContentVersion cv = createLink(null, null, bgCheck.Id);

        FileService.updateDate(cv, bgCheck.Id, Date.today());
        // no assert here.  Test passes if no exception
    }

    @isTest
    public static void updateDate_FindsLinkedDog() {
        Dog__c dog = new Dog__c(Name = 'Fido', HealthFormReceived__c = null);
        insert dog;
        ContentVersion cv = createLink('Dog', 'HealthForm', dog.Id);

        // Act
        FileService.updateDate(cv, Date.today());

        // Assert
        dog = [
            SELECT HealthFormReceived__c
            FROM Dog__c
            WHERE Id = :dog.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            dog.HealthFormReceived__c,
            'HealthFormReceived not set'
        );
    }

    @isTest
    public static void updateDate_FindsLinkedContact() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Client', 'Application', contact.Id);

        // Act
        FileService.updateDate(cv, Date.today());

        // Assert
        contact = [
            SELECT ClientApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ClientApplicationReceived__c,
            'ClientApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_DogHealthForm_SetsDate() {
        Dog__c dog = new Dog__c(Name = 'Fido', HealthFormReceived__c = null);
        insert dog;
        ContentVersion cv = createLink('Dog', 'HealthForm', dog.Id);
        FileService.updateDate(cv, dog.Id, Date.today());

        dog = [
            SELECT HealthFormReceived__c
            FROM Dog__c
            WHERE Id = :dog.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            dog.HealthFormReceived__c,
            'HealthFormReceived not set'
        );
    }

    @isTest
    public static void updateDate_DogXray_SetsDate() {
        Dog__c dog = new Dog__c(Name = 'Fido', XrayReceived__c = null);
        insert dog;
        ContentVersion cv = createLink('Dog', 'Xray', dog.Id);
        FileService.updateDate(cv, dog.Id, Date.today());

        dog = [SELECT XrayReceived__c FROM Dog__c WHERE Id = :dog.Id LIMIT 1];
        system.assertEquals(
            Date.today(),
            dog.XrayReceived__c,
            'XrayReceived not set'
        );
    }

    @isTest
    public static void updateDate_DogVacExams_SetsDate() {
        Dog__c dog = new Dog__c(Name = 'Fido', VacExamsReceived__c = null);
        insert dog;
        ContentVersion cv = createLink('Dog', 'VacExams', dog.Id);
        FileService.updateDate(cv, dog.Id, Date.today());

        dog = [
            SELECT VacExamsReceived__c
            FROM Dog__c
            WHERE Id = :dog.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            dog.VacExamsReceived__c,
            'VacExamsReceived not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerApplication_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Volunteer', 'Application', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT VolunteerApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.VolunteerApplicationReceived__c,
            'ApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_BoardApplication_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Board', 'Application', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT BoardApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.BoardApplicationReceived__c,
            'ApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_ClientApplication_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Client', 'Application', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ClientApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ClientApplicationReceived__c,
            'ApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_TSiMApplication_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('TSiM', 'Application', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT TSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.TSiMApplicationReceived__c,
            'ApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMApplication_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('ADSiM', 'Application', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ADSiMApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ADSiMApplicationReceived__c,
            'ApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorApplication_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink(
            'Facilitator',
            'Application',
            contact.Id
        );
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT FacilitatorApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.FacilitatorApplicationReceived__c,
            'ApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_TrainerApplication_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Trainer', 'Application', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT TrainerApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.TrainerApplicationReceived__c,
            'ApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_StaffApplication_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Staff', 'Application', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT StaffApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.StaffApplicationReceived__c,
            'ApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Volunteer', 'Agreement', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT VolunteerAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.VolunteerAgreementReceived__c,
            'AgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_BoardAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Board', 'Agreement', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT BoardAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.BoardAgreementReceived__c,
            'AgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_StaffAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Staff', 'Agreement', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT StaffAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.StaffAgreementReceived__c,
            'AgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerResume_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Volunteer', 'Resume', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT VolunteerResumeReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.VolunteerResumeReceived__c,
            'ResumeReceived not set'
        );
    }

    @isTest
    public static void updateDate_BoardResume_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Board', 'Resume', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT BoardResumeReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.BoardResumeReceived__c,
            'ResumeReceived not set'
        );
    }

    @isTest
    public static void updateDate_StaffResume_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Staff', 'Resume', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT StaffResumeReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.StaffResumeReceived__c,
            'ResumeReceived not set'
        );
    }

    @isTest
    public static void updateDate_BoardCoI_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Board', 'CoI', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT BoardCoIReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.BoardCoIReceived__c,
            'CoIReceived not set'
        );
    }

    @isTest
    public static void updateDate_BoardToN_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Board', 'ToN', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT BoardToNReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.BoardToNReceived__c,
            'ToNReceived not set'
        );
    }

    @isTest
    public static void updateDate_ClientPreApplication_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Client', 'PreApplication', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ClientPreApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ClientPreApplicationReceived__c,
            'PreApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMPreApplication_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('ADSiM', 'PreApplication', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ADSiMPreApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ADSiMPreApplicationReceived__c,
            'PreApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDate_ClientLOMI_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Client', 'LOMI', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ClientLOMIReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ClientLOMIReceived__c,
            'LOMIReceived not set'
        );
    }

    @isTest
    public static void updateDate_ClientVAPW_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Client', 'VAPW', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ClientVAPWReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ClientVAPWReceived__c,
            'VAPWReceived not set'
        );
    }

    @isTest
    public static void updateDate_ClientSurvey_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Client', 'Survey', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ClientSurveyReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ClientSurveyReceived__c,
            'SurveyReceived not set'
        );
    }

    @isTest
    public static void updateDate_ClientProgAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Client', 'ProgAgreement', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ClientProgAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ClientProgAgreementReceived__c,
            'ProgAgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_TSiMProgAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('TSiM', 'ProgAgreement', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT TSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.TSiMProgAgreementReceived__c,
            'ProgAgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_ADSiMProgAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('ADSiM', 'ProgAgreement', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ADSiMProgAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ADSiMProgAgreementReceived__c,
            'ProgAgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorProgAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink(
            'Facilitator',
            'ProgAgreement',
            contact.Id
        );
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT FacilitatorProgAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.FacilitatorProgAgreementReceived__c,
            'ProgAgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_TrainerProgAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Trainer', 'ProgAgreement', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT TrainerProgAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.TrainerProgAgreementReceived__c,
            'ProgAgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_ClientCertAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Client', 'CertAgreement', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ClientCertAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ClientCertAgreementReceived__c,
            'CertAgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorCertAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink(
            'Facilitator',
            'CertAgreement',
            contact.Id
        );
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT FacilitatorCertAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.FacilitatorCertAgreementReceived__c,
            'CertAgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_TrainerCertAgreement_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Trainer', 'CertAgreement', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT TrainerCertAgreementReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.TrainerCertAgreementReceived__c,
            'CertAgreementReceived not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorReference_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Facilitator', 'Reference', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT FacilitatorReferenceReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.FacilitatorReferenceReceived__c,
            'ReferenceReceived not set'
        );
    }

    @isTest
    public static void updateDate_TrainerReference_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Trainer', 'Reference', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT TrainerReferenceReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.TrainerReferenceReceived__c,
            'ReferenceReceived not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorProfGrowthPlan_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink(
            'Facilitator',
            'ProfGrowthPlan',
            contact.Id
        );
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT FacilitatorProfGrowthPlanReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.FacilitatorProfGrowthPlanReceived__c,
            'ProfGrowthPlanReceived not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorPracticum_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Facilitator', 'Practicum', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT FacilitatorPracticumReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.FacilitatorPracticumReceived__c,
            'PracticumReceived not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorInfrNotice_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Facilitator', 'InfrNotice', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT FacilitatorInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.FacilitatorInfrNoticeReceived__c,
            'InfrNoticeReceived not set'
        );
    }

    @isTest
    public static void updateDate_TrainerInfrNotice_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Trainer', 'InfrNotice', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT TrainerInfrNoticeReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.TrainerInfrNoticeReceived__c,
            'InfrNoticeReceived not set'
        );
    }

    @isTest
    public static void updateDate_StaffOffer_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Staff', 'Offer', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT StaffOfferReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.StaffOfferReceived__c,
            'OfferReceived not set'
        );
    }

    @isTest
    public static void updateDate_StaffW4_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Staff', 'W4', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT StaffW4Received__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.StaffW4Received__c,
            'W4Received not set'
        );
    }

    @isTest
    public static void updateDate_StaffI9_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Staff', 'I9', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT StaffI9Received__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.StaffI9Received__c,
            'I9Received not set'
        );
    }

    @isTest
    public static void updateDate_VolunteerContactForm_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Volunteer', 'ContactForm', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ContactFormReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ContactFormReceived__c,
            'ContactFormReceived not set'
        );
    }

    @isTest
    public static void updateDate_BoardContactForm_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Board', 'ContactForm', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ContactFormReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ContactFormReceived__c,
            'ContactFormReceived not set'
        );
    }

    @isTest
    public static void updateDate_ClientContactForm_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Client', 'ContactForm', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ContactFormReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ContactFormReceived__c,
            'ContactFormReceived not set'
        );
    }

    @isTest
    public static void updateDate_FacilitatorContactForm_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink(
            'Facilitator',
            'ContactForm',
            contact.Id
        );
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ContactFormReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ContactFormReceived__c,
            'ContactFormReceived not set'
        );
    }

    @isTest
    public static void updateDate_TrainerContactForm_SetsDate() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert contact;
        ContentVersion cv = createLink('Trainer', 'ContactForm', contact.Id);
        FileService.updateDate(cv, contact.Id, Date.today());

        contact = [
            SELECT ContactFormReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.ContactFormReceived__c,
            'ContactFormReceived not set'
        );
    }
}