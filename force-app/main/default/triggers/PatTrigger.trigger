trigger PatTrigger on PublicAccessTest__c (before insert, before update) {
    for (PublicAccessTest__c newPat : Trigger.new) {
        if (newPat.ValidUntil__c == null) {
            continue;
        }
        Team__c team = [SELECT Id, Client__c, PatValidUntil__c FROM Team__c WHERE Id = :newPat.Team__c];
        Date oldDate = null;
        if (Trigger.isUpdate) {
            //Get Old Value
            PublicAccessTest__c oldPat = trigger.oldMap.get(newPat.Id);
            oldDate = oldPat.ValidUntil__c;
        }
        
        // Check if value is updated
        if (team != null && oldDate != newPat.ValidUntil__c) {
            team.PatValidUntil__c = newPat.ValidUntil__c;
            upsert team;
            Contact contact = [SELECT Id, ClientCertificationValidUntil__c FROM Contact WHERE Id = :team.Client__c];
            contact.ClientCertificationValidUntil__c = newPat.ValidUntil__c;
            upsert contact;
        }
    }

}