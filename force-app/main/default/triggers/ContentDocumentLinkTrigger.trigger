trigger ContentDocumentLinkTrigger on ContentDocumentLink(
    after insert,
    after delete
) {
    for (ContentDocumentLink link : Trigger.new) {
        if (link.LinkedEntityId == null) {
            continue; // skip any without a program
        }
        ContentVersion cv = [
            SELECT Id, Category__c, Type__c, LastModifiedDate
            FROM ContentVersion
            WHERE Id = :link.ContentDocumentId
            LIMIT 1
        ];
        if (cv == null) {
            return;
        }
        String query;
        if (cv.Category__c == 'Dog') {
            // this is related to a dog
            query = string.format(
                'SELECT Id, {0}__c FROM Dog__c WHERE Id = :link.LinkedEntityId LIMIT 1',
                new List<Object>{ cv.Type__c.replace(' ', '') }
            );
            Dog__c dog = Database.query(query);

            if (dog != null) {
                FileService.updateDogDate(dog, cv);
                return;
            }
        }

        query = string.format(
            'SELECT Id, {0}{1}__c FROM Contact WHERE Id = :link.LinkedEntityId LIMIT 1',
            new List<Object>{ cv.Category__c, cv.Type__c.replace(' ', '') }
        );
        Contact contact = Database.query(query);

        if (contact != null) {
            // this is related to a contact
            FileService.updateContactDate(contact, cv);
            return;
        }
    }

}
