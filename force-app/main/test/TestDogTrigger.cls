@isTest
public with sharing class TestDogTrigger {
    public TestDogTrigger() {
    }

    @isTest
    static void TestInsertDogWithLatestVaccinesAndExam() {
        // Arrange
        // Create a Dog__c with all latest shots and exam
        Date exam = Date.newInstance(2021, 1, 10);
        Dog__c dog = new Dog__c(
            Name = 'Labrador',
            VaccineLatestDistemper__c = exam,
            VaccineLatestHepatitis__c = exam,
            VaccineLatestParainfluenza__c = exam,
            VaccineLatestParvovirus__c = exam,
            VaccineLatestRabies__c = exam,
            PhysicalExamLatest__c = exam
        );

        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(dog, false);
        Test.stopTest();

        // Assert
        settings = AtlasSettings__c.getOrgDefaults();
        System.assert(result.isSuccess());
        Dog__c saved = [
            SELECT
                VaccineDueDistemper__c,
                VaccineDueHepatitis__c,
                VaccineDueParainfluenza__c,
                VaccineDueParvovirus__c,
                VaccineDueRabies__c,
                PhysicalExamDue__c
            FROM Dog__c
            WHERE id = :result.getId()
        ][0];
        Date vaccineDue = exam.addYears(
            (Integer) settings.VaccineRenewalYears__c
        );
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(vaccineDue, saved.VaccineDueDistemper__c);
        System.assertEquals(vaccineDue, saved.VaccineDueHepatitis__c);
        System.assertEquals(vaccineDue, saved.VaccineDueParainfluenza__c);
        System.assertEquals(vaccineDue, saved.VaccineDueParvovirus__c);
        System.assertEquals(
            exam.addYears((Integer) settings.RabiesRenewalYears__c),
            saved.VaccineDueRabies__c
        );
        System.assertEquals(
            exam.addYears((Integer) settings.DogExamRenewalYears__c),
            saved.PhysicalExamDue__c
        );
    }

    @isTest
    static void TestInsertDogWithNoSettings() {
        // Test data setup
        // Create a Dog__c with all latest shots and exam, but settings not created yet
        Date exam = Date.newInstance(2021, 1, 10);
        Dog__c dog = new Dog__c(
            Name = 'Labrador',
            VaccineLatestDistemper__c = exam,
            VaccineLatestHepatitis__c = exam,
            VaccineLatestParainfluenza__c = exam,
            VaccineLatestParvovirus__c = exam,
            VaccineLatestRabies__c = exam,
            PhysicalExamLatest__c = exam
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(dog, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
        System.assertNotEquals(null, settings);
    }
}
