/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestTeamRepository {

    private static Contact joe;
    private static Dog__c boomer;
    private static Team__c team;

    private static void setup() {
        joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Blow',
            ClientStatus__c = 'Onboarding',
            ClientCertificationValidUntil__c = Date.today().addMonths(3));
        insert joe;
        boomer = new Dog__c(Name = 'Boomer', Status__c = 'Onboarding');
        insert boomer;
        team = new Team__c(
            Name = 'Joe_Boomer',
            Client__c = joe.Id,
            Dog__c = boomer.Id
        );
        insert team;
    }

    @isTest
    static void create() {
        // Arrange
        setup();
        Team__c expected = new Team__c(
            Name = 'Joe_Boomer2',
            Client__c = joe.Id,
            Dog__c = boomer.Id,
            Status__c = 'Certified'
        );
        // Act
        TeamRepository repo = new TeamRepository();
        Team__c actual = repo.create(expected);
        // Assert
        System.assertNotEquals(team.Id, actual.Id);
        System.assertNotEquals(null, actual.Id);
        System.assertEquals(expected.Name, actual.Name);
        System.assertEquals(expected.Client__c, actual.Client__c);
        System.assertEquals(expected.Dog__c, actual.Dog__c);
        System.assertEquals(expected.Status__c, actual.Status__c);
    }

    @isTest
    static void getCertificationStatus_returnsUnsetCertificationStatus() {
        // Arrange
        setup();
        // Act
        TeamRepository repo = new TeamRepository();
        Team__c actual = repo.getCertificationStatus(new Set<Id> { team.Id })[0];
        // Assert
        System.assertEquals(joe.Id, actual.Client__c);
        System.assertEquals(null, actual.InitialCertificationDate__c);
        System.assertEquals(null, actual.PatValidUntil__c);
        System.assertEquals(null, actual.PatCount__c);
    }

    @isTest
    static void getCertificationStatus_returnsCertificationStatus() {
        // Arrange
        setup();
        team.InitialCertificationDate__c = Date.today().addDays(-22);
        team.PatValidUntil__c = Date.today().addMonths(10);
        team.PatCount__c = 5;
        update team;
        // Act
        TeamRepository repo = new TeamRepository();
        Team__c actual = repo.getCertificationStatus(new Set<Id> { team.Id })[0];
        // Assert
        System.assertEquals(joe.Id, actual.Client__c);
        System.assertEquals(team.InitialCertificationDate__c, actual.InitialCertificationDate__c);
        System.assertEquals(team.PatValidUntil__c, actual.PatValidUntil__c);
        System.assertEquals(team.PatCount__c, actual.PatCount__c);
    }

    @isTest
    static void modify_updates() {
        // Arrange
        setup();
        team.InitialCertificationDate__c = Date.today().addDays(-22);
        team.PatValidUntil__c = Date.today().addMonths(10);
        team.PatCount__c = 5;
        // Act
        TeamRepository repo = new TeamRepository();
        Team__c[] result = repo.modify(new Team__c[] { team });
        // Assert
        Team__c actual = result[0];
        System.assertEquals(team.InitialCertificationDate__c, actual.InitialCertificationDate__c);
        System.assertEquals(team.PatValidUntil__c, actual.PatValidUntil__c);
        System.assertEquals(team.PatCount__c, actual.PatCount__c);
    }

    @isTest
    static void modify_returnsNull_whenNull() {
        // Act
        TeamRepository repo = new TeamRepository();
        Team__c[] actual = repo.modify(null);
        // Assert
        System.assertEquals(null, actual);
    }

    @isTest
    static void modify_returnsEmpty_whenEmpty() {
        // Act
        TeamRepository repo = new TeamRepository();
        Team__c[] actual = repo.modify(new List<Team__c>());
        // Assert
        System.assert(actual.isEmpty());
    }
}