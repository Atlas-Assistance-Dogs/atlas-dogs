/* Methods for finding and updating contacts */
public inherited sharing class ProgramAssignmentController {

    @AuraEnabled(Cacheable=true)
    public static List<ProgramAssignment__c> getProgramAssignments(
        Id contactId
    ) {
        try {
            return [
                SELECT
                    AssignedDate__c,
                    CompletionDate__c,
                    ExpectedCompletion__c,
                    Program__c,
                    Program__r.Name,
                    Program__r.Standalone__c,
                    Status__c
                FROM ProgramAssignment__c
                WHERE Contact__c = :contactId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}