trigger TeamTrigger on Team__c (before insert, before update) {
    for (Team__c newTeam : Trigger.new) {
        Contact contact = [SELECT Id, ClientValidUntil__c FROM Contact WHERE Id = :newTeam.Client__c];
        Date oldDate = null;
        if (Trigger.isUpdate) {
            //Get Old Value
            Team__c oldTeam = trigger.oldMap.get(newTeam.Id);
            oldDate = oldTeam.PatValidUntil__c;
        }
        
        // Check if value is updated
        if (contact != null && oldDate != newTeam.PatValidUntil__c) {
            contact.ClientValidUntil__c = newTeam.PatValidUntil__c;
            upsert contact;
        }
    }

}