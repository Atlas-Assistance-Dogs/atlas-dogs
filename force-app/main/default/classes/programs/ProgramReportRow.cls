public with sharing class ProgramReportRow {
    @AuraEnabled
    public ProgramAssignment__c pa { get; set; }
    @AuraEnabled
    public Contact contact { get; set; }
    @AuraEnabled
    public Dog__c dog { get; set; }
}
