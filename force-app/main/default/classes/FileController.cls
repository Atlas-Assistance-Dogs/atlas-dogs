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

    // Delete the link if there is more than one CDL for the document,
    // Otherwise, delete the document
    @AuraEnabled
    public static void deleteLink(ContentDocumentLink cdl) {
        if (cdl == null) {
            throw new AuraHandledException('cdl must be non-null');
        }
        try {
            Integer count = [SELECT COUNT() FROM ContentDocumentLink WHERE ContentDocumentId = :cdl.ContentDocumentId];
            if (count > 1) {
                delete cdl;
                return;
            }
            delete [SELECT Id FROM ContentDocument WHERE Id = :cdl.ContentDocumentId];
        } catch (DmlException ex) {
            throw new AuraHandledException(ex.getMessage());
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
        } catch (NullPointerException ex) {
            throw new AuraHandledException(ex.getMessage());
        } catch (QueryException ex) {
            throw new AuraHandledException(ex.getMessage());
        } catch (DmlException ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static RelatedObjects getRelatedFiles(Id recordId, Integer max) {
        if (max == null) {
            max = 6;
        }
        if (recordId == null) {
            throw new AuraHandledException('recordId must not be null');
        }

        Id parentId = recordId;
        List<Id> lstConDocs = new List<Id>();
        Map<Id, ContentDocumentLink> links = new Map<Id, ContentDocumentLink>();
        for (ContentDocumentLink cntLink : [
            SELECT Id, ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :parentId
        ]) {
            lstConDocs.add(cntLink.ContentDocumentId);
            links.put(cntLink.ContentDocumentId, cntLink);
        }

        RelatedObjects objects = new RelatedObjects();

        if (!lstConDocs.isEmpty()) {
            RelatedObjects related = new RelatedObjects();

            // get a map of the category and type labels
            Map<string, string> categoryEntries = getEntryMap(ContentVersion.Category__c.getDescribe());
            Map<string, string> typeEntries = getEntryMap(ContentVersion.Type__c.getDescribe());
            List<string> allowedCategories = CategoryRuleController.getAllowedCategoriesForObject(recordId);
            allowedCategories.add('');
            List<ContentVersion> files = [
                SELECT
                    Title,
                    ContentDocumentId,
                    Category__c,
                    Type__c,
                    Date__c
                FROM ContentVersion
                WHERE ContentDocumentId IN :lstConDocs AND FileType != 'SNOTE' AND Category__c IN :allowedCategories
                ORDER BY Date__c DESC
                LIMIT :max
            ];
            for (ContentVersion cv : files) {
                FileInfo info = new FileInfo();
                info.cv = cv;
                info.cdl = links.get(cv.ContentDocumentId);
                info.category = categoryEntries.get(cv.Category__c);
                info.type = typeEntries.get(cv.Type__c);
                related.items.add(info);
            }
            related.total = [SELECT Count() FROM ContentVersion WHERE ContentDocumentId IN :lstConDocs AND FileType != 'SNOTE'];
            return related;
        } else {
            return new RelatedObjects();
        }
    }

    public static Map<string, string> getEntryMap(Schema.DescribeFieldResult field) {
        List<Schema.PicklistEntry> entries = field.getPicklistValues();
        Map<string, string> entryMap = new Map<string, string>();
        for (Schema.PicklistEntry entry : entries) {
            entryMap.put(entry.getValue(), entry.getLabel());
        }
        return entryMap;
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