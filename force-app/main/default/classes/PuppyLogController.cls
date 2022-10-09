public with sharing class PuppyLogController {
    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getRelatedLogs(id recordId, Integer max) {
        RelatedObjects related = new RelatedObjects();
        try {
            List<PuppyLog__c> logs = [
                SELECT
                    AdditionalInformation__c,
                    Date__c,
                    Dog__c,
                    Dog__r.Name,
                    Name,
                    Raiser__c,
                    Raiser__r.Name,
                    RequestSupportFromAtlas__c
                FROM PuppyLog__c
                WHERE Dog__c = :recordId OR Raiser__c = :recordId
                ORDER BY Date__c DESC NULLS LAST
                LIMIT :max
            ];
            related.items = new List<Object>();
            for (PuppyLog__c log : logs) {
                PuppyLog plog = new PuppyLog();
                plog.log = log;
                plog.dogName = log.Dog__r.Name;
                plog.raiserName = log.Raiser__r.Name;

                RelatedObjects files = FileController.getRelatedFiles(log.Id, 1);
                if (files != null && !files.items.isEmpty()) {
                    ContentVersion cv = (ContentVersion)files.items[0];
                    plog.documentId = cv.ContentDocumentId;
                    plog.fileName = cv.Title;
                    plog.noFile = false;
                }
                else {
                    plog.noFile = true;
                }
                related.items.add(plog);
            }
            
            related.total = [
                SELECT COUNT() FROM PuppyLog__c
                WHERE Dog__c = :recordId OR Raiser__c = :recordId
                ];
            return related;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
