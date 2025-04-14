/**
 * This class contains unit tests for validating the behavior of TeamRepository.
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
  static void getByStatus_returnsEmptyList_whenNoTeams() {
    TeamRepository repo = new TeamRepository();
    List<Team__c> result = repo.getByStatus('Certified');

    System.assertEquals(new List<Team__c>(), result);
  }
  @isTest
  static void getByStatus_returnsEmptyList_whenStatusDoesntMatch() {
    Team__c team = TestTeam.create();

    TeamRepository repo = new TeamRepository();
    List<Team__c> result = repo.getByStatus('Onboarding');

    System.assertEquals(new List<Team__c>(), result);
  }
  @isTest
  static void getByStatus_returnsEmptyList_whenNoStatusMatches() {
    Team__c team1 = TestTeam.create();
    Team__c team2 = TestTeam.create();
    team2.Status__c = 'In ADSiM';
    update team2;

    TeamRepository repo = new TeamRepository();
    List<Team__c> result = repo.getByStatus('Onboarding');

    System.assertEquals(new List<Team__c>(), result);
  }
  @isTest
  static void getByStatus_returnsOnlyMatch_whenOtherNotMatch() {
    Team__c team1 = TestTeam.create();
    Team__c team2 = TestTeam.create();
    team2.Status__c = 'Onboarding';
    update team2;

    TeamRepository repo = new TeamRepository();
    List<Team__c> result = repo.getByStatus('Certified');
    Team__c team = result[0];

    System.assertEquals(1, result.size());
    System.assertEquals(team1.Id, team.Id);
    System.assertEquals(team1.Client__c, team.Client__c);
    System.assertEquals(team1.TrainingStartDate__c, team.TrainingStartDate__c);
  }
  @isTest
  static void getByStatus_returnsAllMatches_whenOtherStatuses() {
    Team__c team1 = TestTeam.create();
    Team__c team2 = TestTeam.create();
    Team__c team3 = TestTeam.create();
    team2.Status__c = 'Onboarding';
    update team2;

    TeamRepository repo = new TeamRepository();
    List<Team__c> result = repo.getByStatus('Certified');
    Set<Id> teamIds = new Set<Id>();
    for (Team__c team : result) {
      teamIds.add(team.Id);
    }

    System.assertEquals(new Set<Id>{ team1.Id, team3.Id }, teamIds);
  }
  @isTest
  static void create_handlesNull() {
    TeamRepository repo = new TeamRepository();
    Team__c result = repo.create(null);
    System.assertEquals(null, result);
  }
  @isTest
  static void create_inserts() {
    Team__c team1 = TestTeam.create();
    Team__c team = new Team__c(
      Client__c = team1.Handler__c,
      Dog__c = team1.Dog__c,
      Handler__c = team1.Client__c,
      Facilitator__c = null,
      Name = 'Happy Trio',
      PatValidUntil__c = Date.today().addMonths(10),
      PatCount__c = 42,
      PrimaryCertification__c = 'Allergen Alert',
      SecondaryCertification__c = 'Autism',
      Status__c = 'Certified',
      TrainingStartDate__c = Date.today().addMonths(-6)
    );
    TeamRepository repo = new TeamRepository();
    Team__c result = repo.create(team);
    System.assert(null != result);
    System.assert(null != result.Id);
    System.assertEquals(team1.Handler__c, result.Client__c);
    System.assertEquals(team1.Dog__c, result.Dog__c);
    System.assertEquals(team1.Client__c, result.Handler__c);
    System.assertEquals(null, result.Facilitator__c);
    System.assertEquals(team.Name, result.Name);
    System.assertEquals(team.PatCount__c, result.PatCount__c);
    System.assertEquals(team.PatValidUntil__c, result.PatValidUntil__c);
    System.assertEquals(
      team.PrimaryCertification__c,
      result.PrimaryCertification__c
    );
    System.assertEquals(
      team.SecondaryCertification__c,
      result.SecondaryCertification__c
    );
    System.assertEquals(team.Status__c, result.Status__c);
    System.assertEquals(team.TrainingStartDate__c, result.TrainingStartDate__c);
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
