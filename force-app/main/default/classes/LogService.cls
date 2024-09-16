public inherited sharing class LogService implements ILogService {
    public LogService() {
        ILogSelector LogSelector = (ILogSelector)Application.Selector.newInstance(
            Log__c.SObjectType
        );
        List<Log__c> Logs = LogSelector.selectById(
          new Set<Id>{'SF_RECORD_ID'}
        );       
    }
}