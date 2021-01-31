public with sharing class DogHandler{
	@AuraEnabled(cacheable = true)
	public static Dog__c getVaccinatios(String recordId){

		Dog__c dog = new Dog__c();

		dog = [SELECT Id, Most_Recent_Hepatitis_Vaccine__c, Most_Recent_Parainfluenza_Vaccine__c, Most_Recent_Parvovirus_Vaccine__c, Most_Recent_Rabies_Vaccine__c, Most_Recent_Physical_Exam__c
		       FROM Dog__c
		       WHERE Id = :recordId
		       LIMIT 1];

		if (dog != null){
			return dog;
		} else{
			return null;
		}
	}
}