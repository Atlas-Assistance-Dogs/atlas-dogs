// use the category rules to see which categories are available for an object and which
// groups can see which category
global without sharing class CategoryRuleController {
    private static CategoryRuleService service = new CategoryRuleService();
    @TestVisible
    private static void setService(CategoryRuleService service) {
        CategoryRuleController.service = service;
    }

    @AuraEnabled(Cacheable=true)
    global static List<Map<String, String>> getCategoriesForObject(
        Id recordId
    ) {
        return new List<Map<String, String>>();
    }
 
    global static Set<String> getAllowedCategoriesForObject(Id recordId) {
        return service.getAllowedCategoriesForObject(recordId, false);
    }

    public static Set<String> getAllowedCategoriesForObject(Id recordId, Boolean isUpload) {
        return service.getAllowedCategoriesForObject(recordId, isUpload);
    }

    global static Set<String> getCategorySetForObject(Id recordId) {
        return service.getCategorySetForObject(recordId);
    }

    @AuraEnabled(Cacheable=true)
    public static List<Option> getCategoryEntriesForObject(Id recordId, Boolean isUpload) {
        return service.getCategoryEntriesForObject(recordId, isUpload);
    }
}
