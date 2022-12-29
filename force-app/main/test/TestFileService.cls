@isTest
public with sharing class TestFileService {
    public static ContentVersion createLink(
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
            SELECT Id, ContentDocumentId, Category__c, Type__c, Date__c
            FROM ContentVersion
            WHERE Id = :cv.Id
            LIMIT 1
        ];

        ContentDocumentLink link = new ContentDocumentLink(
            ContentDocumentId = temp.ContentDocumentId,
            LinkedEntityId = recordId
        );
        insert link;

        return temp;
    }

    @isTest
    public static void updateDates_Ignores_WhenNullList() {
        FileService.updateDates(null);
        // no assert here.  Test passes if no exception
    }
    
    @isTest
    public static void updateDates_Ignores_WhenEmptyList() {
        FileService.updateDates(new List<ContentVersion>());
        // no assert here.  Test passes if no exception
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

        ContentVersion cv = createLink(null, null, Date.today().addDays(-1), bgCheck.Id);

        FileService.updateDate(cv, bgCheck.Id);
        // no assert here.  Test passes if no exception
    }

    @isTest
    public static void updateDate_FindsLinkedDog() {
        Dog__c dog = new Dog__c(Name = 'Fido', HealthFormReceived__c = null);
        insert dog;
        ContentVersion cv = createLink('Dog', 'HealthForm', Date.today(), dog.Id);

        // Act
        FileService.updateDate(cv);

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
        ContentVersion cv = createLink('Volunteer', 'Application', Date.today(), contact.Id);

        // Act
        FileService.updateDate(cv);

        // Assert
        contact = [
            SELECT VolunteerApplicationReceived__c
            FROM Contact
            WHERE Id = :contact.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            contact.VolunteerApplicationReceived__c,
            'VolunteerApplicationReceived not set'
        );
    }

    @isTest
    public static void updateDates_UpdatesAllDates_WhenDog() {
        Dog__c record = new Dog__c(Name = 'Fido');
        insert record;
        List<ContentVersion> cvs = new List<ContentVersion>();
        cvs.add(createLink('Dog', 'HealthForm', Date.today(), record.Id));
        cvs.add(createLink('Dog', 'VacExams', Date.today().addDays(-1), record.Id));
        cvs.add(createLink('Dog', 'Xray', Date.today().addDays(-2), record.Id));
        FileService.updateDates(cvs);
        record = [
            SELECT HealthFormReceived__c, VacExamsReceived__c, XrayReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.HealthFormReceived__c,
            'HealthFormReceived__c not set'
        );
        system.assertEquals(
            Date.today().addDays(-1),
            record.VacExamsReceived__c,
            'VacExamsReceived__c not set'
        );
        system.assertEquals(
            Date.today().addDays(-2),
            record.XrayReceived__c,
            'XrayReceived__c not set'
        );
    }


    @isTest
    public static void updateDates_UpdatesAllDates_WhenContact() {
        Contact record = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'abc@abc.com'
        );
        insert record;
        List<ContentVersion> cvs = new List<ContentVersion>();
        cvs.add(createLink('Board', 'CoI', Date.today(), record.Id));
        cvs.add(createLink('Volunteer', 'Application', Date.today().addDays(-1), record.Id));
        cvs.add(createLink('Facilitator', 'ProfGrowthPlan', Date.today().addDays(-2), record.Id));
        FileService.updateDates(cvs);
        record = [
            SELECT BoardCoIReceived__c, VolunteerApplicationReceived__c, FacilitatorProfGrowthPlanReceived__c
            FROM Contact
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today(),
            record.BoardCoIReceived__c,
            'BoardCoIReceived__c not set'
        );
        system.assertEquals(
            Date.today().addDays(-1),
            record.VolunteerApplicationReceived__c,
            'VolunteerApplicationReceived__c not set'
        );
        system.assertEquals(
            Date.today().addDays(-2),
            record.FacilitatorProfGrowthPlanReceived__c,
            'FacilitatorProfGrowthPlanReceived__c not set'
        );
    }
}