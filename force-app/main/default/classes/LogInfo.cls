public with sharing class LogInfo {
    @AuraEnabled
    public Log__c log { get; set; }

    @AuraEnabled
    public String clientName { get; set; }
}
