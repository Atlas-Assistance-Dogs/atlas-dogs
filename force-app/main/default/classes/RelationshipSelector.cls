public inherited sharing class RelationshipSelector extends ApplicationSObjectSelector implements IRelationshipSelector {
    /* 1. sObjectField list */
    private List<String> additionalSObjectFieldList = new List<String>{
        'npe4__Contact__c',
        'npe4__RelatedContact__c',
        'npe4__Type__c',
        'npe4__Status__c'
    };

    /* 2. Boilerplate code */
    public static RelationshipSelector newInstance() {
        return (RelationshipSelector) Application.Selector.newInstance(
            npe4__Relationship__c.SObjectType
        );
    }

    public Schema.SObjectType getSObjectType() {
        return npe4__Relationship__c.SObjectType;
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
    public List<npe4__Relationship__c> selectById(Set<Id> idSet) {
        if (idSet.isEmpty()) {
            return new List<npe4__Relationship__c>();
        }

        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        qf.setCondition('Id IN :idSet');
        return Database.query(qf.toSOQL());
    }

    public npe4__Relationship__c selectById(Id recordId) {
        List<npe4__Relationship__c> recordList = selectById(new Set<Id>{ recordId });
        return recordList.isEmpty() ? null : recordList[0];
    }

    public List<npe4__Relationship__c> selectAll() {
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        return Database.query(qf.toSOQL());
    }

    public List<npe4__Relationship__c> selectByContact(
        Id recordId
    ) {
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        qf.setCondition('npe4__Contact__c = :recordId AND npe4__Status__c = \'Current\'');
        return Database.query(qf.toSOQL());
    }

    public List<npe4__Relationship__c> selectByRelated(
        Id recordId,
        String recordType
    ) {
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        qf.setCondition('npe4__RelatedContact__c = :recordId AND npe4__Status__c = \'Current\'');
        return Database.query(qf.toSOQL());
    }

}
