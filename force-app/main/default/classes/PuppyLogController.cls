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
                plog.support = log.RequestSupportFromAtlas__c;
                plog.additional = log.AdditionalInformation__c;

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

    @AuraEnabled
    public static String getRaiserReport(Id contactId) {
        // Get the report ID
        List <Report> reportList = [SELECT Id,DeveloperName FROM Report WHERE 
            DeveloperName = 'Puppy_Logs_with_Puppy_Raiser_Report_2te'];
        String reportId = (String)reportList.get(0).get('Id');

        // Get the report metadata
        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);
        Reports.ReportMetadata reportMd = describe.getReportMetadata();

        // Override filter and run report
        Reports.ReportFilter filter = reportMd.getReportFilters()[0];
        filter.setValue(contactId);
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, reportMd);
        Reports.ReportFactWithSummaries factSum = 
            (Reports.ReportFactWithSummaries)results.getFactMap().get('T!T');
        System.debug('Value for November: ' + factSum.getAggregates()[0].getLabel());

        return reportId;
    }
}
