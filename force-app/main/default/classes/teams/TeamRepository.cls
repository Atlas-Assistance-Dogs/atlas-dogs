public inherited sharing class TeamRepository{
  public Team__c create(Team__c team){
    if (team != null){
      insert team;
    }
    return team;
  }

  public List<Team__c> getByStatus(String status){
    return [SELECT Id, Client__c, TrainingStartDate__c
            FROM Team__c
            WHERE Status__c = :status];
  }

  public List<Team__c> getByIds(Set<Id> teamIds){
    return [SELECT Id, Client__c, InitialCertificationDate__c, PatValidUntil__c, PatCount__c
            FROM Team__c
            WHERE Id IN :teamIds];
  }

  public List<Team__c> modify(List<Team__c> teams){
    if (teams == null){
      return null;
    }
    upsert teams;
    return teams;
  }

}