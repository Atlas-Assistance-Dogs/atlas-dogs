@isTest
public with sharing class TestClearDateServiceStandaloneFields {
  @isTest
  public static void clearDate_StandaloneApplication_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Standalone',
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
      SELECT StandaloneApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.StandaloneApplicationReceived__c,
      'StandaloneApplicationReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_StandaloneProgAgreement_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Standalone',
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
      SELECT StandaloneProgAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.StandaloneProgAgreementReceived__c,
      'StandaloneProgAgreementReceived__c not cleared'
    );
  }
}
