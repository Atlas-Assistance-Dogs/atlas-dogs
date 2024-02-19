// use the category rules to see which categories are available for an object and which
// groups can see which category
public without sharing class CategoryRuleController {

    public static List<String> getAllowedCategoriesForUser() {
        List<String> groupNames = UserService.GetGroupNames(UserInfo.getUserId());

        // get the categories that work for the object
        List<CategoryRule__c> rules = [SELECT Category__c, Group__c FROM CategoryRule__c];
        List<String> categories = new List<String>();
        for (CategoryRule__c rule: rules) {
            if (String.isBlank(rule.Group__c) || groupNames.contains(rule.Group__c)) {
                categories.addAll(rule.Category__c.split(';'));
            }
        }
        return categories;
    }

    public static Set<String> getAllowedCategoriesForObject(Id recordId) {
        string objLabel = recordId.getSObjectType().getDescribe().getLabel();

        List<String> groupNames = UserService.GetGroupNames(UserInfo.getUserId());

        // get the categories that work for the object
        List<CategoryRule__c> rules = [SELECT Category__c, Group__c FROM CategoryRule__c WHERE Object__c = :objLabel AND Position__c = null];
        Set<String> categories = new Set<String>();
        for (CategoryRule__c rule: rules) {
            if (String.isBlank(rule.Group__c) || groupNames.contains(rule.Group__c)) {
                categories.addAll(rule.Category__c.split(';'));
            }
        }

        // If the object is a Contact, we also check positions
        List<String> positions = new List<String>();
        if (objLabel == Contact.class.getName()) {
            Contact person = [SELECT Id, Positions__c FROM Contact WHERE Id = :recordId];
            if (person.Positions__c != null) {
                positions = person.Positions__c.split(';');
            }

            rules = [SELECT Category__c, Group__c FROM CategoryRule__c WHERE Object__c = 'Contact' AND Position__c IN :positions];
            for (CategoryRule__c rule: rules) {
                if (String.isBlank(rule.Group__c) || groupNames.contains(rule.Group__c)) {
                    categories.addAll(rule.Category__c.split(';'));
                }
            }
        }
        return categories;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Map<String,String>> getCategoriesForObject(Id recordId) {
        // See what categories the user has access to
        Set<String> categories = getAllowedCategoriesForObject(recordId);

        // Map in the types for each allowed category
        Map<string, string> categoryEntries = FileController.getEntryMap(CategoryRule__c.Category__c.getDescribe());
        List<Map<String,String>> entries = new List<Map<String,String>>();
        for (string category : categories) {
            Map<String,String> entry = new Map<String,String>();
            entries.add(new Map<String, String>{'value' => category, 'label' => categoryEntries.get(category)});
        }
        return entries;
    }
}