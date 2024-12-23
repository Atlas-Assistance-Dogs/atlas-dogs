@IsTest
public with sharing class TestPatTrigger {
  private static Team__c team;
  private static PublicAccessTest__c pat;
  private static Contact ken;
  private static Contact debbie;
  private static Dog__c ace;

  private static void setup(Date expiration) {
    List<Contact> contacts = new List<Contact>();
    debbie = new Contact(FirstName = 'Debbie', LastName = 'Queen');
    ken = new Contact(FirstName = 'Ken', LastName = 'King');
    contacts.add(debbie);
    contacts.add(ken);
    insert contacts;

    ace = new Dog__c(Name = 'Ace');
    insert ace;

    team = new Team__c(
      Client__c = contacts[1].Id,
      Dog__c = ace.Id,
      Handler__c = contacts[0].Id,
      Name = 'Camelot',
      PatValidUntil__c = expiration.addMonths(5),
      PatCount__c = 21,
      PrimaryCertification__c = 'Allergen Alert',
      SecondaryCertification__c = 'Autism'
    );
    insert team;

    pat = new PublicAccessTest__c(
      Assessor__c = ken.Id,
      DateCompleted__c = Date.today(),
      Location__c = 'In Person',
      Status__c = 'Passed',
      Team__c = team.Id,
      Type__c = 'Initial',
      ValidUntil__c = expiration
    );
  }

  private static Contact getContact(Id contactId) {
    return [
      SELECT Id, ClientCertificationValidUntil__c
      FROM Contact
      WHERE Id = :contactId
    ];
  }

  private static Team__c getTeam(Id teamId) {
    return [
      SELECT id, PatValidUntil__c, Client__c, PatCount__c
      FROM Team__c
      WHERE Id = :teamId
      LIMIT 1
    ];
  }

  @isTest
  static void insert_setsValidUntil_whenPatValidSet() {
    Date expiration = Date.today().addMonths(12);
    setup(expiration);

    // Act
    Test.startTest();
    Database.SaveResult result = Database.insert(pat, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    System.assert(result.getErrors().size() == 0);
    Team__c team = getTeam(team.Id);
    Contact contact = getContact(team.Client__c);
    System.assertEquals(expiration, team.PatValidUntil__c);
    System.assertEquals(expiration, contact.ClientCertificationValidUntil__c);
    System.assertEquals(1, team.PatCount__c);
  }

  @isTest
  static void update_updates_whenPatValidSetBackward() {
    Date expiration = Date.today().addMonths(12);
    setup(expiration);
    insert pat;

    pat.ValidUntil__c = Date.today().addDays(200);

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(pat, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    System.assert(result.getErrors().size() == 0);
    Team__c team = getTeam(team.Id);
    Contact contact = getContact(team.Client__c);
    System.assertEquals(pat.ValidUntil__c, team.PatValidUntil__c);
    System.assertEquals(
      contact.ClientCertificationValidUntil__c,
      team.PatValidUntil__c
    );
    System.assertEquals(1, team.PatCount__c);
  }

  @isTest
  static void delete_clears_whenPatDeleted() {
    Date expiration = Date.today().addMonths(12);
    setup(expiration);
    insert pat;

    // Act
    Test.startTest();
    Database.DeleteResult result = Database.delete(pat, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    System.assert(result.getErrors().size() == 0);
    Team__c team = getTeam(team.Id);
    Contact contact = getContact(team.Client__c);
    System.assertEquals(null, team.PatValidUntil__c);
    System.assertEquals(null, contact.ClientCertificationValidUntil__c);
    System.assertEquals(0, team.PatCount__c);
  }

  @isTest
  static void insert_Several_CountsPassing() {
    Date expiration = Date.today().addMonths(12);
    setup(expiration);

    // Insert more
    List<PublicAccessTest__c> pats = new List<PublicAccessTest__c>{
      pat,
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-37),
        Location__c = 'In Person',
        Status__c = 'Failed',
        Team__c = team.Id,
        Type__c = 'Initial'
      ),
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-36),
        Location__c = 'In Person',
        Status__c = 'Passed',
        Team__c = team.Id,
        Type__c = 'Retest',
        ValidUntil__c = Date.today().addMonths(-24)
      ),
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-24),
        Location__c = 'In Person',
        Status__c = 'Passed',
        Team__c = team.Id,
        Type__c = 'Recertification',
        ValidUntil__c = Date.today().addMonths(-12)
      ),
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-12),
        Location__c = 'In Person',
        Status__c = 'Passed',
        Team__c = team.Id,
        Type__c = 'Recertification',
        ValidUntil__c = Date.today()
      )
    };

    // Act
    Test.startTest();
    List<Database.SaveResult> results = Database.insert(pats, false);
    Test.stopTest();

    // Assert
    for (Database.SaveResult result : results) {
      System.assert(result.isSuccess());
      System.assert(result.getErrors().size() == 0);
    }
    Team__c team = getTeam(team.Id);
    Contact contact = getContact(team.Client__c);
    System.assertEquals(expiration, team.PatValidUntil__c);
    System.assertEquals(expiration, contact.ClientCertificationValidUntil__c);
    System.assertEquals(pats.size() - 1, team.PatCount__c);
  }

  @isTest
  static void insert_MultipleTeams_CountsPassing() {
    Date expiration = Date.today().addMonths(12);
    setup(expiration);
    Date expiration2 = Date.today().addMonths(1);

    Team__c team2 = new Team__c(
      Client__c = debbie.Id,
      Dog__c = ace.Id,
      Handler__c = ken.Id,
      Name = 'Deb_Ace',
      PatValidUntil__c = expiration.addMonths(5),
      PatCount__c = 0,
      PrimaryCertification__c = 'Allergen Alert',
      SecondaryCertification__c = 'Autism'
    );
    insert team2;

    // Insert more
    List<PublicAccessTest__c> pats = new List<PublicAccessTest__c>{
      pat,
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-37),
        Location__c = 'In Person',
        Status__c = 'Failed',
        Team__c = team2.Id,
        Type__c = 'Initial'
      ),
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-36),
        Location__c = 'In Person',
        Status__c = 'Passed',
        Team__c = team.Id,
        Type__c = 'Retest',
        ValidUntil__c = Date.today().addMonths(-24)
      ),
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-11),
        Location__c = 'In Person',
        Status__c = 'Passed',
        Team__c = team2.Id,
        Type__c = 'Recertification',
        ValidUntil__c = expiration2
      ),
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-12),
        Location__c = 'In Person',
        Status__c = 'Pending Review',
        Team__c = team.Id,
        Type__c = 'Recertification',
        ValidUntil__c = Date.today()
      )
    };

    // Act
    Test.startTest();
    List<Database.SaveResult> results = Database.insert(pats, false);
    Test.stopTest();

    // Assert
    for (Database.SaveResult result : results) {
      System.assert(result.isSuccess());
      System.assert(result.getErrors().size() == 0);
    }
    Team__c team = getTeam(team.Id);
    Contact contact = getContact(team.Client__c);
    System.assertEquals(expiration, team.PatValidUntil__c);
    System.assertEquals(expiration, contact.ClientCertificationValidUntil__c);
    System.assertEquals(2, team.PatCount__c);

    team = getTeam(team2.Id);
    contact = getContact(team.Client__c);
    System.assertEquals(expiration2, team.PatValidUntil__c);
    System.assertEquals(expiration2, contact.ClientCertificationValidUntil__c);
    System.assertEquals(1, team.PatCount__c);
  }

  @isTest
  static void delete_updatesToLatest_whenPatDeleted() {
    Date expiration = Date.today().addMonths(12);
    setup(expiration);

    // Insert more
    List<PublicAccessTest__c> pats = new List<PublicAccessTest__c>{
      pat,
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-37),
        Location__c = 'In Person',
        Status__c = 'Failed',
        Team__c = team.Id,
        Type__c = 'Initial'
      ),
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-36),
        Location__c = 'In Person',
        Status__c = 'Passed',
        Team__c = team.Id,
        Type__c = 'Retest',
        ValidUntil__c = Date.today().addMonths(-24)
      ),
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today().addMonths(-24),
        Location__c = 'In Person',
        Status__c = 'Passed',
        Team__c = team.Id,
        Type__c = 'Recertification',
        ValidUntil__c = Date.today().addMonths(-12)
      ),
      new PublicAccessTest__c(
        Assessor__c = ken.Id,
        DateCompleted__c = Date.today(),
        Location__c = 'In Person',
        Status__c = 'Passed',
        Team__c = team.Id,
        Type__c = 'Recertification',
        ValidUntil__c = Date.today().addMonths(24)
      )
    };
    insert pats;

    // Act
    Test.startTest();
    Database.DeleteResult result = Database.delete(pats[4], false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    System.assert(result.getErrors().size() == 0);
    Team__c team = getTeam(team.Id);
    Contact contact = getContact(team.Client__c);
    System.assertEquals(expiration, team.PatValidUntil__c);
    System.assertEquals(expiration, contact.ClientCertificationValidUntil__c);
    System.assertEquals(pats.size() - 2, team.PatCount__c);
  }

  @isTest
  static void update_ToDifferentTeam_UpdatesBothTeams() {
    Date expiration = Date.today().addMonths(12);
    setup(expiration);
    insert pat;

    Team__c team2 = new Team__c(
      Client__c = debbie.Id,
      Dog__c = ace.Id,
      Handler__c = ken.Id,
      Name = 'Deb_Ace',
      PatValidUntil__c = expiration.addMonths(5),
      PatCount__c = 0,
      PrimaryCertification__c = 'Allergen Alert',
      SecondaryCertification__c = 'Autism'
    );
    insert team2;

    pat.Team__c = team2.Id;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(pat, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    System.assert(result.getErrors().size() == 0);
    Team__c team = getTeam(team.Id);
    Contact contact = getContact(team.Client__c);
    System.assertEquals(null, team.PatValidUntil__c);
    System.assertEquals(null, contact.ClientCertificationValidUntil__c);
    System.assertEquals(0, team.PatCount__c);

    team = getTeam(team2.Id);
    contact = getContact(team.Client__c);
    System.assertEquals(expiration, team.PatValidUntil__c);
    System.assertEquals(expiration, contact.ClientCertificationValidUntil__c);
    System.assertEquals(1, team.PatCount__c);
  }
}
