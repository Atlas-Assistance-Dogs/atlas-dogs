public with sharing class LogController {
    @AuraEnabled(Cacheable=true)
    public static List<Log__c> getRelatedLogs(id contactId) {
        try {
            return [
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
                    TeamFacilitator__c,
                    Type__c
                FROM Log__c
                WHERE
                    Client__c = :contactId
                    OR Submitter__c = :contactId
                    OR TeamFacilitator__c = :contactId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable=false)
    public static void createRelatedLog(
        id contactId,
        string roles,
        Log__c log
    ) {
        try {
            insert log;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Get the log from the Log id
    @AuraEnabled(Cacheable=true)
    public static Log__c getRelatedLog(id recordId) {
        try {
            return [
                SELECT
                    Client__c,
                    Date__c,
                    PublicAccessHours__c,
                    OtherHours__c,
                    Details__c,
                    RequestSupportFromTeam__c,
                    Submitter__c,
                    SupportDetails__c,
                    Stress__c,
                    Satisfaction__c,
                    RequestSupportFromAtlas__c,
                    TeamFacilitator__c
                FROM Log__c
                WHERE Id = :recordId
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable=false)
    public static void updateRelatedLog(Log__c log) {
        try {
            update log;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Delete the Log record
    @AuraEnabled(Cacheable=false)
    public static void deleteRelatedLog(Id recordId) {
        try {
            delete [SELECT Id FROM Log__c WHERE Id = :recordId];
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}
