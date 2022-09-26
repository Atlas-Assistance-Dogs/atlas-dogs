public with sharing class TeamRow {
    @AuraEnabled
    public Id id { get; set; }
    @AuraEnabled
    public Id client { get; set; }
    @AuraEnabled
    public Id handler { get; set; }
    @AuraEnabled
    public Id dog { get; set; }

    @AuraEnabled
    public String name { get; set; }
    @AuraEnabled
    public String clientName { get; set; }
    @AuraEnabled
    public String handlerName { get; set; }
    @AuraEnabled
    public String dogName { get; set; }
    @AuraEnabled
    public Integer patCount { get; set; }
    @AuraEnabled
    public Date nextPat { get; set; }
    
    @AuraEnabled
    public string certification { get; set; }
}
