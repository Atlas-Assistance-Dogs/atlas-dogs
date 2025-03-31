public with sharing class CategoryRuleRepository {
    public CategoryRule__c[] getAll() {
        return [SELECT Category__c, GroupName__c, ReadOnly__c FROM CategoryRule__c];
    }
    public CategoryRule__c[] getForGroupNames(String objLabel, Set<String> allCategories, List<String> groupNames) {
        return [
            SELECT Category__c, GroupName__c, ReadOnly__c
            FROM CategoryRule__c
            WHERE (GroupName__c IN :groupNames OR GroupName__c = null OR GroupName__c = '')
            AND Object__c = :objLabel
            AND Category__c IN :allCategories
        ];
    }
    public CategoryRule__c[] getCategoriesForObject(String objLabel) {
        return [
            SELECT Category__c
            FROM CategoryRule__c
            WHERE Object__c = :objLabel AND Position__c = NULL
        ];
    }
    public CategoryRule__c[] getCategoriesForObject(String objLabel, List<String> positions) {
        return [SELECT Category__c FROM CategoryRule__c WHERE Object__c = :objLabel AND Position__c IN :positions];
    }
}