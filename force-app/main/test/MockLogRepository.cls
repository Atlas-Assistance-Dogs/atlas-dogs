@isTest
public class MockLogRepository implements ILogRepository {
    public List<Log__c> logs {get; set;}
    public Log__c create(Log__c team) {
        return team;
    }
    public List<Log__c> recent {get; set;}
    public List<Log__c> getRecent(string status, integer days) {
        return recent;
    }
}
