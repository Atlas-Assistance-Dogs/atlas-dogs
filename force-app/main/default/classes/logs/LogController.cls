public with sharing class LogController {
  @AuraEnabled(Cacheable=true)
  public static RelatedObjects getRelatedLogs(
    Id recordId,
    String recordType,
    Integer max
  ) {
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
          ClientHours__c,
          ClientStress__c,
          Date__c,
          Details__c,
          DidMeetThisWeek__c,
          Facilitator__c,
          Facilitator__r.Name,
          FirstAidSuppliesUsed__c,
          FirstAidDetails__c,
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
          Team__c,
          Team__r.Client__c,
          Team__r.Client__r.Name,
          Team__r.Dog__c,
          Team__r.Dog__r.Name,
          Team__r.Handler__c,
          Team__r.Handler__r.Name,
          Team__r.Name,
          RecordTypeId
        FROM Log__c
        WHERE
          (Team__r.Client__c = :recordId
          OR Submitter__c = :recordId
          OR Facilitator__c = :recordId
          OR Team__r.Dog__c = :recordId)
          AND RecordType.DeveloperName = :recordType
        ORDER BY Date__c DESC NULLS LAST
        LIMIT :max
      ];
      for (Log__c log : logs) {
        LogInfo item = new LogInfo();
        item.log = log;
        item.clientName = log.Team__r.Client__r.Name;
        item.facilitatorName = log.Facilitator__r.Name;
        item.handlerName = log.Team__r.Handler__r.Name;
        item.submitterName = log.Submitter__r.Name;
        item.teamName = log.Team__r.Name;
        related.items.add(item);
      }
      related.total = [
        SELECT COUNT()
        FROM Log__c
        WHERE
          (Team__r.Client__c = :recordId
          OR Submitter__c = :recordId
          OR Facilitator__c = :recordId
          OR Team__r.Dog__c = :recordId)
          AND RecordType.DeveloperName = :recordType
      ];
      return related;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
  @AuraEnabled(Cacheable=true)
  public static RelatedObjects getTeamLogs(
    Id recordId,
    String recordType,
    Integer max
  ) {
    if (max == null) {
      max = 6;
    }
    RelatedObjects related = new RelatedObjects();
    try {
      List<Log__c> logs = [
        SELECT
          ClientHours__c,
          ClientStress__c,
          Date__c,
          Details__c,
          DidMeetThisWeek__c,
          Facilitator__c,
          Facilitator__r.Name,
          FirstAidSuppliesUsed__c,
          FirstAidDetails__c,
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
          Team__c,
          Team__r.Client__c,
          Team__r.Client__r.Name,
          Team__r.Dog__c,
          Team__r.Dog__r.Name,
          Team__r.Handler__c,
          Team__r.Handler__r.Name,
          Team__r.Name,
          RecordTypeId
        FROM Log__c
        WHERE Team__c = :recordId AND RecordType.DeveloperName = :recordType
        ORDER BY Date__c DESC NULLS LAST
        LIMIT :max
      ];
      for (Log__c log : logs) {
        LogInfo item = new LogInfo();
        item.log = log;
        item.clientName = log.Team__r.Client__r.Name;
        item.facilitatorName = log.Facilitator__r.Name;
        item.handlerName = log.Team__r.Handler__r.Name;
        item.submitterName = log.Submitter__r.Name;
        item.teamName = log.Team__r.Name;
        related.items.add(item);
      }
      related.total = [
        SELECT COUNT()
        FROM Log__c
        WHERE Team__c = :recordId AND RecordType.DeveloperName = :recordType
      ];
      return related;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
