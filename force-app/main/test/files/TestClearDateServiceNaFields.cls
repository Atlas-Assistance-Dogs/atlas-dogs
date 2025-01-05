@isTest
public with sharing class TestClearDateServiceNaFields {
  @isTest
  public static void clearDate_NaContactForm_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Na',
      Type__c = 'ContactForm'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT ContactFormReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.ContactFormReceived__c,
      'ContactFormReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_NaFirstAid_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Na',
      Type__c = 'FirstAid'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT FirstAidReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.FirstAidReceived__c,
      'FirstAidReceived__c not cleared'
    );
  }
}
