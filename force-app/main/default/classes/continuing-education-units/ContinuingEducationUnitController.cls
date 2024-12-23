public with sharing class ContinuingEducationUnitController {
  // This method is used by the related list component
  @AuraEnabled(Cacheable=true)
  public static RelatedObjects getRelatedCeus(Id contactId, Integer max) {
    if (max == null) {
      max = 6;
    }
    try {
      RelatedObjects related = new RelatedObjects();
      List<ContinuingEducationUnit__c> ceus = [
        SELECT
          Authority__c,
          AuthorityOther__c,
          Comments__c,
          DateCompleted__c,
          DateSubmitted__c,
          Name,
          ProgramDate__c,
          ProgramHours__c,
          ProgramTitle__c,
          Quantity__c,
          Role__c,
          Status__c,
          Trainer__c
        FROM ContinuingEducationUnit__c
        WHERE Trainer__c = :contactId
        LIMIT :max
      ];
      for (ContinuingEducationUnit__c ceu : ceus) {
        related.items.add(ceu);
      }
      related.total = [
        SELECT COUNT()
        FROM ContinuingEducationUnit__c
        WHERE Trainer__c = :contactId
      ];
      return related;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
