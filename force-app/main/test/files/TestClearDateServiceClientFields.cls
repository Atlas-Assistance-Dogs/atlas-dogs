@isTest
public with sharing class TestClearDateServiceClientFields {
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
  public static void clearDate_ClientApplication_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'Application'
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
      SELECT ClientApplicationReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientApplicationReceived__c,
      'ClientApplicationReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ClientApplicationVideo_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'ApplicationVideo'
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
      SELECT ClientApplicationVideoReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientApplicationVideoReceived__c,
      'ClientApplicationVideoReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ClientCGCForm_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'CGCForm'
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
      SELECT ClientCGCFormReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientCGCFormReceived__c,
      'ClientCGCFormReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ClientCertAgreement_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'CertAgreement'
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
      SELECT ClientCertAgreementReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientCertAgreementReceived__c,
      'ClientCertAgreementReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ClientLOMI_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'LOMI'
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
      SELECT ClientLOMIReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientLOMIReceived__c,
      'ClientLOMIReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ClientMentalHealthForm_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'MentalHealthForm'
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
      SELECT ClientMentalHealthFormReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientMentalHealthFormReceived__c,
      'ClientMentalHealthFormReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ClientPreApplication_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'PreApplication'
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
      SELECT ClientPreApplicationReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientPreApplicationReceived__c,
      'ClientPreApplicationReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ClientProgAgreement_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'ProgAgreement'
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
      SELECT ClientProgAgreementReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientProgAgreementReceived__c,
      'ClientProgAgreementReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ClientProvRelForm_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'ProvRelForm'
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
      SELECT ClientProvRelFormReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientProvRelFormReceived__c,
      'ClientProvRelFormReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ClientSurvey_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'Survey'
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
      SELECT ClientSurveyReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientSurveyReceived__c,
      'ClientSurveyReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ClientVAPW_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Client',
      Type__c = 'VAPW'
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
      SELECT ClientVAPWReceived__c
      FROM Team__c
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ClientVAPWReceived__c,
      'ClientVAPWReceived__c not cleared'
    );
  }
}
