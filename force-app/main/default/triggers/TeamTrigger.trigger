trigger TeamTrigger on Team__c (after insert, after update) {
    TeamService service = new TeamService();
    for (Team__c newTeam : Trigger.new) {
        service.setClientDogRelationShip(newTeam);
        service.updateClientStatus(newTeam);
        service.updateDogStatus(newTeam);
        service.setClientFacilitatorRelationShip(newTeam);
    }
}