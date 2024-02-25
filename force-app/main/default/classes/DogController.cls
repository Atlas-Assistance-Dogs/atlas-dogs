public inherited sharing class DogController {
    @AuraEnabled(cacheable=true)
    public static Dog__c getVaccinations(String recordId) {
        try {
            return [
                SELECT
                    Id,
                    VaccineDueDA2PP__c,
                    VaccineDueRabies__c,
                    PhysicalExamDue__c
                FROM Dog__c
                WHERE Id = :recordId
                LIMIT 1
            ];
        } catch (QueryException exc) {
            AuraHandledException ahe = new AuraHandledException('');
            ahe.setMessage('Dog not found.'); // need to use setMessage for custom message
            throw ahe;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Contact[] getOwners(Id[] recordIds){
        try {
            DogRelationship__c[] relatedOwners = [SELECT Contact__c, Contact__r.Name, Contact__r.Id FROM DogRelationship__c WHERE Type__c INCLUDES ('Owner') AND Dog__c in :recordIds];
            Contact[] owners = new List<Contact>(); 
            for (DogRelationship__c dr : relatedOwners) {
                owners.add(dr.Contact__r);
                System.debug(dr.Contact__r);
            }
            return owners;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
