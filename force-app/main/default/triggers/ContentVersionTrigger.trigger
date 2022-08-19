trigger ContentVersionTrigger on ContentVersion (after update) {
   for (ContentVersion newCv : Trigger.new) {
        //Get Old Value
        ContentVersion oldCv = trigger.oldMap.get(newCv.Id);
        Date oldDate = oldCv.Date__c;
        
        // Check if value is updated
        if (oldDate != newCv.Date__c) {
            FileService.updateDate(newCv, newCv.Date__c);
        }
    }
}