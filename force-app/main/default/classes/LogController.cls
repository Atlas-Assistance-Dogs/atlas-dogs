public with sharing class LogController {
    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getRelatedLogs(id contactId) {
        RelatedObjects related = new RelatedObjects();
        try {
            related.items = [
                SELECT
                    Client__c,
                    ClientHours__c,
                    ClientStress__c,
                    Date__c,
                    Details__c,
                    Dog__c,
                    Handler__c,
                    OtherHours__c,
                    PublicAccessHours__c,
                    RequestSupportFromAtlas__c,
                    RequestSupportFromTeam__c,
                    Satisfaction__c,
                    SessionType__c,
                    Stress__c,
                    Submitter__c,
                    SupportDetails__c,
                    Facilitator__c,
                    RecordTypeId
                FROM Log__c
                WHERE
                    Client__c = :contactId
                    OR Submitter__c = :contactId
                    OR Facilitator__c = :contactId
                ORDER BY Date__c DESC NULLS LAST
                LIMIT 6
            ];
            related.total = [
                SELECT COUNT() FROM Log__c
                WHERE
                    Client__c = :contactId
                    OR Submitter__c = :contactId
                    OR Facilitator__c = :contactId
                ];
            System.debug(related);
            return related;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable=false)
    public static void createLog(Log__c log) {
        try {
            insert log;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable=false)
    public static void updateLog(Log__c log) {
        try {
            update log;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Delete the Log record
    @AuraEnabled(Cacheable=false)
    public static void deleteLog(Id recordId) {
        try {
            delete [SELECT Id FROM Log__c WHERE Id = :recordId];
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}
