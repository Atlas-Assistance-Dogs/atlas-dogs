@isTest
public with sharing class TestDogController {
    public TestDogController() {
    }

    @isTest
    public static void getVaccinations_ReturnsVaccinations() {
        // Arrange
        Date exam = Date.newInstance(2021, 1, 10);
        Date due = exam.addYears(1);
        Dog__c saved = new Dog__c(
            VaccineDueDistemper__c = due,
            VaccineDueHepatitis__c = due,
            VaccineDueParainfluenza__c = due,
            VaccineDueParvovirus__c = due,
            VaccineDueRabies__c = exam.addYears(2)
        );
        insert saved;

        // Act
        Test.startTest();
        Dog__c dog = DogController.getVaccinations(saved.Id);
        Test.stopTest();
    }

    @isTest
    public static void getVaccinations_ReturnsNulls_WhenNoVaccinations() {
        // Arrange
        Dog__c saved = new Dog__c(Name = 'Labrador');
        insert saved;

        // Act
        Test.startTest();
        Dog__c dog = DogController.getVaccinations(saved.Id);
        Test.stopTest();

        System.assertEquals(null, dog.VaccineDueDistemper__c);
        System.assertEquals(null, dog.VaccineDueHepatitis__c);
        System.assertEquals(null, dog.VaccineDueParainfluenza__c);
        System.assertEquals(null, dog.VaccineDueParvovirus__c);
        System.assertEquals(null, dog.VaccineDueRabies__c);
        System.assertEquals(null, dog.PhysicalExamDue__c);
    }

    @isTest
    public static void getVaccinations_ReturnsNotFound_WhenNoDog() {
        // Arrange
        Contact joe = new Contact(FirstName = 'Joe', LastName = 'Blow');
        insert joe;

        // Act
        Test.startTest();
        String message;
        try {
            Dog__c dog = DogController.getVaccinations(joe.Id);
        } catch (AuraHandledException exc) {
            message = exc.getMessage();
        }
        Test.stopTest();

        System.assertEquals('Dog not found.', message);
    }
}
