trigger ContentVersionTrigger on ContentVersion (after update) {
   List<ContentVersion> changedDates = new List<ContentVersion>();
   for (ContentVersion cv : Trigger.New) {
      ContentVersion oldCv = Trigger.oldMap.get(cv.Id);
      if (oldCv.Date__c != cv.Date__c || oldCv.Category__c != cv.Category__c || oldCv.Type__c != cv.Type__c) {
         changedDates.add(cv);
      }
   }
   FileService.updateDates(changedDates);
}