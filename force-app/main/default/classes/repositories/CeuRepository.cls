public inherited sharing class CeuRepository {
    public CeuRepository() {

    }
    // Get all the CEUs for a contact
    public List<Ceu__c> getForContact(Id contactId, Integer max) {
        return [
                SELECT
                    Authority__c,
                    AuthorityOther__c,
                    Comments__c,
                    DateCompleted__c,
                    DateSubmitted__c,
                    Name,
                    ProgramDate__c,
                    ProgramHours__c,
                    ProgramTitle__c,
                    Quantity__c,
                    Role__c,
                    Status__c,
                    Contact__c
                FROM CEU__c
                WHERE Contact__c = :contactId
                LIMIT :max
            ];
    }
    // Get tho count of CEUs for a contact
    public Integer getContactCount(Id contactId) {
        return [SELECT Count() FROM CEU__c WHERE Contact__c = :contactId];
    }
    // Get CEUs for the contact for the year ending with data
    public List<Ceu__c> getYearEnding(Id contactId, Date completedDate) {
        return [
                SELECT
                    Authority__c,
                    AuthorityOther__c,
                    Comments__c,
                    DateCompleted__c,
                    DateSubmitted__c,
                    Name,
                    ProgramDate__c,
                    ProgramHours__c,
                    ProgramTitle__c,
                    Quantity__c,
                    Role__c,
                    Status__c,
                    Contact__c
                FROM CEU__c
                WHERE Contact__c = :contactId AND Status__c = 'Approved' AND DateCompleted__c <= :completedDate
           ];
    }
    // Update CEUs
    public List<CEU__c> modify(List<CEU__c> ceus) {
        update ceus;
        return ceus;
    }
}