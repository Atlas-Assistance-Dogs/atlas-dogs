public with sharing class LogController {
    @AuraEnabled(Cacheable=true)
    public static List<ContactLog__c> getRelatedLogs(id contactId) {
        try {
            return [
                SELECT
                    Role__c,
                    Log__r.Date__c,
                    Log__r.PublicAccessHours__c,
                    Log__r.OtherHours__c,
                    Log__r.Details__c,
                    Log__r.RequestSupportFromTeam__c,
                    Log__r.SupportDetails__c,
                    Log__r.Stress__c,
                    Log__r.Satisfaction__c,
                    Log__r.RequestSupportFromAtlas__c
                FROM ContactLog__c
                WHERE Contact__c = :contactId
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
            System.debug(roles);
            ContactLog__c contactLog = new ContactLog__c(
                Role__c = roles,
                Contact__c = contactId,
                Log__c = log.Id
            );
            insert contactLog;
            System.debug(contactLog);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Get the contact log and log from the ContactLog id
    @AuraEnabled(Cacheable=true)
    public static ContactLog__c getRelatedLog(id recordId) {
        try {
            return [
                SELECT Role__c, Log__c
                FROM ContactLog__c
                WHERE Id = :recordId
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable=false)
    public static void updateRelatedLog(ContactLog__c contactLog, Log__c log) {
        try {
            update log;
            update contactLog;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Delete the ContactLog object and the associated Log record if there are no other
    // ContactLogs for it
    @AuraEnabled(Cacheable=false)
    public static void deleteRelatedLog(Id recordId) {
        try {
            ContactLog__c contactLog = [
                SELECT Id, Log__c
                FROM ContactLog__c
                WHERE Id = :recordid
            ];
            Id logId = contactLog.Log__c;
            delete contactLog;

            List<ContactLog__c> others = [
                SELECT Id
                FROM ContactLog__c
                WHERE Log__c = :logId
            ];
            if (others.isEmpty()) {
                // delete the log record also
                delete [SELECT Id FROM Log__c WHERE Id = :logId];
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}
