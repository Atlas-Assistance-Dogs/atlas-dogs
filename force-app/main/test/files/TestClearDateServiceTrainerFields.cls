@isTest
public with sharing class TestClearDateServiceTrainerFields {
  @isTest
  public static void clearDate_TrainerApplication_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Trainer',
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
      SELECT TrainerApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.TrainerApplicationReceived__c,
      'TrainerApplicationReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_TrainerCertAgreement_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Trainer',
      Type__c = 'CertAgreement'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT TrainerCertAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.TrainerCertAgreementReceived__c,
      'TrainerCertAgreementReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_TrainerClientReference_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Trainer',
      Type__c = 'ClientReference'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT TrainerClientReferenceReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.TrainerClientReferenceReceived__c,
      'TrainerClientReferenceReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_TrainerInfrNotice_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Trainer',
      Type__c = 'InfrNotice'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT TrainerInfrNoticeReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.TrainerInfrNoticeReceived__c,
      'TrainerInfrNoticeReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_TrainerProfReference_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Trainer',
      Type__c = 'ProfReference'
    );
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ClearDateService.clear(cv, record.Id);

    record = [
      SELECT TrainerProfReferenceReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.TrainerProfReferenceReceived__c,
      'TrainerProfReferenceReceived__c not cleared'
    );
  }

  @isTest
  public static void clearDate_TrainerProgAgreement_SetsDateToNull() {
    ContentVersion cv = new ContentVersion(
      Category__c = 'Trainer',
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
      SELECT TrainerProgAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      null,
      record.TrainerProgAgreementReceived__c,
      'TrainerProgAgreementReceived__c not cleared'
    );
  }
}
