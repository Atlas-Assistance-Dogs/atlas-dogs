public with sharing class TeamController {
  @AuraEnabled(Cacheable=true)
  public static RelatedObjects getRelatedTeams(id recordId, Integer max) {
    if (max == null) {
      max = 6;
    }
    try {
      List<Team__c> teams = [
        SELECT
          Client__c,
          Client__r.Name,
          Dog__c,
          Dog__r.Name,
          Handler__c,
          Handler__r.Name,
          Name,
          PatValidUntil__c,
          PatCount__c,
          PrimaryCertification__c,
          SecondaryCertification__c,
          Status__c
        FROM Team__c
        WHERE
          Client__c = :recordId
          OR Handler__c = :recordId
          OR Dog__c = :recordId
        LIMIT :max
      ];
      RelatedObjects related = new RelatedObjects();
      for (Team__c team : teams) {
        TeamRow row = new TeamRow();
        row.team = team;
        row.clientName = team.Client__r.Name;
        row.handlerName = team.Handler__r.Name;
        row.dogName = team.Dog__r.Name;
        related.items.add(row);
      }
      related.total = [
        SELECT COUNT()
        FROM Team__c
        WHERE
          Client__c = :recordId
          OR Handler__c = :recordId
          OR Dog__c = :recordId
      ];
      return related;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
