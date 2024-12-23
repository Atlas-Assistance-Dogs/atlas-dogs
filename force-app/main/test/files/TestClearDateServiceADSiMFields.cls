@isTest
public with sharing class TestClearDateServiceADSiMFields {
  @isTest
  public static void clearDate_ADSiMApplication_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'ADSiM',
      Type__c = 'Application'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT ADSiMApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ADSiMApplicationReceived__c,
      'ADSiMApplicationReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ADSiMPreApplication_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'ADSiM',
      Type__c = 'PreApplication'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT ADSiMPreApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ADSiMPreApplicationReceived__c,
      'ADSiMPreApplicationReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_ADSiMProgAgreement_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'ADSiM',
      Type__c = 'ProgAgreement'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT ADSiMProgAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ADSiMProgAgreementReceived__c,
      'ADSiMProgAgreementReceived__c not cleared'
    );
  }
}
