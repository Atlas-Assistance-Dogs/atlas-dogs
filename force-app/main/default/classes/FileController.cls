public inherited sharing class FileController {
    @AuraEnabled
    public static List<ContentVersion> contactFilesRetrieve(
        Id contactId,
        String category,
        String docType
    ) {
        list<id> lstConDocs = new List<id>();
        for (ContentDocumentLink cntLink : [
            SELECT Id, ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :contactId
        ]) {
            lstConDocs.add(cntLink.ContentDocumentId);
        }

        system.debug('lstConDocs' + lstConDocs);
        if (!lstConDocs.isEmpty()) {
            return [
                SELECT
                    Title,
                    ContentDocumentId,
                    Type__c,
                    Category__c,
                    CreatedDate
                FROM ContentVersion
                WHERE
                    ContentDocumentId IN :lstConDocs
                    AND Category__c = :category
                    AND Type__c = :docType
            ];
        } else {
            return null;
        }
    }

    @AuraEnabled
    public static void updateRecords(
        String category,
        String docType,
        List<Id> docIds
    ) {
        List<ContentVersion> cvList = [
            SELECT Title, ContentDocumentId, Type__c, Category__c
            FROM ContentVersion
            WHERE ContentDocumentId IN :docIds
        ];
        for (ContentVersion cv : cvList) {
            cv.Type__c = docType;
            cv.Category__c = category;
        }
        try {
            update cvList;
        } catch (DmlException ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static String deleteRecords(List<String> docIds) {
        system.debug('docIds' + docIds);
        try {
            delete [SELECT Id FROM ContentDocument WHERE Id = :docIds];
            return 'SUCCESS';
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static String deleteRecord(ID docId) {
        try {
            delete [SELECT Id FROM ContentDocument WHERE Id = :docId LIMIT 1];
            return 'SUCCESS';
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    @AuraEnabled
    public static ContentVersion getContentVersion(Id recordId) {
        try {
            return [
                SELECT
                    Title,
                    ContentDocumentId,
                    Type__c,
                    Category__c,
                    CreatedDate
                FROM ContentVersion
                WHERE Id = :recordId
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateContentVersion(
        String category,
        String docType,
        Id recordId
    ) {
        try {
            ContentVersion cv = [
                SELECT Type__c, Category__c
                FROM ContentVersion
                WHERE Id = :recordId
                LIMIT 1
            ];
            cv.Type__c = docType;
            cv.Category__c = category;
            update cv;
        } catch (DmlException ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static list<ContentVersion> retrieveAllData(Id recordId) {
        Id parentId = recordId;
        list<Id> lstConDocs = new List<Id>();
        for (ContentDocumentLink cntLink : [
            SELECT Id, ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :parentId
        ]) {
            lstConDocs.add(cntLink.ContentDocumentId);
        }

        if (!lstConDocs.isEmpty()) {
            return [
                SELECT
                    Title,
                    ContentDocumentId,
                    Type__c,
                    Category__c,
                    CreatedDate
                FROM ContentVersion
                WHERE ContentDocumentId IN :lstConDocs
                ORDER BY CreatedDate DESC
            ];
        } else {
            return null;
        }
    }
}
