public with sharing class LogController {
    @TestVisible
    private static ILogService logService = (ILogService) Application.Service.newInstance(
      ILogService.class
    );

    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getRelatedLogs(Id recordId, String recordType, Integer max) {
        if (max == null) {
            max = 6;
        }
        List<Log__c> logs;
        string objName = recordId.getSObjectType().getDescribe().getName();
        if (objName == Team__c.class.getName()) {
            logs = logService.getTeamLogs(recordId, recordType);
        }
        else {
            logs = logService.getRelatedLogs(recordid, recordType);
        }
        RelatedObjects related = new RelatedObjects();
        related.total = logs.size();
        try {
            for (Integer idx = 0; idx < max && idx < related.total; idx++) {
                Log__c log = logs[idx];
                LogInfo item = new LogInfo();
                item.log = log;
                item.clientName = log.Team__r.Client__r.Name;
                item.facilitatorName = log.Facilitator__r.Name;
                item.handlerName = log.Team__r.Handler__r.Name;
                item.submitterName = log.Submitter__r.Name;
                item.teamName = log.Team__r.Name;
                related.items.add(item);
            }
            return related;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
