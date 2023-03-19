public with sharing class CategoryRuleController {
    public CategoryRuleController() {

    }

    @AuraEnabled(Cacheable=true)
    public static List<String> getCategoriesForObject(Id recordId) {
        string objLabel = recordId.getSObjectType().getDescribe().getLabel();

        // get the categories that work for the object
        List<CategoryRule__c> rules = [SELECT Category__c FROM CategoryRule__c WHERE Object__c = :objLabel AND Position__c = null];
        List<String> categories = new List<String>();
        for (CategoryRule__c rule: rules) {
            categories.addAll(rule.Category__c.split(';'));
        }

        // If the object is a Contact, we also check positions
        List<String> positions = new List<String>();
        if (objLabel == Contact.class.getName()) {
            Contact person = [SELECT Id, Positions__c FROM Contact WHERE Id = :recordId];
            positions = person.Positions__c.split(';');

            rules = [SELECT Category__c FROM CategoryRule__c WHERE Object__c = 'Contact' AND Position__c IN :positions];
            for (CategoryRule__c rule: rules) {
                categories.addAll(rule.Category__c.split(';'));
            }
        }
        return categories;
    }
}