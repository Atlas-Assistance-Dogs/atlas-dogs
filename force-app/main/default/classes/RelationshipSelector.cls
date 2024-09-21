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
        qf.setCondition('Id IN :idSet ' + getFilterIsCurrent());
        return Database.query(qf.toSOQL());
    }

    public npe4__Relationship__c selectById(Id recordId) {
        List<npe4__Relationship__c> recordList = selectById(
            new Set<Id>{ recordId }
        );
        return recordList.isEmpty() ? null : recordList[0];
    }

    public List<npe4__Relationship__c> selectAll() {
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        return Database.query(qf.toSOQL());
    }

    public List<npe4__Relationship__c> selectByContact(Id recordId, String type) {
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        List<String> filters = new List<String>{
            'npe4__Contact__c = :recordId'
        };
        if (type != null) {
            filters.add('AND npe4__Type__c = :type');
        }
        qf.setCondition(String.join(filters, ' '));
        return Database.query(qf.toSOQL());
    }

    public List<npe4__Relationship__c> selectByContact(Id recordId, String[] types) {
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        List<String> filters = new List<String>{
            'npe4__Contact__c = :recordId'
        };
        if (types != null) {
            filters.add('AND npe4__Type__c IN :types');
        }
        qf.setCondition(String.join(filters, ' '));
        return Database.query(qf.toSOQL());
    }

    public List<npe4__Relationship__c> selectByRelated(
        Id recordId,
        String type
    ) {
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        List<String> filters = new List<String>{
            'npe4__RelatedContact__c = :recordId'
        };
        if (type != null) {
            filters.add('AND npe4__Type__c = :type');
        }
        filters.add(getFilterIsCurrent());
        qf.setCondition(String.join(filters, ' '));
        return Database.query(qf.toSOQL());
    }
    // Most queries will want the status to be current, but add this for looking at
    // non-current relationships
    private Boolean filterisCurrent = true;
    public void setFilterIsCurrent(Boolean isCurrent) {
        this.filterIsCurrent = isCurrent;
    }
    private String getFilterIsCurrent() {
        return this.filterIsCurrent == true
            ? ' AND npe4__Status__c = \'Current\' '
            : ' ';
    }
}
