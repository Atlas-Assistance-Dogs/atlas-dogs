@isTest
public with sharing class TestDogTrigger {
    public TestDogTrigger() {
    }

    // Create a Dog with all latest shot and exam
    public static Dog__c createDog(Date exam) {
        Dog__c dog = new Dog__c(
            Name = 'Labrador',
            VaccineLatestDistemper__c = exam,
            VaccineLatestHepatitis__c = exam,
            VaccineLatestParainfluenza__c = exam,
            VaccineLatestParvovirus__c = exam,
            VaccineLatestRabies__c = exam,
            PhysicalExamLatest__c = exam
        );
        return dog;
    }

    static Dog__c getDog(Id dogId) {
        Dog__c saved = [
            SELECT
                VaccineDueDistemper__c,
                VaccineDueHepatitis__c,
                VaccineDueParainfluenza__c,
                VaccineDueParvovirus__c,
                VaccineDueRabies__c,
                PhysicalExamDue__c
            FROM Dog__c
            WHERE id = :dogId
        ][0];
        return saved;
    }

    @isTest
    static void InsertWithNoDatesDoesNotSetAny() {
        Dog__c dog = new Dog__c(Name = 'Labrador');

        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(dog, false);
        Test.stopTest();

        // Assert
        settings = AtlasSettings__c.getOrgDefaults();
        System.assert(result.isSuccess());
        Dog__c saved = getDog(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(null, saved.VaccineDueDistemper__c);
        System.assertEquals(null, saved.VaccineDueHepatitis__c);
        System.assertEquals(null, saved.VaccineDueParainfluenza__c);
        System.assertEquals(null, saved.VaccineDueParvovirus__c);
        System.assertEquals(null, saved.VaccineDueRabies__c);
        System.assertEquals(null, saved.PhysicalExamDue__c);
    }

    @isTest
    static void TestInsertDogWithLatestVaccinesAndExam() {
        // Arrange
        // Create a Dog__c with all latest shots and exam
        Date exam = Date.newInstance(2021, 1, 10);
        Dog__c dog = createDog(exam);

        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(dog, false);
        Test.stopTest();

        // Assert
        settings = AtlasSettings__c.getOrgDefaults();
        System.assert(result.isSuccess());
        Dog__c saved = getDog(result.getId());
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
        Dog__c dog = createDog(exam);

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(dog, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
        System.assertNotEquals(null, settings);
    }

    @isTest
    static void UpdateDatesUpdatesRenewals() {
        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;
        Date exam = Date.newInstance(2020, 1, 10);
        Dog__c dog = createDog(exam);
        insert dog;

        exam = Date.newInstance(2021, 1, 9);
        dog = getDog(dog.Id);
        dog.VaccineLatestDistemper__c = exam;
        dog.VaccineLatestHepatitis__c = exam;
        dog.VaccineLatestParainfluenza__c = exam;
        dog.VaccineLatestParvovirus__c = exam;
        dog.VaccineLatestRabies__c = exam;
        dog.PhysicalExamLatest__c = exam;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(dog, false);
        Test.stopTest();

        // Assert
        settings = AtlasSettings__c.getOrgDefaults();
        System.assert(result.isSuccess());
        Dog__c saved = getDog(dog.Id);
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
    static void UpdateWithNoDateChangesLeavesThem() {
        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;
        Date exam = Date.newInstance(2020, 1, 10);
        Dog__c dog = createDog(exam);
        insert dog;

        dog = getDog(dog.Id);
        dog.Name = 'Cookie';

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(dog, false);
        Test.stopTest();

        // Assert
        settings = AtlasSettings__c.getOrgDefaults();
        System.assert(result.isSuccess());
        Dog__c saved = getDog(dog.Id);
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
}
