@isTest
public with sharing class TestFileServiceTeamDogFields {
  private static Dog__c dog;
  private static Contact client;

  private static void createTeamMembers() {
    dog = new Dog__c(Name = 'Fido');
    insert dog;

    client = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert client;
  }

  @isTest
  public static void updateDate_TeamDogHealthForm_SetsDateWhenNull() {
    createTeamMembers();
    Team__c record = new Team__c(
      Name = 'Test',
      Client__c = client.Id,
      Dog__c = dog.Id
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'TeamDog',
      'HealthForm',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT HealthFormReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.HealthFormReceived__c,
      'HealthFormReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_TeamDogHealthForm_SetsDateWhenNewer() {
    createTeamMembers();
    Team__c record = new Team__c(
      Name = 'Test',
      Client__c = client.Id,
      Dog__c = dog.Id,
      HealthFormReceived__c = Date.today().addDays(-1)
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'TeamDog',
      'HealthForm',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT HealthFormReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.HealthFormReceived__c,
      'HealthFormReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_TeamDogHealthForm_LeavesDateWhenOlder() {
    createTeamMembers();
    Team__c record = new Team__c(
      Name = 'Test',
      Client__c = client.Id,
      Dog__c = dog.Id,
      HealthFormReceived__c = Date.today()
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'TeamDog',
      'HealthForm',
      Date.today().addDays(-1),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT HealthFormReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.HealthFormReceived__c,
      'HealthFormReceived__c set to an older date'
    );
  }

  @isTest
  public static void updateDate_TeamDogXray_SetsDateWhenNull() {
    createTeamMembers();
    Team__c record = new Team__c(
      Name = 'Test',
      Client__c = client.Id,
      Dog__c = dog.Id
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'TeamDog',
      'Xray',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT XrayReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.XrayReceived__c,
      'XrayReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_TeamDogXray_SetsDateWhenNewer() {
    createTeamMembers();
    Team__c record = new Team__c(
      Name = 'Test',
      Client__c = client.Id,
      Dog__c = dog.Id,
      XrayReceived__c = Date.today().addDays(-1)
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'TeamDog',
      'Xray',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT XrayReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.XrayReceived__c,
      'XrayReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_TeamDogXray_LeavesDateWhenOlder() {
    createTeamMembers();
    Team__c record = new Team__c(
      Name = 'Test',
      Client__c = client.Id,
      Dog__c = dog.Id,
      XrayReceived__c = Date.today()
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'TeamDog',
      'Xray',
      Date.today().addDays(-1),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT XrayReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.XrayReceived__c,
      'XrayReceived__c set to an older date'
    );
  }
}
