@isTest
public with sharing class TestFileController {
    private Contact jill;
    private Dog__c rover;
    private PublicAccessTest__c pat;
    private BackgroundCheck__c check;

    private static List<ContentVersion> insertRecords() {
        List<ContentVersion> documents = new List<ContentVersion>();
        documents.add(
            new ContentVersion(
                Title = 'TestDocument1',
                PathOnClient = 'TestDocument1.jpg',
                Origin = 'H',
                VersionData = Blob.valueOf('Document Body 1'),
                Category__c = 'Volunteer',
                Type__c = 'Agreement'
            )
        );
        documents.add(
            new ContentVersion(
                Title = 'TestDocument2',
                PathOnClient = 'TestDocument2.jpg',
                Origin = 'H',
                VersionData = Blob.valueOf('Document Body 2'),
                Category__c = 'Board',
                Type__c = 'CoI'
            )
        );
        documents.add(
            new ContentVersion(
                Title = 'TestDocument3',
                PathOnClient = 'TestDocument3.jpg',
                Origin = 'H',
                VersionData = Blob.valueOf('Document Body 3'),
                Category__c = 'Staff',
                Type__c = 'Resume'
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
                CreatedDate
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
        FileController.updateRecords('Trainer', 'Infraction Notice', docIds);
        Test.stopTest();

        List<ContentVersion> results = [
            SELECT Id, Category__c, Type__c
            FROM ContentVersion
        ];

        for (ContentVersion actual : results) {
            System.assertEquals('Trainer', actual.Category__c);
            System.assertEquals('Infraction Notice', actual.Type__c);
        }
    }

    @isTest
    public static void updateRecords_ThrowsException_WhenNullList() {
        Boolean thrown = false;
        Test.startTest();
        try {
            FileController.updateRecords(
                'Trainer',
                'Trainer Infraction notices as applicable',
                null
            );
        } catch (AuraHandledException e) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void updateRecords_HandlesEmptyList() {
        Test.startTest();
        FileController.updateRecords(
            'Trainer',
            'Trainer Infraction notices as applicable',
            new List<Id>()
        );
        Test.stopTest();
    }

    @isTest
    public static void updateRecords_HandlesNullParameters() {
        Test.startTest();
        FileController.updateRecords(null, null, new List<Id>());
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
                new List<Id>{ cv.ContentDocumentId }
            );
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void deleteRecords_ThrowsException_WhenNullList() {
        Boolean thrown = false;

        Test.startTest();
        try {
            FileController.deleteRecords(null);
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void deleteRecords_HandlesEmptyList() {
        List<ContentVersion> documents = insertRecords();

        Test.startTest();
        FileController.deleteRecords(new List<Id>());
        Test.stopTest();

        List<ContentVersion> remaining = [SELECT Id FROM ContentVersion];
        System.assertEquals(documents.size(), remaining.size());
    }

    @isTest
    public static void deleteRecords_DeletesExpectedRecords() {
        List<ContentVersion> documents = insertRecords();

        // delete all but the first document
        List<Id> ids = new List<Id>();
        for (Integer idx = 1; idx < documents.size(); idx++) {
            ids.add(documents[idx].ContentDocumentId);
        }
        Test.startTest();
        FileController.deleteRecords(ids);
        Test.stopTest();

        List<ContentVersion> remaining = [SELECT Id FROM ContentVersion];
        System.assertEquals(1, remaining.size());
        System.assertEquals(documents[0].Id, remaining[0].Id);
    }

    @isTest
    public static void deleteRecord_ThrowsException_WhenNullId() {
        Boolean thrown = false;

        Test.startTest();
        try {
            FileController.deleteRecord(null);
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void deleteRecord_HandlesBadId() {
        List<ContentVersion> documents = insertRecords();

        Test.startTest();
        FileController.deleteRecord(documents[0].Id);
        Test.stopTest();

        List<ContentVersion> remaining = [SELECT Id FROM ContentVersion];
        System.assertEquals(documents.size(), remaining.size());
    }

    @isTest
    public static void deleteRecord_DeletesExpectedRecord() {
        List<ContentVersion> documents = insertRecords();
        Test.startTest();
        FileController.deleteRecord(documents[0].ContentDocumentId);
        Test.stopTest();

        List<ContentVersion> remaining = [SELECT Id FROM ContentVersion];
        System.assertEquals(documents.size() - 1, remaining.size());
        for (ContentVersion actual : remaining) {
            System.assertNotEquals(documents[0].Id, actual.Id);
        }
    }

    @isTest
    public static void getContentVersion_ThrowsException_WhenIdNull() {
        Boolean thrown = false;

        Test.startTest();
        try {
            FileController.getContentVersion(null);
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void getContentVersion_ThrowsException_WhenNoRecord() {
        List<ContentVersion> documents = insertRecords();
        Boolean thrown = false;

        Test.startTest();
        try {
            FileController.getContentVersion(documents[0].ContentDocumentId);
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void getContentVersion_ReturnsRecordData() {
        List<ContentVersion> documents = insertRecords();

        Test.startTest();
        ContentVersion actual = FileController.getContentVersion(
            documents[0].Id
        );
        Test.stopTest();

        ContentVersion expected = documents[0];
        System.assertEquals(expected.Id, actual.Id);
        System.assertEquals(expected.Title, actual.Title);
        System.assertEquals(
            expected.ContentDocumentId,
            actual.ContentDocumentId
        );
        System.assertEquals(expected.Type__c, actual.Type__c);
        System.assertEquals(expected.Category__c, actual.Category__c);
        System.assertEquals(expected.CreatedDate, actual.CreatedDate);
    }

    @isTest
    public static void updateContentVersion_ThrowsException_WhenNullId() {
        Boolean thrown = false;
        Test.startTest();
        try {
            FileController.updateContentVersion(
                'Trainer',
                'Trainer Infraction notices as applicable',
                null
            );
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
                'Trainer Infraction notices as applicable',
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
            FileController.updateContentVersion(null, null, ace.Id);
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
                cv.ContentDocumentId
            );
        } catch (AuraHandledException e) {
            thrown = true;
        }

        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void getRelatedFiles_ThrowsException_WhenNullRecord() {
        Boolean thrown = false;

        Test.startTest();
        try {
            FileController.getRelatedFiles(null);
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
        List<ContentVersion> related = FileController.getRelatedFiles(ace.Id);

        Test.stopTest();

        System.assert(related.isEmpty());
    }

    @isTest
    public static void getRelatedFiles_ReturnsRelatedRecords() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;

        List<ContentVersion> documents = insertRecords();

        // delete all but the first document
        List<Id> ids = new List<Id>();
        for (Integer idx = 0; idx < documents.size(); idx++) {
            ids.add(documents[idx].ContentDocumentId);
        }

        FileController.relateFiles(ids, ace.Id);

        Test.startTest();
        List<ContentVersion> related = FileController.getRelatedFiles(ace.Id);

        Test.stopTest();

        System.assertEquals(documents.size(), related.size());
    }

    @isTest
    public static void relateFile_ThrowsException_WhenNullDocumentId() {
        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;

        Boolean thrown = false;

        Test.startTest();
        try {
            ContentVersion result = FileController.relateFile(null, ace.Id);
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
                null
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
            ace.Id
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
        System.assertEquals(document.CreatedDate, result.CreatedDate);
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
