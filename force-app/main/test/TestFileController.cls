@isTest
public with sharing class TestFileController {
    private Contact jill;
    private Dog__c rover;
    private PublicAccessTest__c pat;
    private BackgroundCheck__c check;

    public static List<ContentVersion> insertRecords() {
        List<ContentVersion> documents = new List<ContentVersion>();
        documents.add(
            new ContentVersion(
                Title = 'TestDocument1',
                PathOnClient = 'TestDocument1.jpg',
                Origin = 'H',
                VersionData = Blob.valueOf('Document Body 1'),
                Category__c = 'Volunteer',
                Type__c = 'Agreement',
                Date__c = Date.today().addDays(-2)
            )
        );
        documents.add(
            new ContentVersion(
                Title = 'TestDocument2',
                PathOnClient = 'TestDocument2.jpg',
                Origin = 'H',
                VersionData = Blob.valueOf('Document Body 2'),
                Category__c = 'Board',
                Type__c = 'CoI',
                Date__c = Date.today().addDays(-1)
            )
        );
        documents.add(
            new ContentVersion(
                Title = 'TestDocument3',
                PathOnClient = 'TestDocument3.jpg',
                Origin = 'H',
                VersionData = Blob.valueOf('Document Body 3'),
                Category__c = 'Staff',
                Type__c = 'Resume',
                Date__c = Date.today()
            )
        );
        insert documents;

        documents = [
            SELECT
                Id,
                ContentDocumentId,
                Title,
                PathOnClient,
                Origin,
                VersionData,
                Category__c,
                Type__c,
                Date__c
            FROM ContentVersion
        ];
        return documents;
    }

    @isTest
    public static void updateRecords_SetsAllDocsToSameCategoryAndType() {
        List<ContentVersion> documents = insertRecords();
        List<Id> docIds = new List<Id>();
        for (ContentVersion cv : documents) {
            docIds.add(cv.ContentDocumentId);
        }

        Test.startTest();
        FileController.updateRecords('Trainer', 'InfrNotice', Date.today(), docIds);
        Test.stopTest();

        List<ContentVersion> results = [
            SELECT Id, Category__c, Type__c, Date__c
            FROM ContentVersion
        ];

        for (ContentVersion actual : results) {
            System.assertEquals('Trainer', actual.Category__c);
            System.assertEquals('InfrNotice', actual.Type__c);
            System.assertEquals(Date.today(), actual.Date__c);
        }
    }

    @isTest
    public static void updateRecords_ThrowsException_WhenNullList() {
        Boolean thrown = false;
        Test.startTest();
        try {
            FileController.updateRecords('Trainer', 'InfrNotice', Date.today(), null);
        } catch (AuraHandledException e) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void updateRecords_HandlesEmptyList() {
        Test.startTest();
        FileController.updateRecords('Trainer', 'InfrNotice', Date.today(), new List<Id>());
        Test.stopTest();
    }

    @isTest
    public static void updateRecords_HandlesNullParameters() {
        Test.startTest();
        FileController.updateRecords(null, null, null, new List<Id>());
        Test.stopTest();
    }

    @isTest
    public static void updateRecords_Returns_WhenNoMatches() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;
        Test.startTest();
        FileController.updateRecords(
            'Dog',
            'Vet Health Form',
            null,
            new List<Id>{ ace.Id }
        );
        Test.stopTest();
    }

    @isTest
    public static void updateRecords_ThrowsException_WhenInvalidType() {
        ContentVersion cv = new ContentVersion(
            Title = 'TestDocument1',
            PathOnClient = 'TestDocument1.jpg',
            Origin = 'H',
            VersionData = Blob.valueOf('Document Body 1'),
            Category__c = 'Volunteer',
            Type__c = 'Agreement'
        );
        insert cv;

        cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];

        Boolean thrown = false;

        Test.startTest();
        try {
            FileController.updateRecords(
                'Doggie',
                'Health Form',
                Date.today(),
                new List<Id>{ cv.ContentDocumentId }
            );
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void deleteLink_ThrowsException_WhenNull() {
        Boolean thrown = false;
        Test.startTest();
        try {
            FileController.deleteLink(null);
        } catch (AuraHandledException e) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void deleteLink_DeletesDocument_WhenOnlyOneLink() {
        Account ace = new Account(Name = 'Ace');
        insert ace;
        ContentVersion cv = TestFileService.createLink(null, null, Date.today(), ace.Id);
        ContentDocumentLink link = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId = :cv.ContentDocumentId AND LinkedEntityId = :ace.Id];
        // Not sure how we are getting more than one link, but if there is more than one, delete the rest.
        delete [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :cv.ContentDocumentId AND Id <> :link.Id];

        Test.startTest();
        FileController.deleteLink(link);

        Test.stopTest();
        
        List<ContentVersion> cvs = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :cv.ContentDocumentId];
        System.assert(cvs.isEmpty());
        List<ContentDocument> cds = [SELECT Id FROM ContentDocument WHERE Id = :cv.ContentDocumentId];
        System.assert(cds.isEmpty());
    }

    @isTest
    public static void deleteLink_DeletesLink_WhenMoreThanOne() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;
        ContentVersion cv = TestFileService.createLink('Volunteer', 'Application', Date.today(), ace.Id);
        ContentDocumentLink link1 = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :cv.ContentDocumentId AND LinkedEntityId = :ace.Id];
        // Not sure how we are getting more than one link, but if there is more than one, delete the rest.
        delete [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :cv.ContentDocumentId AND Id <> :link1.Id];

        Contact jill = new Contact(FirstName='Jill', LastName='Hill', Email = 'jill@test.org');
        insert jill;

        ContentDocumentLink link = new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId,
            LinkedEntityId = jill.Id
        );
        insert link;

        Test.startTest();
        FileController.deleteLink(link);

        Test.stopTest();
        List<ContentDocument> cds = [SELECT Id FROM ContentDocument WHERE Id = :cv.ContentDocumentId];
        System.assertEquals(1, cds.size());
        List<ContentDocumentLink> cdls = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :cv.ContentDocumentId];
        System.assertEquals(1, cdls.size());
        System.assertEquals(link1.Id, cdls[0].Id);
        // Just finishing this select is our assert, since an exception will be thrown if the cv doesn't exist
        cv = [SELECT Id FROM ContentVersion WHERE Id = :cv.Id];
    }

    @isTest
    public static void updateContentVersion_ThrowsException_WhenNullId() {
        Boolean thrown = false;
        Test.startTest();
        try {
            FileController.updateContentVersion('Trainer', 'Reference', null, null);
        } catch (AuraHandledException e) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void updateContentVersion_ThrowsException_WhenBadId() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;
        Boolean thrown = false;
        Test.startTest();
        try {
            FileController.updateContentVersion(
                'Trainer',
                'ProgAgreement',
                Date.today(),
                ace.Id
            );
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void updateContentVersion_HandlesNullParameters() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;
        Boolean thrown = false;
        Test.startTest();
        try {
            FileController.updateContentVersion(null, null, null, ace.Id);
        } catch (AuraHandledException e) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void updateContentVersion_ThrowsException_WhenNoMatch() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;
        Boolean thrown = false;
        Test.startTest();
        try {
            FileController.updateContentVersion(
                'Dog',
                'Vet Health Form',
                Date.today(),
                ace.Id
            );
        } catch (AuraHandledException e) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void updateContentVersion_ThrowsException_WhenInvalidType() {
        ContentVersion cv = new ContentVersion(
            Title = 'TestDocument1',
            PathOnClient = 'TestDocument1.jpg',
            Origin = 'H',
            VersionData = Blob.valueOf('Document Body 1'),
            Category__c = 'Volunteer',
            Type__c = 'Application'
        );
        insert cv;

        cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];

        Boolean thrown = false;

        Test.startTest();
        try {
            FileController.updateContentVersion(
                'Doggie',
                'Health Form',
                Date.today(),
                cv.ContentDocumentId
            );
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void updateContentVersion_Updates_WhenGoodData() {
        ContentVersion cv = new ContentVersion(
            Title = 'TestDocument1',
            PathOnClient = 'TestDocument1.jpg',
            Origin = 'H',
            VersionData = Blob.valueOf('Document Body 1'),
            Category__c = 'Volunteer',
            Type__c = 'Application'
        );
        insert cv;
        Date yesterday = Date.today().addDays(-1);

        Test.startTest();
        FileController.updateContentVersion(
            'Dog',
            'VacExams',
            yesterday,
            cv.Id
        );

        Test.stopTest();
        cv = [SELECT Category__c, Type__c, Date__c FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];

        System.assertEquals('Dog', cv.Category__c);
        System.assertEquals('VacExams', cv.Type__c);
        System.assertEquals(yesterday, cv.Date__c);
    }

    @isTest
    public static void getRelatedFiles_ThrowsException_WhenNullRecord() {
        Boolean thrown = false;

        Test.startTest();
        try {
            FileController.getRelatedFiles(null, null);
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void getRelatedFiles_ReturnsEmptyList_WhenNoRecords() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;

        Test.startTest();
        RelatedObjects related = FileController.getRelatedFiles(ace.Id, 6);

        Test.stopTest();

        System.assert(related.items.isEmpty());
        System.assertEquals(0, related.total);
    }

    // This method is used to setup the getRelatedFilesWith... tests.  The file records have categories
    // of Board, Staff, and Volunteer.
    private static RelatedObjects getRelatedFilesWithGroups(string[] groups) {
        TestCategoryRuleController.createCategoryRules();

        Contact rowan = new Contact(FirstName = 'Rowan', LastName = 'Engelmeyer-Davis', email='rowan@test.com',
            Positions__c='Client;Volunteer;Staff;Board Member');
        insert rowan;

        List<ContentVersion> documents = insertRecords();

        // delete all but the first document
        List<Id> ids = new List<Id>();
        for (Integer idx = 0; idx < documents.size(); idx++) {
            ids.add(documents[idx].ContentDocumentId);
        }

        FileController.relateFiles(ids, rowan.Id);
        User adminUser = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToGroups(adminUser, groups);
        RelatedObjects related;
        Test.startTest();
        System.runAs(new User(Id = adminUser.Id)) {
            related = FileController.getRelatedFiles(rowan.Id, 6);
        }
        Test.stopTest();

        return related;
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForAll() {
        RelatedObjects related = getRelatedFilesWithGroups(new string[] { 'Board', 'Volunteer', 'Staff' });

        System.assertEquals(3, related.items.size());
        System.assertEquals(3, related.total);
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForBoard() {
        RelatedObjects related = getRelatedFilesWithGroups(new string[] { 'Board' });

        System.assertEquals(1, related.items.size());
        System.assertEquals(1, related.total);
        System.assertEquals('Board', ((FileInfo)related.items[0]).category);
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForVolunteer() {
        RelatedObjects related = getRelatedFilesWithGroups(new string[] { 'Volunteer' });

        System.assertEquals(1, related.items.size());
        System.assertEquals(1, related.total);
        System.assertEquals('Volunteer', ((FileInfo)related.items[0]).category);
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForStaff() {
        RelatedObjects related = getRelatedFilesWithGroups(new string[] { 'Staff' });

        System.assertEquals(1, related.items.size());
        System.assertEquals(1, related.total);
        System.assertEquals('Staff/Contractor', ((FileInfo)related.items[0]).category);
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForNone() {
        RelatedObjects related = getRelatedFilesWithGroups(new string[] { 'Team' });

        System.assertEquals(0, related.items.size());
        System.assertEquals(0, related.total);
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords_ForBoardStaff() {
        RelatedObjects related = getRelatedFilesWithGroups(new string[] { 'Board', 'Staff' });

        System.assertEquals(2, related.items.size());
        System.assertEquals(2, related.total);
    }

    @isTest
    public static void relateFile_ThrowsException_WhenNullDocumentId() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;

        Boolean thrown = false;

        Test.startTest();
        try {
            ContentVersion result = FileController.relateFile(null, ace.Id, Date.today());
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void relateFile_ThrowsException_WhenNullId() {
        List<ContentVersion> documents = insertRecords();

        Boolean thrown = false;

        Test.startTest();
        try {
            ContentVersion result = FileController.relateFile(
                documents[0].ContentDocumentId,
                null,
                Date.today()
            );
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void relateFile_RelatesDocument() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;
        List<ContentVersion> documents = insertRecords();
        ContentVersion document = documents[0];

        Test.startTest();
        ContentVersion result = FileController.relateFile(
            document.ContentDocumentId,
            ace.Id,
            Date.today()
        );
        Test.stopTest();

        ContentDocumentLink link = [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE
                ContentDocumentId = :document.ContentDocumentId
                AND LinkedEntityId = :ace.Id
            LIMIT 1
        ];
        System.assert(link != null);
        System.assertEquals(
            document.ContentDocumentId,
            result.ContentDocumentId
        );
        System.assertEquals(document.Title, result.Title);
        System.assertEquals(document.Date__c, result.Date__c);
    }

    @isTest
    public static void relateFiles_ThrowsException_WhenNullList() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;

        Boolean thrown = false;

        Test.startTest();
        try {
            FileController.relateFiles(null, ace.Id);
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void relateFiles_ThrowsException_WhenNullId() {
        List<ContentVersion> documents = insertRecords();
        List<Id> docIds = new List<Id>();
        for (ContentVersion cv : documents) {
            docIds.add(cv.ContentDocumentId);
        }

        Boolean thrown = false;

        Test.startTest();
        try {
            FileController.relateFiles(docIds, null);
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void relateFiles_DoesNothing_WhenNoRelatedDocuments() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;

        Test.startTest();
        FileController.relateFiles(new List<Id>(), ace.Id);
        Test.stopTest();

        List<ContentDocumentLink> links = [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :ace.Id
        ];
        System.assert(links.isEmpty());
    }

    @isTest
    public static void relateFiles_RelatesDocuments() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;
        List<ContentVersion> documents = insertRecords();
        List<Id> docIds = new List<Id>();
        for (ContentVersion cv : documents) {
            docIds.add(cv.ContentDocumentId);
        }

        Test.startTest();
        FileController.relateFiles(docIds, ace.Id);
        Test.stopTest();

        List<ContentDocumentLink> links = [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :ace.Id
        ];
        System.assertEquals(docIds.size(), links.size());
    }
}