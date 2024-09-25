public interface ILogRepository {
    List<Log__c> getRecent(String recordType, Integer days);
 }