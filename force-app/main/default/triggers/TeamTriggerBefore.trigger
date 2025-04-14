trigger TeamTriggerBefore on Team__c(before insert, before update ) {
    TeamService service = new TeamService();

    service.setTeamHandler(Trigger.new);
}