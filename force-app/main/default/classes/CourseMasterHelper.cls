public with sharing class CourseMasterHelper {
    @AuraEnabled(cacheable=true)
    public static List<Course_Master__c> getCourseMasterList() {
        return [SELECT Id, Name, Course_Name__c,Course_Code__c,Section_SIS__c,Term_SIS__c,Active__c,
        Common_Course__c,Facilitator_Course__c,Trainer_Course__c
            FROM Course_Master__c];
    }
}