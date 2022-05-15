@isTest
public with sharing class TestFileService {
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

        FileService.updateDate(cv, bgCheck.Id, Date.today());
        // no assert here.  Test passes if no exception
    }

    @isTest
    public static void updateDate_FindsLinkedDog() {
        Dog__c dog = new Dog__c(Name = 'Fido', HealthFormReceived__c = null);
        insert dog;
        ContentVersion cv = createLink('Dog', 'HealthForm', Date.today(), dog.Id);

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
        ContentVersion cv = createLink('Client', 'Application', Date.today(), contact.Id);

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
}