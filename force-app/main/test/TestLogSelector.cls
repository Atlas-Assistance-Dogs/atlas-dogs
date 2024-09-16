/* LogSelectorTest.cls */
@IsTest(IsParallel=true)
private class TestLogSelector {
    public final static SObjectType SOBJECT_TYPE = Log__c.SObjectType;
    public static final List<Log__c> EMPTY_LIST = new List<Log__c>();

    /* Generic tests all selectors have */
    @IsTest
    static void shouldReturnRecordSObjectType() {
        LogSelector selector = LogSelector.newInstance();
        System.assertEquals(
            SOBJECT_TYPE,
            selector.getSObjectType(),
            'Expected object type returned correctly'
        );
    }

    @IsTest
    static void shouldReturnQueryFactory() {
        LogSelector selector = LogSelector.newInstance();
        System.assertNotEquals(
            null,
            selector.getQueryFactory(),
            'Expected a query factory returned'
        );
    }

    @IsTest
    static void shouldReturnObjectFieldList() {
        LogSelector selector = LogSelector.newInstance();
        System.assertNotEquals(
            null,
            selector.getSObjectFieldList(),
            'Expected field list returned'
        );
    }

    @IsTest
    static void shouldSetAndGetSObjectFieldListWithRelatedFields() {
        LogSelector selector = LogSelector.newInstance();
        selector.setSObjectFieldListWithRelatedFields(
            new List<String>{ 'test' }
        );
        List<String> result = selector.getSObjectFieldListWithRelatedFields();
        System.assert(!result.isEmpty());
    }

    @IsTest
    static void shouldNotGetErrorsOnGettingAdditionalFieldsList() {
        LogSelector selector = LogSelector.newInstance();
        selector.getAdditionalSObjectFieldList();
        System.assert(true, 'Expected no errors');
    }

    @IsTest
    static void shouldReturnEmptyListWhenSelectByIdHasEmptySetParameterVal() {
        LogSelector selector = LogSelector.newInstance();
        System.assertEquals(
            EMPTY_LIST,
            selector.selectById(new Set<Id>()),
            'Expected empty list because there is no id values in the Set'
        );
    }

    @IsTest
    static void shouldReturnEmptyListWhenSelectByIdSetDoesNotExist() {
        LogSelector selector = LogSelector.newInstance();
        System.assertEquals(
            EMPTY_LIST,
            selector.selectById(
                new Set<Id>{ fflib_IDGenerator.generate(SOBJECT_TYPE) }
            ),
            'Expected empty list because record id value does not exist'
        );
    }

    @IsTest
    static void shouldReturnEmptyListWhenSelectByIdDoesNotExist() {
        LogSelector selector = LogSelector.newInstance();
        System.assertEquals(
            null,
            selector.selectById(fflib_IDGenerator.generate(SOBJECT_TYPE)),
            'Expected null because record id value does not exist'
        );
    }

    @IsTest
    static void shouldReturnEmptyListWhenSelectSObjectsByIdSetDoesNotExist() {
        LogSelector selector = LogSelector.newInstance();
        System.assertEquals(
            new List<SObject>(),
            selector.selectSObjectsById(
                new Set<Id>{ fflib_IDGenerator.generate(SOBJECT_TYPE) }
            ),
            'Expected empty list because record id value does not exist'
        );
    }

    /* Selector specific tests */
    @IsTest
    static void testSelectAll() {
        LogSelector selector = LogSelector.newInstance();
        System.assertEquals(
            EMPTY_LIST,
            selector.selectAll(),
            'Expected empty list because there have been no test records inserted'
        );
    }
}
