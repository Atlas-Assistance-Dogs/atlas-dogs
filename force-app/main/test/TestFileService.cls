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

        // insert will fill in the Id, but not the ContentDecumentId
        cv = [
            SELECT Id, ContentDocumentId, Category__c, Type__c, Date__c
            FROM ContentVersion
            WHERE Id = :cv.Id
            LIMIT 1
        ];

        ContentDocumentLink link = new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId,
            LinkedEntityId = recordId
        );
        insert link;

        return cv;
    }

    @isTest
    public static void updateDates_Ignores_WhenNullList() {
        FileService.updateDates((List<ContentVersion>)null);
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
        Dog__c dog = new Dog__c(Name = 'Fido', VacExamsReceived__c = null);
        insert dog;
        ContentVersion cv = createLink('Dog', 'VacExams', Date.today(), dog.Id);

        // Act
        FileService.updateDate(cv);

        // Assert
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
        cvs.add(createLink('Dog', 'VacExams', Date.today().addDays(-1), record.Id));
        FileService.updateDates(cvs);
        record = [
            SELECT VacExamsReceived__c
            FROM Dog__c
            WHERE Id = :record.Id
            LIMIT 1
        ];
        system.assertEquals(
            Date.today().addDays(-1),
            record.VacExamsReceived__c,
            'VacExamsReceived__c not set'
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
        cvs.add(createLink('Facilitator', 'Practicum', Date.today().addDays(-2), record.Id));
        FileService.updateDates(cvs);
        record = [
            SELECT BoardCoIReceived__c, VolunteerApplicationReceived__c, FacilitatorPracticumReceived__c
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
            record.FacilitatorPracticumReceived__c,
            'FacilitatorPracticumReceived__c not set'
        );
    }
}