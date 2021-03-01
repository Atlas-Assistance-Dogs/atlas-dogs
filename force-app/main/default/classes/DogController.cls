public inherited sharing class DogController {
  @AuraEnabled(cacheable=true)
  public static Dog__c getVaccinations(String recordId) {
    return [
      SELECT
        Id,
        Most_Recent_Hepatitis_Vaccine__c,
        Most_Recent_Parainfluenza_Vaccine__c,
        Most_Recent_Parvovirus_Vaccine__c,
        Most_Recent_Rabies_Vaccine__c,
        Most_Recent_Physical_Exam__c
      FROM Dog__c
      WHERE Id = :recordId
      LIMIT 1
    ];
  }
}
