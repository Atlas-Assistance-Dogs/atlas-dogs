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
                Type__c = 'Media and Liability Release'
            )
        );
        documents.add(
            new ContentVersion(
                Title = 'TestDocument2',
                PathOnClient = 'TestDocument2.jpg',
                Origin = 'H',
                VersionData = Blob.valueOf('Document Body 2'),
                Category__c = 'Board',
                Type__c = 'Emergency Contact'
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
                Type__c
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
        FileController.updateRecords(
            'Trainer',
            'Trainer Infraction notices as applicable',
            docIds
        );
        Test.stopTest();

        List<ContentVersion> results = [
            SELECT Id, Category__c, Type__c
            FROM ContentVersion
        ];

        for (ContentVersion actual : results) {
            System.assertEquals('Trainer', actual.Category__c);
            System.assertEquals(
                'Trainer Infraction notices as applicable',
                actual.Type__c
            );
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
            Type__c = 'Media and Liability Release'
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
}
