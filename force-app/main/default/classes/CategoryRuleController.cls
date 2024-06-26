// use the category rules to see which categories are available for an object and which
// groups can see which category
global without sharing class CategoryRuleController {

    global static Set<String> getAllowedCategoriesForObject(Id recordId) {
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
    global static List<Map<String, String>> getCategoriesForObject(
        Id recordId
    ) {
        // See what categories the user has access to
        Set<String> categories = getAllowedCategoriesForObject(recordId);

        // Map in the types for each allowed category
        Map<string, string> categoryEntries = FileController.getEntryMap(
            CategoryRule__c.Category__c.getDescribe()
        );
        List<Map<String, String>> entries = new List<Map<String, String>>();
        for (string category : categories) {
            entries.add(
                new Map<String, String>{
                    'value' => category,
                    'label' => categoryEntries.get(category)
                }
            );
        }
        return entries;
    }
}
