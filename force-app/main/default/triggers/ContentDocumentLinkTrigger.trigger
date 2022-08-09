trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
   for (ContentDocumentLink cdl : Trigger.new) {
        //Get Related document
        ContentVersion cv = [
            SELECT Id, Category__c, Type__c, Date__c, ContentDocumentId
            FROM ContentVersion
            WHERE ContentDocumentId = :cdl.ContentDocumentId
            LIMIT 1
        ];
        FileService.updateDate(cv, cv.Date__c);
    }
}