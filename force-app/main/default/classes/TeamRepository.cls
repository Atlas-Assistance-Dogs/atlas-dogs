public class TeamRepository {

    public TeamRepository(){}

    public Team__c create(Team__c team) {
        insert team;
        return team;
    }

    public List<Team__c> getByStatus(String status) {
        return [
            SELECT Id, Client__c, TrainingStartDate__c
            FROM Team__c
            WHERE Status__c = :status
        ];
    }

    public List<Team__c> modify(List<Team__c> teams) {
        upsert teams;
        return teams;
    }
}