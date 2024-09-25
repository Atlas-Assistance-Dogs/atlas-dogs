@isTest
public class MockTeamRepository implements ITeamRepository {
    public Team__c create(Team__c team) {
        return team;
    }
    public List<Team__c> teams {get; set;}
    public List<Team__c> getByStatus(string status) {
        return teams;
    }
}
