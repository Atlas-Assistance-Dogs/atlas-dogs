@isTest
public with sharing class TestClearDateServiceVolunteerFields {
  @isTest
  public static void clearDate_VolunteerAgreement_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Volunteer',
      Type__c = 'Agreement'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT VolunteerAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.VolunteerAgreementReceived__c,
      'VolunteerAgreementReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_VolunteerApplication_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Volunteer',
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
      SELECT VolunteerApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.VolunteerApplicationReceived__c,
      'VolunteerApplicationReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_VolunteerResume_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Volunteer',
      Type__c = 'Resume'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT VolunteerResumeReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.VolunteerResumeReceived__c,
      'VolunteerResumeReceived__c not cleared'
    );
  }
}
