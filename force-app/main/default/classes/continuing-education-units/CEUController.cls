public with sharing class CEUController {
    private static CEURepository repo = new CEURepository();

    @TestVisible
    private static void setRepo(CEURepository crepo) {
        repo = crepo;
    }
    // This method is used by the related list component
    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getRelatedCeus(
        Id contactId, Integer max
    ) {
        if (max == null) {
            max = 6;
        }
        try {
            RelatedObjects related = new RelatedObjects();
            List<CEU__c> ceus = repo.getForContact(contactId, max);
            for (CEU__c ceu : ceus) {
                related.items.add(ceu);
            }
            related.total = repo.getCountForContact(contactId);
            return related;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
