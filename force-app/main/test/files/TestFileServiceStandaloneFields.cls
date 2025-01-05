@isTest
public with sharing class TestFileServiceStandaloneFields {
  @isTest
  public static void updateDate_StandaloneApplication_SetsDateWhenNull() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Standalone',
      'Application',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT StandaloneApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.StandaloneApplicationReceived__c,
      'StandaloneApplicationReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_StandaloneApplication_SetsDateWhenNewer() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      StandaloneApplicationReceived__c = Date.today().addDays(-1)
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Standalone',
      'Application',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT StandaloneApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.StandaloneApplicationReceived__c,
      'StandaloneApplicationReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_StandaloneApplication_LeavesDateWhenOlder() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      StandaloneApplicationReceived__c = Date.today()
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Standalone',
      'Application',
      Date.today().addDays(-1),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT StandaloneApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.StandaloneApplicationReceived__c,
      'StandaloneApplicationReceived__c set to an older date'
    );
  }

  @isTest
  public static void updateDate_StandaloneProgAgreement_SetsDateWhenNull() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Standalone',
      'ProgAgreement',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT StandaloneProgAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.StandaloneProgAgreementReceived__c,
      'StandaloneProgAgreementReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_StandaloneProgAgreement_SetsDateWhenNewer() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      StandaloneProgAgreementReceived__c = Date.today().addDays(-1)
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Standalone',
      'ProgAgreement',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT StandaloneProgAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.StandaloneProgAgreementReceived__c,
      'StandaloneProgAgreementReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_StandaloneProgAgreement_LeavesDateWhenOlder() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      StandaloneProgAgreementReceived__c = Date.today()
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Standalone',
      'ProgAgreement',
      Date.today().addDays(-1),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT StandaloneProgAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.StandaloneProgAgreementReceived__c,
      'StandaloneProgAgreementReceived__c set to an older date'
    );
  }
}
