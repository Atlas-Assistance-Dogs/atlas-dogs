@isTest
public with sharing class TestFileServicePuppyFields {
  @isTest
  public static void updateDate_PuppyApplication_SetsDateWhenNull() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'Application',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyApplicationReceived__c,
      'PuppyApplicationReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyApplication_SetsDateWhenNewer() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyApplicationReceived__c = Date.today().addDays(-1)
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'Application',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyApplicationReceived__c,
      'PuppyApplicationReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyApplication_LeavesDateWhenOlder() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyApplicationReceived__c = Date.today()
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'Application',
      Date.today().addDays(-1),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyApplicationReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyApplicationReceived__c,
      'PuppyApplicationReceived__c set to an older date'
    );
  }

  @isTest
  public static void updateDate_PuppyCertAgreement_SetsDateWhenNull() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'CertAgreement',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyCertAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyCertAgreementReceived__c,
      'PuppyCertAgreementReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyCertAgreement_SetsDateWhenNewer() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyCertAgreementReceived__c = Date.today().addDays(-1)
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'CertAgreement',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyCertAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyCertAgreementReceived__c,
      'PuppyCertAgreementReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyCertAgreement_LeavesDateWhenOlder() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyCertAgreementReceived__c = Date.today()
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'CertAgreement',
      Date.today().addDays(-1),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyCertAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyCertAgreementReceived__c,
      'PuppyCertAgreementReceived__c set to an older date'
    );
  }

  @isTest
  public static void updateDate_PuppyContract_SetsDateWhenNull() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'Contract',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyContractReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyContractReceived__c,
      'PuppyContractReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyContract_SetsDateWhenNewer() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyContractReceived__c = Date.today().addDays(-1)
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'Contract',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyContractReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyContractReceived__c,
      'PuppyContractReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyContract_LeavesDateWhenOlder() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyContractReceived__c = Date.today()
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'Contract',
      Date.today().addDays(-1),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyContractReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyContractReceived__c,
      'PuppyContractReceived__c set to an older date'
    );
  }

  @isTest
  public static void updateDate_PuppyInfrNotice_SetsDateWhenNull() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'InfrNotice',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyInfrNoticeReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyInfrNoticeReceived__c,
      'PuppyInfrNoticeReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyInfrNotice_SetsDateWhenNewer() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyInfrNoticeReceived__c = Date.today().addDays(-1)
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'InfrNotice',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyInfrNoticeReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyInfrNoticeReceived__c,
      'PuppyInfrNoticeReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyInfrNotice_LeavesDateWhenOlder() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyInfrNoticeReceived__c = Date.today()
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'InfrNotice',
      Date.today().addDays(-1),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyInfrNoticeReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyInfrNoticeReceived__c,
      'PuppyInfrNoticeReceived__c set to an older date'
    );
  }

  @isTest
  public static void updateDate_PuppyProgAgreement_SetsDateWhenNull() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'ProgAgreement',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyProgAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyProgAgreementReceived__c,
      'PuppyProgAgreementReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyProgAgreement_SetsDateWhenNewer() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyProgAgreementReceived__c = Date.today().addDays(-1)
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'ProgAgreement',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyProgAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyProgAgreementReceived__c,
      'PuppyProgAgreementReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyProgAgreement_LeavesDateWhenOlder() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyProgAgreementReceived__c = Date.today()
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'ProgAgreement',
      Date.today().addDays(-1),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyProgAgreementReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyProgAgreementReceived__c,
      'PuppyProgAgreementReceived__c set to an older date'
    );
  }

  @isTest
  public static void updateDate_PuppyReference_SetsDateWhenNull() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com'
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'Reference',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyReferenceReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyReferenceReceived__c,
      'PuppyReferenceReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyReference_SetsDateWhenNewer() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyReferenceReceived__c = Date.today().addDays(-1)
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'Reference',
      Date.today(),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyReferenceReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyReferenceReceived__c,
      'PuppyReferenceReceived__c not set'
    );
  }

  @isTest
  public static void updateDate_PuppyReference_LeavesDateWhenOlder() {
    Contact record = new Contact(
      FirstName = 'Test',
      LastName = 'Contact',
      Email = 'abc@abc.com',
      PuppyReferenceReceived__c = Date.today()
    );
    insert record;
    ContentVersion cv = TestFileServiceFields.createLink(
      'Puppy',
      'Reference',
      Date.today().addDays(-1),
      record.Id
    );
    FileService.updateDate(cv, record.Id);

    record = [
      SELECT PuppyReferenceReceived__c
      FROM Contact
      WHERE Id = :record.Id
      LIMIT 1
    ];
    system.assertEquals(
      Date.today(),
      record.PuppyReferenceReceived__c,
      'PuppyReferenceReceived__c set to an older date'
    );
  }
}
