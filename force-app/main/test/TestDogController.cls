@isTest
public with sharing class TestDogController {
    public TestDogController() {
    }

    @isTest
    public static void getVaccinations_ReturnsVaccinations() {
        // Arrange
        Date exam = Date.newInstance(2021, 1, 10);
        Dog__c saved = TestDogTrigger.createDog(exam);
        insert saved;

        // Act
        Test.startTest();
        Dog__c dog = DogController.getVaccinations(saved.Id);
        Test.stopTest();

        System.assertEquals(
            saved.VaccineLatestDistemper__c,
            dog.VaccineLatestDistemper__c
        );
        System.assertEquals(
            saved.VaccineLatestHepatitis__c,
            dog.VaccineLatestHepatitis__c
        );
        System.assertEquals(
            saved.VaccineLatestParainfluenza__c,
            dog.VaccineLatestParainfluenza__c
        );
        System.assertEquals(
            saved.VaccineLatestParvovirus__c,
            dog.VaccineLatestParvovirus__c
        );
        System.assertEquals(
            saved.VaccineLatestRabies__c,
            dog.VaccineLatestRabies__c
        );
        System.assertEquals(
            saved.PhysicalExamLatest__c,
            dog.PhysicalExamLatest__c
        );
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
