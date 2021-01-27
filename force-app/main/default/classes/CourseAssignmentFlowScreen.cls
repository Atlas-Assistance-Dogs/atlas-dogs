public with sharing class CourseAssignmentFlowScreen {
    @AuraEnabled(cacheable=true)
    public static List<Course_Master__c> getMasterCourses() {
                return [SELECT Id, Course_Code__c,
                Course_SIS_Section_SIS_Course_Name__c
     FROM Course_Master__c ];
    }
}