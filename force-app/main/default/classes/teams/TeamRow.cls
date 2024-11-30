// Class to provide team and related information
public with sharing class TeamRow {
    @AuraEnabled
    public Team__c team { get; set; }
    @AuraEnabled
    public String clientName { get; set; }
    @AuraEnabled
    public String handlerName { get; set; }
    @AuraEnabled
    public String dogName { get; set; }
}
