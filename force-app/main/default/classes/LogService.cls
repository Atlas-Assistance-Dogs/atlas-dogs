public inherited sharing class LogService implements ILogService {
    private ILogSelector selector;
    public LogService() {
        selector = (ILogSelector) Application.Selector.newInstance(
            Log__c.SObjectType
        );
    }
    public List<Log__c> getAllLogs() {
        return selector.selectAll();
    }
    public List<Log__c> getRelatedLogs(
        Id recordId,
        String recordType
    ) {
        return selector.selectRelated(recordId, recordType);
    }
    public List<Log__c> getTeamLogs(
        Id recordId,
        String recordType
    ) {
        return selector.selectForTeam(recordId, recordType);
    }
}
