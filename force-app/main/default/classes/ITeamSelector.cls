public interface ITeamSelector extends IApplicationSObjectSelector {
    List<Team__c> selectById(Set<Id> idSet);
    Team__c selectById(Id idSet);
    List<Team__c> selectAll();
}
