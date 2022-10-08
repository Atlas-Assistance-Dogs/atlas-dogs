trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert, after delete) {
    for (ContentDocumentLink cdl : Trigger.new) {
        //Get Related document
        ContentVersion cv = [
            SELECT Id, Category__c, Type__c, Date__c, ContentDocumentId
            FROM ContentVersion
            WHERE ContentDocumentId = :cdl.ContentDocumentId
            LIMIT 1
        ];
        if (trigger.isDelete) {
            // Clear the date associated with this document
            ClearDateService.clear(cv, cdl.LinkedEntityId);
            // get the next most recent
            List<ContentDocumentLink> cdls = [
                SELECT Id, ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :cdl.LinkedEntityId
            ];
            List<Id> documentIds = new List<Id>();
            for (ContentDocumentLink link : cdls) {
                documentIds.add(link.ContentDocumentId);
            }
            // See if there is another with this category/type.
            // There is the special case of 'ContactForm' which is valid for any category, so ignore
            // Category if Type is that
            cv = [
                SELECT Category__c, Type__c, Date__c
                FROM ContentVersion
                WHERE ContentDocumentId IN :documentIds AND ((Type__c = 'ContactForm' AND Type__c = :cv.Type__c) OR
                (Category__c = :cv.Category__c AND Type__c = :cv.Type__c))
                ORDER BY Date__c DESC
                LIMIT :1
            ];
        }
        FileService.updateDate(cv);
    }
}