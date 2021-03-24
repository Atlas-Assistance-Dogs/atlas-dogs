public inherited sharing class DogController {
    @AuraEnabled(cacheable=true)
    public static Dog__c getVaccinations(String recordId) {
        return [
            SELECT
                Id,
                Vaccine_Latest_Distemper__c,
                Vaccine_Latest_Hepatitis__c,
                Vaccine_Latest_Parainfluenza__c,
                Vaccine_Latest_Parvovirus__c,
                Vaccine_Latest_Rabies__c,
                Physical_Exam_Latest__c
            FROM Dog__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }
}
