// This class allows getting the related document for a background check and it's file name
public with sharing class BackgroundCheck {
    @AuraEnabled
    public BackgroundCheck__c check { get; set; }

    @AuraEnabled
    public Id documentId { get; set; }

    @AuraEnabled
    public String fileName { get; set; }

    @AuraEnabled
    public Boolean noFile { get; set; }
}
