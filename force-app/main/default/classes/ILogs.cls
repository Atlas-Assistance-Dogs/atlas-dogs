public interface ILogs extends IApplicationSObjectDomain {
    Map<String, Boolean> validateUserSso(List<Log__c> logs);
}
