trigger TeamTrigger on Team__c (after insert, after update) {
    for (Team__c newTeam : Trigger.new) {
        TeamService.setClientDogRelationShip(newTeam);
    }
}