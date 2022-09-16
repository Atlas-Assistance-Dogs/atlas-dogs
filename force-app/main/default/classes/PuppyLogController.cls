public with sharing class PuppyLogController {
    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getLatestRelatedLogs(id recordId) {
        return getRelatedLogs(recordId, 6);
    }

    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getMaxRelatedLogs(id recordId) {
        return getRelatedLogs(recordId, 10000);
    }

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
                plog.recordId = log.Id;
                plog.logDate = log.Date__c;
                plog.dogId = log.Dog__c;
                plog.dogName = log.Dog__r.Name;
                plog.raiserId = log.Raiser__c;
                plog.raiserName = log.Raiser__r.Name;
                plog.additional = log.AdditionalInformation__c;

                List<ContentVersion> files = FileController.getRelatedFiles(log.Id);
                if (files != null && !files.isEmpty()) {
                    plog.documentId = files[0].ContentDocumentId;
                    plog.fileName = files[0].Title;
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
