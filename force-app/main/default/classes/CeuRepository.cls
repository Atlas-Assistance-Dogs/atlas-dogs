public inherited sharing class CeuRepository {
    public CeuRepository() {

    }
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
    public Integer getContactCount(Id contactId) {
        return [SELECT Count() FROM CEU__c WHERE Contact__c = :contactId];
    }
    public List<Ceu__c> getThisYear(Set<Id> contactIds) {
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
                WHERE Contact__c IN :contactIds AND Status__c = 'Approved' AND DateCompleted__c = LAST_N_DAYS:365
           ];
    }
}