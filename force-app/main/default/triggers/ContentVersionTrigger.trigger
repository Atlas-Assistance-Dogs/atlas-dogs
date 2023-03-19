trigger ContentVersionTrigger on ContentVersion (after update) {
   FileService.updateDates(Trigger.new);
}