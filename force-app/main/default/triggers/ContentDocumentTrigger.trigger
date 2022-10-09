trigger ContentDocumentTrigger on ContentDocument (before delete) {
    System.debug(Trigger.old);
    for (ContentDocument cd : Trigger.old) {
        System.debug(cd);
        ContentDocumentLink cdl = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :cd.Id LIMIT 1];

        //Get Related content version
        ContentVersion cv = [
            SELECT Id, Category__c, Type__c, Date__c, ContentDocumentId
            FROM ContentVersion
            WHERE ContentDocumentId = :cd.Id
            LIMIT 1
        ];
        // Skip if we don't have a category and type.  We need a category to have a type,
        // so just check type.
        if (String.isBlank(cv.Type__c)) {
            return;
        }

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
}