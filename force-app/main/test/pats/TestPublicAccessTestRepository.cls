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
private class TestPublicAccessTestRepository {
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
    static void getPassing_returnsEmpty_whenNoPats() {
        PublicAccessTestRepository repo = new PublicAccessTestRepository();
        // Act
        List<PublicAccessTest__c> pats = repo.getPassing(MockProvider.teamids[0]);
        // Assert
        System.assert(pats.isEmpty());
    }

    @isTest
    static void getPassing_returnsEmpty_whenNonePassing() {
        // Arrange
        setup();
        Id teamid = team.id;
        PublicAccessTest__c[] pats = new PublicAccessTest__c[] {
            new PublicAccessTest__c(Team__c = teamid, Status__c = 'Pending Review', Type__c = 'Initial', Location__c = 'In Person', DateCompleted__c = Date.today()),
            new PublicAccessTest__c(Team__c = teamid, Status__c = 'Failed', Type__c = 'Initial', Location__c = 'In Person', DateCompleted__c = Date.today()),
            new PublicAccessTest__c(Team__c = teamid, Status__c = 'Provisionally Passed', Type__c = 'Initial', Location__c = 'In Person', DateCompleted__c = Date.today())
        };
        insert pats;
        PublicAccessTestRepository repo = new PublicAccessTestRepository();
        // Act
        List<PublicAccessTest__c> actual = repo.getPassing(teamid);
        // Assert
        System.assert(actual.isEmpty());
    }

    @isTest
    static void getPassing_returnsOnlyPassing() {
        // Arrange
        setup();
        Id teamid = team.id;
        PublicAccessTest__c[] pats = new PublicAccessTest__c[] {
            new PublicAccessTest__c(Team__c = teamid, Status__c = 'Pending Review', Type__c = 'Initial', Location__c = 'In Person', DateCompleted__c = Date.today()),
            new PublicAccessTest__c(Team__c = teamid, Status__c = 'Failed', Type__c = 'Initial', Location__c = 'In Person', DateCompleted__c = Date.today()),
            new PublicAccessTest__c(Team__c = teamid, Status__c = 'Passed', Type__c = 'Initial', Location__c = 'In Person', DateCompleted__c = Date.today())
        };
        insert pats;
        PublicAccessTestRepository repo = new PublicAccessTestRepository();
        // Act
        List<PublicAccessTest__c> actual = repo.getPassing(teamid);
        // Assert
        System.assertEquals(1, actual.size());
        System.assertEquals(pats[2].id, actual[0].id);
    }

    @isTest
    static void getPassing_ordersByLatest_whenPassing() {
        // Arrange
        setup();
        Id teamid = team.id;
        PublicAccessTest__c[] pats = new PublicAccessTest__c[] {
            new PublicAccessTest__c(Team__c = teamid, Status__c = 'Passed', Type__c = 'Initial', Location__c = 'In Person', DateCompleted__c = Date.today().addYears(-3)),
            new PublicAccessTest__c(Team__c = teamid, Status__c = 'Passed', Type__c = 'Recertification', Location__c = 'In Person', DateCompleted__c = Date.today().addYears(-2)),
            new PublicAccessTest__c(Team__c = teamid, Status__c = 'Passed', Type__c = 'Recertification', Location__c = 'In Person', DateCompleted__c = Date.today().addYears(-1))
        };
        insert pats;
        PublicAccessTestRepository repo = new PublicAccessTestRepository();
        // Act
        List<PublicAccessTest__c> actual = repo.getPassing(teamid);
        // Assert
        System.assertEquals(pats.size(), actual.size());
        Date last = null;
        for (PublicAccessTest__c pat : actual) {
            if (last != null) {
                System.assert(last < pat.DateCompleted__c);
            }
            last = pat.DateCompleted__c;
        }
    }
}