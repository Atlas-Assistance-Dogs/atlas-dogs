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
                SELECT Contact__c, Date__c, Notes__c, Status__c
                FROM BackgroundCheck__c
                WHERE Contact__c = :contactId
                LIMIT :max
            ];
            related.total = [SELECT Count() FROM BackgroundCheck__c WHERE Contact__c = :contactId];

            for (BackgroundCheck__c bgc : checks) {
                BackgroundCheck outCheck = new BackgroundCheck();
                outCheck.recordId = bgc.Id;
                outCheck.completedDate = bgc.Date__c;
                outCheck.status = bgc.Status__c;
                outCheck.noFile = true;
                RelatedObjects files = FileController.getRelatedFiles(
                    bgc.Id, 1
                );
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
