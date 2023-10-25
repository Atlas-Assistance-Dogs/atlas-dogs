@isTest
public with sharing class TestContactFields {

    @isTest
    public static void facilitatorCertificationValidUntil_incrementsByOneYear_WhenLastAgreementMissing() {
        // Arrange
        Date today = Date.today();
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Positions__c = 'Team Facilitator',
            FacilitatorInitialCertificationDate__c = today.addYears(-1)
        );
        insert joe;
        // Assert
        Contact result = [SELECT FacilitatorCertificationValidUntil__c FROM Contact WHERE Id = :joe.Id];
        System.assertEquals(today, result.FacilitatorCertificationValidUntil__c);
    }

    @isTest
    public static void facilitatorCertificationValidUntil_incrementsByOneYear_WhenLastAgreementTooSoon() {
        // Arrange
        Date today = Date.today();
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Positions__c = 'Team Facilitator',
            FacilitatorInitialCertificationDate__c = today.addYears(-1),
            FacilitatorCertAgreementReceived__c = today.addDays(-91)
        );
        insert joe;
        // Assert
        Contact result = [SELECT FacilitatorCertificationValidUntil__c FROM Contact WHERE Id = :joe.Id];
        System.assertEquals(today, result.FacilitatorCertificationValidUntil__c);
    }

    @isTest
    public static void facilitatorCertificationValidUntil_incrementsByTwoYears_WhenLastAgreementJustPastWindow() {
        // Arrange
        Date today = Date.today();
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Positions__c = 'Team Facilitator',
            FacilitatorInitialCertificationDate__c = today.addYears(-1),
            FacilitatorCertAgreementReceived__c = today.addDays(-89)
        );
        insert joe;
        // Assert
        Contact result = [SELECT FacilitatorCertificationValidUntil__c FROM Contact WHERE Id = :joe.Id];
        System.assertEquals(today.addYears(1), result.FacilitatorCertificationValidUntil__c);
    }

    @isTest
    public static void facilitatorCertificationValidUntil_incrementsByTwoYears_WhenJustBeforeExpiration() {
        // Arrange
        Date today = Date.today();
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Positions__c = 'Team Facilitator',
            FacilitatorInitialCertificationDate__c = today.addYears(-1),
            FacilitatorCertAgreementReceived__c = today.addDays(-1)
        );
        insert joe;
        // Assert
        Contact result = [SELECT FacilitatorCertificationValidUntil__c FROM Contact WHERE Id = :joe.Id];
        System.assertEquals(today.addYears(1), result.FacilitatorCertificationValidUntil__c);
    }

    @isTest
    public static void facilitatorCertificationValidUntil_incrementsByTwoYears_WhenJustAfterExpiration() {
        // Arrange
        Date today = Date.today();
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Positions__c = 'Team Facilitator',
            FacilitatorInitialCertificationDate__c = today.addYears(-1),
            FacilitatorCertAgreementReceived__c = today.addDays(1)
        );
        insert joe;
        // Assert
        Contact result = [SELECT FacilitatorCertificationValidUntil__c FROM Contact WHERE Id = :joe.Id];
        System.assertEquals(today.addYears(1), result.FacilitatorCertificationValidUntil__c);
    }

    @isTest
    public static void trainerCertificationValidUntil_incrementsByOneYear_WhenLastAgreementMissing() {
        // Arrange
        Date today = Date.today();
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Positions__c = 'Trainer',
            TrainerInitialCertificationDate__c = today.addYears(-1)
        );
        insert joe;
        // Assert
        Contact result = [SELECT TrainerCertificationValidUntil__c FROM Contact WHERE Id = :joe.Id];
        System.assertEquals(today, result.TrainerCertificationValidUntil__c);
    }

    @isTest
    public static void trainerCertificationValidUntil_incrementsByOneYear_WhenLastAgreementTooSoon() {
        // Arrange
        Date today = Date.today();
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Positions__c = 'Trainer',
            TrainerInitialCertificationDate__c = today.addYears(-1),
            TrainerCertAgreementReceived__c = today.addDays(-91)
        );
        insert joe;
        // Assert
        Contact result = [SELECT TrainerCertificationValidUntil__c FROM Contact WHERE Id = :joe.Id];
        System.assertEquals(today, result.TrainerCertificationValidUntil__c);
    }

    @isTest
    public static void trainerCertificationValidUntil_incrementsByTwoYears_WhenLastAgreementJustPastWindow() {
        // Arrange
        Date today = Date.today();
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Positions__c = 'Trainer',
            TrainerInitialCertificationDate__c = today.addYears(-1),
            TrainerCertAgreementReceived__c = today.addDays(-89)
        );
        insert joe;
        // Assert
        Contact result = [SELECT TrainerCertificationValidUntil__c FROM Contact WHERE Id = :joe.Id];
        System.assertEquals(today.addYears(1), result.TrainerCertificationValidUntil__c);
    }

    @isTest
    public static void trainerCertificationValidUntil_incrementsByTwoYears_WhenJustBeforeExpiration() {
        // Arrange
        Date today = Date.today();
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Positions__c = 'Trainer',
            TrainerInitialCertificationDate__c = today.addYears(-1),
            TrainerCertAgreementReceived__c = today.addDays(-1)
        );
        insert joe;
        // Assert
        Contact result = [SELECT TrainerCertificationValidUntil__c FROM Contact WHERE Id = :joe.Id];
        System.assertEquals(today.addYears(1), result.TrainerCertificationValidUntil__c);
    }

    @isTest
    public static void trainerCertificationValidUntil_incrementsByTwoYears_WhenJustAfterExpiration() {
        // Arrange
        Date today = Date.today();
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Positions__c = 'Trainer',
            TrainerInitialCertificationDate__c = today.addYears(-1),
            TrainerCertAgreementReceived__c = today.addDays(1)
        );
        insert joe;
        // Assert
        Contact result = [SELECT TrainerCertificationValidUntil__c FROM Contact WHERE Id = :joe.Id];
        System.assertEquals(today.addYears(1), result.TrainerCertificationValidUntil__c);
    }
}