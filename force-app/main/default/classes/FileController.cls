public inherited sharing class FileController {
    @AuraEnabled
    public static void updateRecords(
        String category,
        String docType,
        Date docDate,
        List<Id> docIds
    ) {
        if (docIds == null) {
            throw new AuraHandledException('docIds must be non-null');
        }
        try {
            List<ContentVersion> cvList = [
                SELECT Title, ContentDocumentId, Type__c, Category__c, Date__c
                FROM ContentVersion
                WHERE ContentDocumentId IN :docIds
            ];
            for (ContentVersion cv : cvList) {
                cv.Type__c = docType;
                cv.Category__c = category;
                cv.Date__c = docDate;
            }
            update cvList;
        } catch (DmlException ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static String deleteRecords(List<Id> docIds) {
        if (docIds == null) {
            throw new AuraHandledException('docIds must be non-null');
        }
        try {
            delete [SELECT Id FROM ContentDocument WHERE Id = :docIds];
            return 'SUCCESS';
        } catch (DmlException ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static String deleteRecord(ID docId) {
        if (docId == null) {
            throw new AuraHandledException('docId must be non-null');
        }
        try {
            delete [SELECT Id FROM ContentDocument WHERE Id = :docId LIMIT 1];
            return 'SUCCESS';
        } catch (DmlException ex) {
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
                    Category__c,
                    Type__c,
                    Date__c
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
        Date docDate,
        Id recordId
    ) {
        try {
            ContentVersion cv = [
                SELECT Category__c, Type__c, Date__c
                FROM ContentVersion
                WHERE Id = :recordId
                LIMIT 1
            ];
            cv.Type__c = docType;
            cv.Category__c = category;
            cv.Date__c = docDate;
            update cv;
            FileService.updateDate(cv, docDate);
        } catch (NullPointerException ex) {
            throw new AuraHandledException(ex.getMessage());
        } catch (QueryException ex) {
            throw new AuraHandledException(ex.getMessage());
        } catch (DmlException ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> getRelatedFiles(Id recordId) {
        List<ContentVersion> files = new List<ContentVersion>();
        for (Object item : getRelated(recordId, 10000).items) {
            files.add((ContentVersion)item);
        }
        return files;
    }

    @AuraEnabled(cacheable=true)
    public static RelatedObjects getRelated(Id recordId, Integer max) {
        if (recordId == null) {
            throw new AuraHandledException('recordId must not be null');
        }
        Id parentId = recordId;
        List<Id> lstConDocs = new List<Id>();
        for (ContentDocumentLink cntLink : [
            SELECT Id, ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :parentId
        ]) {
            lstConDocs.add(cntLink.ContentDocumentId);
        }

        RelatedObjects objects = new RelatedObjects();

        if (!lstConDocs.isEmpty()) {
            objects.total = [SELECT COUNT() FROM ContentVersion
                WHERE ContentDocumentId IN :lstConDocs AND FileType != 'SNOTE'
            ];
            List<SObject> sobjects = [
                SELECT
                    Title,
                    ContentDocumentId,
                    Category__c,
                    Type__c,
                    Date__c
                FROM ContentVersion
                WHERE ContentDocumentId IN :lstConDocs AND FileType != 'SNOTE'
                ORDER BY Date__c DESC
                LIMIT :max
            ];
            for (SObject file : sobjects) {
                objects.items.add(file);
            }
            return objects;
        } else {
            return objects;
        }
    }

    @AuraEnabled
    public static ContentVersion relateFile(Id documentId, Id recordId, Date docDate) {
        try {
            ContentDocumentLink link = new ContentDocumentLink(
                ContentDocumentId = documentId,
                LinkedEntityId = recordId
            );
            insert link;

            ContentVersion cv = [
                SELECT
                    Title,
                    ContentDocumentId,
                    Date__c,
                    LastModifiedDate,
                    Category__c,
                    Type__c
                FROM ContentVersion
                WHERE ContentDocumentId = :link.ContentDocumentId
                LIMIT 1
            ];
            FileService.updateDate(cv, recordId, docDate);
            return cv;
        } catch (NullPointerException ex) {
            throw new AuraHandledException(ex.getMessage());
        } catch (QueryException ex) {
            throw new AuraHandledException(ex.getMessage());
        } catch (DmlException ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static void relateFiles(List<Id> documentIds, Id recordId) {
        try {
            List<ContentDocumentLink> links = new List<ContentDocumentLink>();
            for (Id documentId : documentIds) {
                ContentDocumentLink link = new ContentDocumentLink(
                    ContentDocumentId = documentId,
                    LinkedEntityId = recordId
                );
                links.add(link);
            }
            insert links;
        } catch (NullPointerException ex) {
            throw new AuraHandledException(ex.getMessage());
        } catch (QueryException ex) {
            throw new AuraHandledException(ex.getMessage());
        } catch (DmlException ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}