public interface IRelationshipSelector extends IApplicationSObjectSelector {
    List<npe4__Relationship__c> selectById(Set<Id> idSet);
    npe4__Relationship__c selectById(Id idSet);
    List<npe4__Relationship__c> selectAll();
    List<npe4__Relationship__c> selectByContact(Id recordId, String type);
    List<npe4__Relationship__c> selectByContact(Id recordId, String[] types);
    List<npe4__Relationship__c> selectByRelated(Id recordId, String type);
    // select will return current relationships by default.  This
    // setter can be used to return all relationships
    void setFilterIsCurrent(Boolean isCurrent) ;
}
