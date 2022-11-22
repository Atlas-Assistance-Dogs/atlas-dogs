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

    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getReport(string name) {
        List<ProgramAssignment__c> pas = [
            SELECT 
                Contact__c, Status__c, AssignedDate__c,
                Contact__r.FirstName, Contact__r.LastName, Contact__r.PreferredName__c, Contact__r.Pronoun__c, Contact__r.PronounOther__c, Contact__r.Email
            FROM ProgramAssignment__c
            WHERE Program__c = :name AND Status__c IN ('In progress', 'Observer', 'Pending')
        ];

        RelatedObjects related = new RelatedObjects();
        related.total = pas.size();

        for (ProgramAssignment__c pa : pas) {
            ProgramReportRow row = new ProgramReportRow();
            row.pa = pa;
            row.contact = pa.Contact__r;
            try {
                DogRelationShip__c relatedDog = [
                    SELECT
                        Dog__c, Dog__r.Name, Dog__r.Age__c, Dog__r.Breed__c, Dog__r.Gender__c
                    FROM DogRelationShip__c
                    WHERE Contact__c = :pa.Contact__c AND Type__c IN ('Owner', 'Client', 'Handler')
                    LIMIT 1
                ];
                row.dog = relatedDog.Dog__r;
                related.items.add(row);
            }
            finally { }
        }
        return related;
    }
}