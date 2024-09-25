public interface ITeamRepository {
    Team__c create(Team__c team);
    List<Team__c> getByStatus(string status);
}