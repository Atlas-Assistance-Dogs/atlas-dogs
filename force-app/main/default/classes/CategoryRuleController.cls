// use the category rules to see which categories are available for an object and which
// groups can see which category
global without sharing class CategoryRuleController {
    public static List<String> getAllowedCategoriesForUser() {
        List<String> groupNames = UserAccessService.GetGroupNames(UserInfo.getUserId());

        // get the categories that work for the object
        List<CategoryRule__c> rules = [SELECT Category__c, GroupName__c FROM CategoryRule__c];
        List<String> categories = new List<String>();
        for (CategoryRule__c rule: rules) {
            if (String.isBlank(rule.GroupName__c) || groupNames.contains(rule.GroupName__c)) {
                categories.addAll(rule.Category__c.split(';'));
            }
        }
        return categories;
    }

    @AuraEnabled(Cacheable=true)
    global static List<Map<String, String>> getCategoriesForObject(
        Id recordId
    ) {
        return new List<Map<String, String>>();
    }
 
    global static Set<String> getAllowedCategoriesForObject(Id recordId) {
        return new Set<String>();
    }

    public static Set<String> getAllowedCategoriesForObject(Id recordId, Boolean isUpload) {
        if (isUpload == null) isUpload = false;
        System.debug(isUpload);
        string objLabel = recordId.getSObjectType().getDescribe().getLabel();

        List<String> groupNames = UserAccessService.GetGroupNames(UserInfo.getUserId());

        // get the categories that work for the object from atlas1
        Set<String> allCategories = CategoryRuleController.getCategorySetForObject(recordId);

        Set<String> categories = new Set<String>();
        // only allow the categories that match the groups the user is in
        List<CategoryRule__c> rules = [
            SELECT Category__c, GroupName__c, ReadOnly__c
            FROM CategoryRule__c
            WHERE (GroupName__c IN :groupNames OR GroupName__c = null OR GroupName__c = '')
            AND Object__c = :objLabel
            AND Category__c IN :allCategories
        ];
        for (CategoryRule__c rule: rules) {
            System.debug(rule);
            if (((isUpload && rule.ReadOnly__c != true) || !isUpload) && rule.Category__c != null) {
                categories.addAll(rule.Category__c.split(';'));
            }
        }
        
        return categories;
    }

    global static Set<String> getCategorySetForObject(Id recordId) {
        string objLabel = recordId.getSObjectType().getDescribe().getLabel();

        // get the categories that work for the object
        List<CategoryRule__c> rules = [
            SELECT Category__c
            FROM CategoryRule__c
            WHERE Object__c = :objLabel AND Position__c = NULL
        ];
        Set<String> categories = new Set<String>();
        for (CategoryRule__c rule : rules) {
            categories.addAll(rule.Category__c.split(';'));
        }

        // If the object is a Contact, we also check positions
        List<String> positions = new List<String>();
        if (objLabel == Contact.class.getName()) {
            Contact person = [
                SELECT Id, Positions__c
                FROM Contact
                WHERE Id = :recordId
            ];
            if (person.Positions__c != null) {
                positions = person.Positions__c.split(';');
            }

            rules = [SELECT Category__c FROM CategoryRule__c WHERE Object__c = 'Contact' AND Position__c IN :positions];
            for (CategoryRule__c rule: rules) {
                categories.addAll(rule.Category__c.split(';'));
            }
        }
        return categories;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Option> getCategoryEntriesForObject(Id recordId, Boolean isUpload) {
        // See what categories the user has access to
        Set<String> categories = getAllowedCategoriesForObject(recordId, isUpload);

        // Map in the types for each allowed category
        Map<string, string> categoryEntries = FileController.getEntryMap(CategoryRule__c.Category__c.getDescribe());
        List<Option> entries = new List<Option>();
        for (string category : categories) {
            Option option = new Option(category, categoryEntries.get(category));
            entries.add(option);
        }
        entries.sort();
        System.debug(entries);
        return entries;
    }
}
