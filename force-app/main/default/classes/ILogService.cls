public interface ILogService {
    List<Log__c> getRelatedLogs(Id recordId, String recordType);
    List<Log__c> getTeamLogs(Id recordId, String recordType);
}
