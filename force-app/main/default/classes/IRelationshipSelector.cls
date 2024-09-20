public interface IRelationshipSelector extends IApplicationSObjectSelector {
    List<npe4__Relationship__c> selectById(Set<Id> idSet);
    npe4__Relationship__c selectById(Id idSet);
    List<npe4__Relationship__c> selectAll();
}
