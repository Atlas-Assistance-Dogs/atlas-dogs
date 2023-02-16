public with sharing class LogController {
    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getRelatedLogs(Id recordId, String recordType, Integer max) {
        if (max == null) {
            max = 6;
        }
        string objName = recordId.getSObjectType().getDescribe().getName();
        if (objName == Team__c.class.getName()) {
            return getTeamLogs(recordId, recordType, max);
        }
        RelatedObjects related = new RelatedObjects();
        try {
            List<Log__c> logs = [
                SELECT
                    Client__c,
                    Client__r.Name,
                    ClientHours__c,
                    ClientStress__c,
                    Date__c,
                    Details__c,
                    Dog__c,
                    Facilitator__c,
                    Facilitator__r.Name,
                    Handler__c,
                    Name,
                    OtherHours__c,
                    PublicAccessHours__c,
                    RequestSupportFromAtlas__c,
                    RequestSupportFromTeam__c,
                    Satisfaction__c,
                    SessionType__c,
                    Stress__c,
                    Submitter__c,
                    Submitter__r.Name,
                    SupportDetails__c,
                    RecordTypeId
                FROM Log__c
                WHERE
                    (Client__c = :recordId
                    OR Submitter__c = :recordId
                    OR Facilitator__c = :recordId
                    OR Dog__c = :recordId)
                    AND RecordType.DeveloperName = :recordType
                ORDER BY Date__c DESC NULLS LAST
                LIMIT :max
            ];
            for (Log__c log : logs) {
                LogInfo item = new LogInfo();
                item.log = log;
                item.clientName = log.Client__r.Name;
                item.facilitatorName = log.Facilitator__r.Name;
                item.submitterName = log.Submitter__r.Name;
                related.items.add(item);
            }
            related.total = [
                SELECT COUNT() FROM Log__c
                WHERE
                    (Client__c = :recordId
                    OR Submitter__c = :recordId
                    OR Facilitator__c = :recordId)
                    AND RecordType.DeveloperName = :recordType
                ];
            return related;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getTeamLogs(Id recordId, String recordType, Integer max) {
        if (max == null) {
            max = 6;
        }
        RelatedObjects related = new RelatedObjects();
        try {
            Team__c team = [SELECT Id, Client__c, Dog__c FROM Team__c WHERE Id = :recordId];

            List<Log__c> logs = [
                SELECT
                    Client__c,
                    Client__r.Name,
                    ClientHours__c,
                    ClientStress__c,
                    Date__c,
                    Details__c,
                    Dog__c,
                    Facilitator__c,
                    Facilitator__r.Name,
                    Handler__c,
                    Name,
                    OtherHours__c,
                    PublicAccessHours__c,
                    RequestSupportFromAtlas__c,
                    RequestSupportFromTeam__c,
                    Satisfaction__c,
                    SessionType__c,
                    Stress__c,
                    Submitter__c,
                    Submitter__r.Name,
                    SupportDetails__c,
                    RecordTypeId
                FROM Log__c
                WHERE
                    Client__c = :team.Client__c AND
                    Dog__c = :team.Dog__c AND
                    RecordType.DeveloperName = :recordType
                ORDER BY Date__c DESC NULLS LAST
                LIMIT :max
            ];
            for (Log__c log : logs) {
                LogInfo item = new LogInfo();
                item.log = log;
                item.clientName = log.Client__r.Name;
                item.facilitatorName = log.Facilitator__r.Name;
                item.submitterName = log.Submitter__r.Name;
                related.items.add(item);
            }
            related.total = [
                SELECT COUNT() FROM Log__c
                WHERE
                    Client__c = :team.Client__c AND
                    Dog__c = :team.Dog__c AND
                    RecordType.DeveloperName = :recordType
                ];
            return related;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
