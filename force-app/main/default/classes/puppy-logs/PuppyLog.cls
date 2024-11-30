public with sharing class PuppyLog {
    @AuraEnabled
    public PuppyLog__c log { get; set; }

    @AuraEnabled
    public String dogName { get; set; }

    @AuraEnabled
    public String raiserName { get; set; }

    @AuraEnabled
    public Id documentId { get; set; }

    @AuraEnabled
    public Boolean noFile { get; set; }

    @AuraEnabled
    public String fileName { get; set; }
}
