public interface ILogSelector extends IApplicationSObjectSelector {
    List<Log__c> selectById(Set<Id> idSet);
    Log__c selectById(Id idSet);
    List<Log__c> selectAll();
  }
