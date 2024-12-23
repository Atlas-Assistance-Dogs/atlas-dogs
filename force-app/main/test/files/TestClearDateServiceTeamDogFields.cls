@isTest
public with sharing class TestClearDateServiceTeamDogFields {
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
  public static void clearDate_TeamDogHealthForm_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'TeamDog',
      Type__c = 'HealthForm'
    );
    createTeamMembers();
    Team__c record = new Team__c(
      Name = 'Test',
      Client__c = client.Id,
      Dog__c = dog.Id
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT HealthFormReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.HealthFormReceived__c,
      'HealthFormReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_TeamDogXray_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'TeamDog',
      Type__c = 'Xray'
    );
    createTeamMembers();
    Team__c record = new Team__c(
      Name = 'Test',
      Client__c = client.Id,
      Dog__c = dog.Id
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT XrayReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.XrayReceived__c,
      'XrayReceived__c not cleared'
    );
  }
}
