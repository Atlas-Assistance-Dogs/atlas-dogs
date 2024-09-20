public interface ITeamService {
    void setClientDogRelationShip(Team__c newTeam);
    void updateClientStatus(Team__c team);
    void updateDogStatus(Team__c team);
    void updatePatInformation(Set<Id> teamIds);
    void setClientFacilitatorRelationShip(Team__c newTeam);
    void createReminders();
}