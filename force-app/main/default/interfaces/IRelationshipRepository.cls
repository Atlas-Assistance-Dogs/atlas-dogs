public interface IRelationshipRepository {
    List<npe4__Relationship__c> getCurrentRelated(Set<Id> contactIds, String type);
}