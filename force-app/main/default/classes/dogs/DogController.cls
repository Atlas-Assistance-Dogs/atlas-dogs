public inherited sharing class DogController {
  @AuraEnabled(cacheable=true)
  public static Dog__c getVaccinations(String recordId) {
    try {
      return [
        SELECT Id, VaccineDueDA2PP__c, VaccineDueRabies__c, PhysicalExamDue__c
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
}
