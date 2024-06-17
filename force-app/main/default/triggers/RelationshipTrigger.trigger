trigger RelationshipTrigger on npe4__Relationship__c(
    after insert,
    after update,
    after delete
) {
    // track which Contacts have changed here
    Set<Id> contactIds = new Set<Id>();
    for (npe4__Relationship__c newRelationship : Trigger.new) {
        Id oldContactId = null;
        Id oldRelatedId = null;
        String oldType = null;
        if (Trigger.isUpdate || Trigger.isDelete) {
            //Get Old Value
            npe4__Relationship__c oldRelationship = Trigger.oldMap
                .get(newRelationship.Id);
            // If the relationship affects them, reset sharing rules
            if (
                oldRelationship.npe4__Status__c == 'Current' &&
                oldRelationship.npe4__Type__c == 'Guardian'
            ) {
                contactIds.add(oldRelationship.npe4__RelatedContact__c);
            }
        }
        if (!Trigger.isDelete) {
            // If the relationship affects them, reset sharing rules
            if (
                newRelationship.npe4__Status__c == 'Current' &&
                newRelationship.npe4__Type__c == 'Guardian'
            ) {
                contactIds.add(newRelationship.npe4__RelatedContact__c);
            }
        }

        List<Contact> related = [
            SELECT Id, UpdateForRelated__c
            FROM Contact
            WHERE Id IN :contactIds
        ];
        // we need a way for the contact trigger to know to update this contacts settings
        for (Contact person : related) {
            person.UpdateForRelated__c = true;
        }
        update related;
    }
}
