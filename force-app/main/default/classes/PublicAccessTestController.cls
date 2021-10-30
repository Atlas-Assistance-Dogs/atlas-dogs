public with sharing class PublicAccessTestController {
    @AuraEnabled(Cacheable=true)
    public static List<PublicAccessTest__c> getRelatedPats(id contactId) {
        try {
            return [
                SELECT
                    Assessor__c,
                    AssessorComments__c,
                    Client__c,
                    DateCompleted__c,
                    Dog__c,
                    Dog__r.Name,
                    Handler__c,
                    Location__c,
                    ReviewComments__c,
                    Status__c,
                    Type__c
                FROM PublicAccessTest__c
                WHERE
                    Assessor__c = :contactId
                    OR Client__c = :contactId
                    OR Handler__c = :contactId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable=true)
    public static PublicAccessTest__c getPat(id recordId) {
        try {
            return [
                SELECT
                    Assessor__c,
                    AssessorComments__c,
                    Client__c,
                    DateCompleted__c,
                    Dog__c,
                    Handler__c,
                    Location__c,
                    ReviewComments__c,
                    Status__c,
                    Type__c
                FROM PublicAccessTest__c
                WHERE Id = :recordId
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createPat(PublicAccessTest__c record) {
        try {
            insert record;
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
