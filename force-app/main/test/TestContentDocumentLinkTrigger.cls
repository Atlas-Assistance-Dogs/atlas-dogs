@isTest
public with sharing class TestContentDocumentLinkTrigger {
    @isTest
    static void insert_setsLastDate() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow'
        );
        insert joe;
        Id joeId = joe.Id;

        ContentVersion cv = new ContentVersion(
            Title = 'Test Category Type',
            PathOnClient = 'TestDocument3.jpg',
            Origin = 'H',
            VersionData = Blob.valueOf('Document Body 3'),
            Category__c = 'Client',
            Type__c = 'Application',
            Date__c = Date.today()
        );
        insert cv;
		cv = [SELECT Id, ContentDocumentId, Date__c FROM ContentVersion WHERE id = :cv.Id LIMIT 1];

        ContentDocumentLink link = new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId,
            LinkedEntityId = joeId
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(link, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = [SELECT ClientApplicationReceived__c FROM Contact WHERE id=:joe.Id LIMIT 1];
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(cv.Date__c, saved.ClientApplicationReceived__c);
    }

    @isTest
    static void delete_ClearsDate_WhenNoOthers() {
        string category = 'Client';
        string docType = 'Application';

        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            ClientApplicationReceived__c = Date.today().addDays(-1)
        );
        insert joe;
        Id joeId = joe.Id;

        ContentVersion cv = TestFileService.createLink(category, docType, Date.today().addDays(-1), joeId);

        List<ContentDocumentLink> links = [
            SELECT Id, LinkedEntityId
            FROM ContentDocumentLink
            WHERE ContentDocumentId = :cv.ContentDocumentId];
    
        // Act
        Test.startTest();
        Database.DeleteResult result = Database.delete(links[0], false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = [SELECT ClientApplicationReceived__c FROM Contact WHERE id=:joe.Id LIMIT 1];
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(null, saved.ClientApplicationReceived__c);
    }

    @isTest
    static void delete_SetNextDate_When2Others() {
        string category = 'Client';
        string docType = 'Application';

        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow',
            ClientApplicationReceived__c = Date.today().addDays(-1)
        );
        insert joe;
        Id joeId = joe.Id;

        ContentVersion cv1 = TestFileService.createLink(category, docType, Date.today().addDays(-3), joeId);
        ContentVersion cv2 = TestFileService.createLink(category, docType, Date.today().addDays(-2), joeId);
        ContentVersion cv3 = TestFileService.createLink(category, docType, Date.today().addDays(-1), joeId);

        ContentDocumentLink link = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :cv3.ContentDocumentId LIMIT 1];

        // Act
        Test.startTest();
        Database.DeleteResult result = Database.delete(link, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = [SELECT ClientApplicationReceived__c FROM Contact WHERE id=:joe.Id LIMIT 1];
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(Date.today().addDays(-2), saved.ClientApplicationReceived__c);
    }
}
