public with sharing class BackgroundCheckController {
  // This method is used by the related list component, and needs more than just the background check
  @AuraEnabled(Cacheable=true)
  public static RelatedObjects getRelatedChecks(Id contactId, Integer max) {
    if (max == null) {
      max = 6;
    }
    try {
      RelatedObjects related = new RelatedObjects();
      List<BackgroundCheck__c> checks = [
        SELECT Name, Contact__c, Date__c, Notes__c, Status__c, Type__c
        FROM BackgroundCheck__c
        WHERE Contact__c = :contactId
        LIMIT :max
      ];
            related.total = [
                SELECT COUNT()
                FROM BackgroundCheck__c
                WHERE Contact__c = :contactId
            ];

      for (BackgroundCheck__c bgc : checks) {
        BackgroundCheck outCheck = new BackgroundCheck();
        outCheck.check = bgc;
        outCheck.noFile = true;
        RelatedObjects files = FileController.getAllRelatedFiles(bgc.Id, 1);
        if (files != null && !files.items.isEmpty()) {
                    FileInfo info = (FileInfo)files.items[0];
          outCheck.documentId = info.cv.ContentDocumentId;
          outCheck.fileName = info.cv.Title;
          outCheck.noFile = false;
        }
        related.items.add(outCheck);
      }
      return related;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
