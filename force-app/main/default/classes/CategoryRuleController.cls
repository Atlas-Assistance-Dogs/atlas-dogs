public with sharing class CategoryRuleController {
    public CategoryRuleController() {

    }

    @AuraEnabled(Cacheable=true)
    public static List<Map<String,String>> getCategoriesForObject(Id recordId) {
        string objLabel = recordId.getSObjectType().getDescribe().getLabel();
        Map<string, string> categoryEntries = FileController.getEntryMap(CategoryRule__c.Category__c.getDescribe());

        List<String> groupNames = UserService.GetGroupNames(UserInfo.getUserId());

        // get the categories that work for the object
        List<CategoryRule__c> rules = [SELECT Category__c, Group__c FROM CategoryRule__c WHERE Object__c = :objLabel AND Position__c = null];
        List<String> categories = new List<String>();
        for (CategoryRule__c rule: rules) {
            if (groupNames.contains(rule.Group__c)) {
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

            rules = [SELECT Category__c FROM CategoryRule__c WHERE Object__c = 'Contact' AND Position__c IN :positions];
            for (CategoryRule__c rule: rules) {
                if (groupNames.contains(rule.Group__c)) {
                    categories.addAll(rule.Category__c.split(';'));
                }
            }
        }

        // See what categories the user has access to
        List<Map<String,String>> entries = new List<Map<String,String>>();
        for (string category : categories) {
            Map<String,String> entry = new Map<String,String>();
            entries.add(new Map<String, String>{'value' => category, 'label' => categoryEntries.get(category)});
        }
        return entries;
    }
}