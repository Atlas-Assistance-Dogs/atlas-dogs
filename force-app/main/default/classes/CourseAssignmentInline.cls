public with sharing class CourseAssignmentInline {
    @AuraEnabled(cacheable=true)
    public static List<Courses_Taken__c> getAssignedCourse(String accountID) {
                return [SELECT Id, Name,
        Course_Description__c, Assigned_Date__c,
        Expected_Completion_Date__c,
     Course_Completion_Date__c, Status__c
     FROM Courses_Taken__c where Account_Name__c = :accountID];
    }

      @AuraEnabled(Cacheable=true)
    public static List <Account> getAcct(String strName) {
        String strNameLike = '%'+strName+'%';
        List<Account> acctList = [SELECT Id,Full_Name__c
                                   FROM Account
                                   Where Full_Name__c like :strNameLike];
        return acctList; }

}