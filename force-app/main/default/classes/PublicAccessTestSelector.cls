public inherited sharing class PublicAccessTestSelector extends ApplicationSObjectSelector implements IPublicAccessTestSelector{

  /* 1. sObjectField list */
  private List<String> additionalSObjectFieldList = new List<String>{
    'Id',
    'Assessor__c', 'AssessorComments__c', 'DateCompleted__c', 'Location__c',
    'ReviewComments__c', 'Status__c', 'Team__c', 'Type__c', 'ValidUntil__c'
  };
 
  /* 2. Boilerplate code */
  public static PublicAccessTestSelector newInstance() {
    return (PublicAccessTestSelector) Application.Selector.newInstance(
      PublicAccessTest__c.SObjectType
    );
  }
 
  public Schema.SObjectType getSObjectType() {
    return PublicAccessTest__c.SObjectType;
  }
 
  public fflib_QueryFactory getQueryFactory() {
    return new fflib_QueryFactory(getSObjectType());
  }
 
  public override List<Schema.SObjectField> getSObjectFieldList() {
    return new List<Schema.SObjectField>();
  }
 
  public List<String> getSObjectFieldListWithRelatedFields() {
    return this.additionalSObjectFieldList;
  }
 
  public void setSObjectFieldListWithRelatedFields(String[] values) {
    this.additionalSObjectFieldList = values;
  }
 
  @TestVisible
  private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
    return new List<Schema.SObjectField>{};
  }
 
  /* 3. Selector Methods */
  public List<PublicAccessTest__c> selectById(Set<Id> idSet) {
    if (idSet.isEmpty()) {
      return new List<PublicAccessTest__c>();
    }
 
    fflib_QueryFactory qf = getQueryFactory();
    qf.selectFields(getSObjectFieldListWithRelatedFields());
    qf.setCondition('Id IN :idSet');
    return Database.query(qf.toSOQL());
  }
 
  public PublicAccessTest__c selectById(Id recordId) {
    List<PublicAccessTest__c> recordList = selectById(new Set<Id>{ recordId });
    return recordList.isEmpty() ? null : recordList[0];
  }
 
  public List<PublicAccessTest__c> selectAll() {
    fflib_QueryFactory qf = getQueryFactory();
    qf.selectFields(getSObjectFieldListWithRelatedFields());
    return Database.query(qf.toSOQL());
  }
}