public inherited sharing class RelationshipService implements IRelationshipService {
    private IRelationshipSelector selector;
    public RelationshipService() {
        selector = (IRelationshipSelector)Application.Selector.newInstance(
            npe4__Relationship__c.SObjectType
        );
    }

    // Get all current relationships for the contact with the indicated type.
    // Returns all current relationships if type is null
    public List<npe4__Relationship__c> getByContact(Id recordId, String type) {
        return selector.selectByContact(recordId, type);
    }
    // Get all current relationships for the related contact with the indicated type
    // Returns all current relationships if type is null
    public List<npe4__Relationship__c> getByRelatedContact(Id recordId, String type) {
        return selector.selectByRelated(recordId, type);
    }
    // Get all current relationships for the contact with the indicated types
    // Returns all current relationships if types is null
    public List<npe4__Relationship__c> getByContact(Id recordId, String[] types){
        return selector.selectByContact(recordId, types);
    }
}