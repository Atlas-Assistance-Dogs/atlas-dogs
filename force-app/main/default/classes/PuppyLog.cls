public with sharing class PuppyLog {
    @AuraEnabled
    public Id recordId { get; set; }

    @AuraEnabled
    public Date logDate { get; set; }

    @AuraEnabled
    public String dogName { get; set; }

    @AuraEnabled
    public Id dogId { get; set; }

    @AuraEnabled
    public String raiserName { get; set; }

    @AuraEnabled
    public Id raiserId { get; set; }

    @AuraEnabled
    public Boolean support { get; set; }

    @AuraEnabled
    public Id documentId { get; set; }

    @AuraEnabled
    public Boolean noFile { get; set; }

    @AuraEnabled
    public String fileName { get; set; }

    @AuraEnabled
    public String additional { get; set; }
}
