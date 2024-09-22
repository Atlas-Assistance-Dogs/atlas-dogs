public inherited sharing class LogSelector extends ApplicationSObjectSelector implements ILogSelector {
    /* 1. sObjectField list */
    private List<String> additionalSObjectFieldList = new List<String>{
        'ClientHours__c',
        'ClientStress__c',
        'Date__c',
        'Details__c',
        'DidMeetThisWeek__c',
        'Facilitator__c',
        'Facilitator__r.Name',
        'Name',
        'OtherHours__c',
        'PublicAccessHours__c',
        'RequestSupportFromAtlas__c',
        'RequestSupportFromTeam__c',
        'Satisfaction__c',
        'SessionType__c',
        'Stress__c',
        'Submitter__c',
        'Submitter__r.Name',
        'SupportDetails__c',
        'Team__c',
        'Team__r.Client__c',
        'Team__r.Client__r.Name',
        'Team__r.Dog__c',
        'Team__r.Dog__r.Name',
        'Team__r.Handler__c',
        'Team__r.Handler__r.Name',
        'Team__r.Name',
        'RecordTypeId'
    };

    /* 2. Boilerplate code */
    public static LogSelector newInstance() {
        return (LogSelector) Application.Selector.newInstance(
            Log__c.SObjectType
        );
    }

    public Schema.SObjectType getSObjectType() {
        return Log__c.SObjectType;
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
    public List<Log__c> selectById(Set<Id> idSet) {
        if (idSet.isEmpty()) {
            return new List<Log__c>();
        }

        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        qf.setCondition('Id IN :idSet');
        return Database.query(qf.toSOQL());
    }

    public Log__c selectById(Id recordId) {
        List<Log__c> recordList = selectById(new Set<Id>{ recordId });
        return recordList.isEmpty() ? null : recordList[0];
    }

    public List<Log__c> selectAllWithinDays(String recordType, Integer days) {
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        List<String> filters = new List<String>();
        if (recordType != null) {
            filters.add('RecordType.DeveloperName = :recordType');
        }
        if (days != null) {
            filters.add('Date__c > LAST_N_DAYS:' + days.toString());
        }
        if (filters.size() > 0) {
            qf.setCondition(String.join(filters, ' AND '));
        }
        return Database.query(qf.toSOQL());
    }

    public List<Log__c> selectRelated(
        Id recordId,
        String recordType
    ) {
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        qf.setCondition(
            String.join(
                new List<String>{
                    '(Team__r.Client__c = :recordId',
                    'OR Submitter__c = :recordId',
                    'OR Facilitator__c = :recordId',
                    'OR Team__r.Dog__c = :recordId)',
                    'AND RecordType.DeveloperName = :recordType'
                },
                ' '
            )
        );
        Schema.SObjectField field = fflib_SObjectDescribe.getDescribe('Log__c')
            .getField('Date__c');
        fflib_QueryFactory.Ordering order = new fflib_QueryFactory.Ordering(
            field,
            fflib_QueryFactory.SortOrder.DESCENDING,
            true
        );
        qf.setOrdering(order);
        return Database.query(qf.toSOQL());
    }

    public List<Log__c> selectForTeam(
        Id recordId,
        String recordType
    ) {
        fflib_QueryFactory qf = getQueryFactory();
        qf.selectFields(getSObjectFieldListWithRelatedFields());
        qf.setCondition('Team__c = :recordId AND RecordType.DeveloperName = :recordType');
        Schema.SObjectField field = fflib_SObjectDescribe.getDescribe('Log__c')
            .getField('Date__c');
        fflib_QueryFactory.Ordering order = new fflib_QueryFactory.Ordering(
            field,
            fflib_QueryFactory.SortOrder.DESCENDING,
            true
        );
        qf.setOrdering(order);
        return Database.query(qf.toSOQL());
    }

}
