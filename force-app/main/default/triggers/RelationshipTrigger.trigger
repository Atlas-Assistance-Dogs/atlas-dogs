trigger RelationshipTrigger on npe4__Relationship__c(
  after insert,
  after update,
  after delete
) {
  // track which Contacts have changed here
  Set<Id> contactIds = new Set<Id>();
  if (Trigger.isUpdate || Trigger.isDelete) {
    for (npe4__Relationship__c oldRelationship : Trigger.old) {
      System.debug('in loop');
      // If the relationship affects them, reset sharing rules
      if (
        oldRelationship.npe4__Status__c == 'Current' &&
        oldRelationship.npe4__RelatedContact__c != null &&
        (oldRelationship.npe4__Type__c.contains('Emergency Contact') ||
        oldRelationship.npe4__Type__c == 'Guardian')
      ) {
        contactIds.add(oldRelationship.npe4__RelatedContact__c);
      }
      if (!Trigger.isDelete) {
        npe4__Relationship__c newRelationship = Trigger.newMap
          .get(oldRelationship.id);
        // If the relationship affects them, reset sharing rules
        if (
          newRelationship.npe4__Status__c == 'Current' &&
          (newRelationship.npe4__Type__c.contains('Emergency Contact') ||
          newRelationship.npe4__Type__c == 'Guardian')
        ) {
          contactIds.add(newRelationship.npe4__RelatedContact__c);
        }
      }
    }
  }

  if (Trigger.isInsert) {
    for (npe4__Relationship__c oldRelationship : Trigger.new) {
      System.debug('in insert loop');
      // If the relationship affects them, reset sharing rules
      if (
        oldRelationship.npe4__Status__c == 'Current' &&
        oldRelationship.npe4__RelatedContact__c != null &&
        (oldRelationship.npe4__Type__c.contains('Emergency Contact') ||
        oldRelationship.npe4__Type__c == 'Guardian')
      ) {
        contactIds.add(oldRelationship.npe4__RelatedContact__c);
      }
    }
  }

  List<Contact> related = [
    SELECT Id, UpdateForRelated__c, UpdateSharing__c
    FROM Contact
    WHERE Id IN :contactIds
  ];
  // we need a way for the contact trigger to know to update this contacts settings
  for (Contact person : related) {
    person.UpdateForRelated__c = true;
    person.UpdateSharing__c = true;
  }
  update related;
}
