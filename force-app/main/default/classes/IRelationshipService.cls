public interface IRelationshipService {
    List<npe4__Relationship__c> getByContact(Id recordId);
    List<npe4__Relationship__c> getByRelatedContact(Id recordId);
    List<npe4__Relationship__c> getByContactAndType(Id recordId, string type);
}
