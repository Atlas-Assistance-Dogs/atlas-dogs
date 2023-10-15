trigger RelationshipTrigger on npe4__Relationship__c (after insert, after update) {
    // track which Contacts have changed here
    Set<Id> contactIds = new Set<Id>();
    for (npe4__Relationship__c newRelationship : Trigger.new) {
        Id oldContactId = null;
        Id oldRelatedId = null;
        String oldType = null;
        if (Trigger.isUpdate) {
            //Get Old Value
            npe4__Relationship__c oldRelationship = trigger.oldMap.get(newRelationship.Id);
            oldContactId = oldRelationship.npe4__Contact__c;
            oldRelatedId = oldRelationship.npe4__RelatedContact__c;
            oldType = oldRelationship.npe4__Type__c;
        }

        // If the relationship has changed, update sharing rules
        if (newRelationship.npe4__Type__c != oldType || newRelationship.npe4__Contact__c != oldContactId) {
            contactIds.add(newRelationship.npe4__RelatedContact__c);
        }
        if (newRelationship.npe4__RelatedContact__c != oldRelatedId) {
            contactIds.add(newRelationship.npe4__RelatedContact__c);
            contactIds.add(oldRelatedId);
        }
    }

    ContactService.shareContactsBasedOnRelations(contactIds);
}