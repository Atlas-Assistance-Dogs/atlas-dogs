// This class allows sending the client and facilitator name along with the log record
public with sharing class LogInfo {
    @AuraEnabled
    public Log__c log { get; set; }

    @AuraEnabled
    public String clientName { get; set; }

    @AuraEnabled
    public String facilitatorName { get; set; }
}
