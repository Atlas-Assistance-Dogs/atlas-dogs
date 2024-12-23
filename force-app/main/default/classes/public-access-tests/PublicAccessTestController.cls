public with sharing class PublicAccessTestController {
  @AuraEnabled(Cacheable=true)
  public static RelatedObjects getRelatedPats(Id recordId, Integer max) {
    if (max == null) {
      max = 6;
    }
    try {
      RelatedObjects related = new RelatedObjects();
      List<PublicAccessTest__c> pats = [
        SELECT
          Assessor__c,
          AssessorComments__c,
          DateCompleted__c,
          Location__c,
          Name,
          ReviewComments__c,
          Status__c,
          Team__c,
          Type__c,
          ValidUntil__c
        FROM PublicAccessTest__c
        WHERE Assessor__c = :recordId OR Team__c = :recordId
        ORDER BY DateCompleted__c DESC NULLS LAST
        LIMIT :max
      ];
      for (PublicAccessTest__c pat : pats) {
        related.items.add(pat);
      }
      related.total = [
        SELECT COUNT()
        FROM PublicAccessTest__c
        WHERE Assessor__c = :recordId OR Team__c = :recordId
      ];
      return related;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
