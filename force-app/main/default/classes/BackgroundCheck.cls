// This class allows getting the related document for a background check and it's file name
public with sharing class BackgroundCheck {
    @AuraEnabled
    public Id recordId { get; set; }

    @AuraEnabled
    public Id documentId { get; set; }

    @AuraEnabled
    public String fileName { get; set; }

    @AuraEnabled
    public String status { get; set; }

    @AuraEnabled
    public Date completedDate { get; set; }
}
