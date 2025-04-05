public with sharing class CEUController {
  private static CEURepository repo = new CEURepository();

  @TestVisible
  private static void setRepo(CEURepository crepo) {
    repo = crepo;
  }
  // This method is used by the related list component
  @AuraEnabled(Cacheable=true)
  public static RelatedObjects getRelatedCeus(Id recordId, Integer max) {
    if (max == null) {
      max = 6;
    }
    try {
      RelatedObjects related = new RelatedObjects();
      string objName = recordId.getSObjectType().getDescribe().getName();
      List<CEU__c> ceus;
      if (objName == Contact.class.getName()) {
        ceus = repo.getForContact(recordId, max);
        related.total = repo.getCountForContact(recordId);
      } else if (objName == Certification__c.class.getName()) {
        ceus = repo.getForCertification(recordId);
        related.total = ceus.size();
      } else {
        return related;
      }
      for (CEU__c ceu : ceus) {
        related.items.add(ceu);
      }
      return related;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
