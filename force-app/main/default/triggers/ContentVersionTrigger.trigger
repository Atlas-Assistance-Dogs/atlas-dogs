trigger ContentVersionTrigger on ContentVersion (after update) {
   for (ContentVersion newCv : Trigger.new) {
        //Get Old Value
        ContentVersion oldCv = trigger.oldMap.get(newCv.Id);
        Date oldDate = oldCv.Date__c;
        
        // Check if value is updated
        FileService.updateDate(newCv);
    }
}