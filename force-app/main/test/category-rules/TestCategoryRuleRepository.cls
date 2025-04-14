/**
 * This class contains unit tests for the CategoryRuleRepository
 */
@isTest
private class TestCategoryRuleRepository {
    static CategoryRuleRepository repo = new CategoryRuleRepository();

    @isTest
    static void getAllReturnsEmptyWhenNoRecords() {
        List<CategoryRule__c> actual = repo.getAll();
        System.assertEquals(new List<CategoryRule__c>(), actual, 'not an empty list');
    }

    @isTest
    static void getAllReturnsAllRecords() {
        List<CategoryRule__c> rules = new List<CategoryRule__c>{
            new CategoryRule__c(Category__c = 'Board', GroupName__c = 'group1', Object__c = 'Contact', ReadOnly__c = true),
            new CategoryRule__c(Category__c = 'Dog', GroupName__c = 'group2', Object__c = 'Dog__c', ReadOnly__c = false),
            new CategoryRule__c(Category__c = 'Trainer', GroupName__c = 'group3', Object__c = 'Contact')
        };
        insert rules;
        List<CategoryRule__c> actual = repo.getAll();
        System.assertEquals(rules.size(), actual.size(), 'missed some');
    }
}