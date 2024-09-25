@isTest
public class MockRelationshipRepository implements IRelationshipRepository {
    private static final List<npe4__Relationship__c> teams = new List<npe4__Relationship__c>();
    public npe4__Relationship__c create(npe4__Relationship__c team) {
        return team;
    }
    public List<npe4__Relationship__c> current {get; set;}
    public List<npe4__Relationship__c> getCurrentRelated(Set<Id> ids, String status) {
        return current;
    }
}
