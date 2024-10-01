trigger PatTrigger on PublicAccessTest__c (after insert, after update, after delete) {
    TeamService service = new TeamService();
    Set<Id> teamIds = new Set<Id>();
    if (Trigger.old != null) {
        for (PublicAccessTest__c oldPat: Trigger.old) {
            teamIds.add(oldPat.Team__c);
        }
    }
    if (Trigger.new != null) {
        for (PublicAccessTest__c newPat : Trigger.new) {
            teamIds.add(newPat.Team__c);
        }
    }

    service.updatePatInformation(teamIds);
}