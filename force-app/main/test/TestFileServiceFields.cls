@isTest
public with sharing class TestFileServiceFields {
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

        // retrieve the cv with ContentDocumentId
        cv = [
            SELECT Id, ContentDocumentId, Title, Category__c, Type__c, Date__c
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
}