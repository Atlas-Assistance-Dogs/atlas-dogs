public interface IRelationshipService {
    // Get all current relationships for the contact with the indicated type
    // If type is null, all current relationships are returned
    List<npe4__Relationship__c> getByContact(Id recordId, String type);
    // Get all current relationships for the contact with the indicated type
    // If type is null, all current relationships are returned
    List<npe4__Relationship__c> getByRelatedContact(Id recordId, String type);
    // Get all current relationships for the contact with the indicated types
    List<npe4__Relationship__c> getByContact(Id recordId, String[] types);
}
