public inherited sharing class DogController {
    @AuraEnabled(cacheable=true)
    public static Dog__c getVaccinations(String recordId) {
        return [
            SELECT
                Id,
                VaccineLatestDistemper__c,
                VaccineLatestHepatitis__c,
                VaccineLatestParainfluenza__c,
                VaccineLatestParvovirus__c,
                VaccineLatestRabies__c,
                PhysicalExamLatest__c
            FROM Dog__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }
}
