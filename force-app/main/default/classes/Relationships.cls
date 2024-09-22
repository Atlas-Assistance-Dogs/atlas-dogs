public inherited sharing class Relationships extends ApplicationSObjectDomain implements IRelationships {
 
    // 1. Boilerplate code
    public static IRelationships newInstance(List<Relationship__c> records) {
      return (IRelationships) Application.Domain.newInstance(records);
    }
   
    public static IRelationships newInstance(Set<Id> recordIds) {
      return (IRelationships) Application.Domain.newInstance(recordIds);
    }
   
    public Relationships(List<Relationship__c> records) {
      super(records);
    }
   
    public class Constructor implements fflib_SObjectDomain.IConstructable {
      public fflib_SObjectDomain construct(List<SObject> sObjectList) {
        return new Relationships(sObjectList);
      }
    }
   
    // 2. Trigger methods
    public override void onBeforeInsert() {
      this.validateUserSso(getRecords());
    }
   
    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
      this.validateUserSso(getChangedRecords(new Set<String>{ 'SSOId__c' }));
    }
   
    // 3. Domain methods
    public Map<String, Boolean> validateUserSso() {
      validateUserSso((List<Relationship__c>)getRecords());
    }
    public Map<String, Boolean> validateUserSso(List<Relationship__c> portalUsers) {
      // run sso validation here
    }
  }