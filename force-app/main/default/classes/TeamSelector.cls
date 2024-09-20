public inherited sharing class TeamSelector extends ApplicationSObjectSelector implements ITeamSelector{

  /* 1. sObjectField list */
  private List<String> additionalSObjectFieldList = new List<String>{
    'Id',
    'Client__c', 'Facilitator__c', 'PatValidUntil__c', 'PatCount__c'
  };
 
  /* 2. Boilerplate code */
  public static TeamSelector newInstance() {
    return (TeamSelector) Application.Selector.newInstance(
      Team__c.SObjectType
    );
  }
 
  public Schema.SObjectType getSObjectType() {
    return Team__c.SObjectType;
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
  public List<Team__c> selectById(Set<Id> idSet) {
    if (idSet.isEmpty()) {
      return new List<Team__c>();
    }
 
    fflib_QueryFactory qf = getQueryFactory();
    qf.selectFields(getSObjectFieldListWithRelatedFields());
    qf.setCondition('Id IN :idSet');
    return Database.query(qf.toSOQL());
  }
 
  public Team__c selectById(Id recordId) {
    List<Team__c> recordList = selectById(new Set<Id>{ recordId });
    return recordList.isEmpty() ? null : recordList[0];
  }
 
  public List<Team__c> selectAll() {
    fflib_QueryFactory qf = getQueryFactory();
    qf.selectFields(getSObjectFieldListWithRelatedFields());
    return Database.query(qf.toSOQL());
  }
}