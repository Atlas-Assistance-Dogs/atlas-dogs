public inherited sharing class FileController {
    @AuraEnabled
    public static list<contentversion> contactFilesRetrieve(
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
        Id recordId,
        String category,
        String docType,
        String docName,
        List<Id> docId
    ) {
        System.debug('Category = ' + category);
        System.debug('Type = ' + docType);
        Id parentId = recordId;
        List<ContentVersion> cvListUpdate = new List<ContentVersion>();
        List<ContentVersion> cvList = [
            SELECT Title, ContentDocumentId, Type__c, Category__c
            FROM ContentVersion
            WHERE ContentDocumentId IN :docId
        ];
        for (ContentVersion cv : cvList) {
            cv.Type__c = docType;
            cv.Category__c = category;
            cvListUpdate.add(cv);
        }
        try {
            update cvListUpdate;
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
        // system.debug('docIds' + docIds);
        try {
            delete [SELECT Id FROM ContentDocument WHERE Id = :docId LIMIT 1];
            return 'SUCCESS';
        } catch (Exception ex) {
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
