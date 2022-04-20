public with sharing class PublicAccessTestController {
    @AuraEnabled(Cacheable=true)
    public static List<PublicAccessTest__c> getRelatedPats(id recordId) {
        try {
            return [
                SELECT
                    Assessor__c,
                    AssessorComments__c,
                    DateCompleted__c,
                    Location__c,
                    ReviewComments__c,
                    Status__c,
                    Team__c,
                    Type__c
                FROM PublicAccessTest__c
                WHERE Assessor__c = :recordId OR Team__c = :recordId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createPat(
        PublicAccessTest__c record,
        List<Id> documentIds
    ) {
        try {
            insert record;
            if (documentIds != null) {
                FileController.relateFiles(documentIds, record.Id);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updatePat(PublicAccessTest__c record) {
        try {
            update record;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deletePat(Id recordId) {
        try {
            PublicAccessTest__c pat = [
                SELECT Id
                FROM PublicAccessTest__c
                WHERE Id = :recordId
            ];
            delete pat;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
