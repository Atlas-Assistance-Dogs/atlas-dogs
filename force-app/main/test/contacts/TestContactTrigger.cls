@isTest
public with sharing class TestContactTrigger {
  public TestContactTrigger() {
  }

  private static Contact getContact(Id id) {
    return [
      SELECT
        Email,
        FirstName,
        npe01__HomeEmail__c,
        npe01__AlternateEmail__c,
        Phone,
        HomePhone,
        OtherPhone,
        LastBoardTermStartDate__c,
        BoardTermValidUntil__c
      FROM Contact
      WHERE Id = :id
      LIMIT 1
    ];
  }

  @isTest
  static void insert_LeavesEmailPhone_WhenHomeNotSetAndContactAtEmpty() {
    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      Phone = 'generic-phone'
    );

    // Act
    Test.startTest();
    Database.SaveResult result = Database.insert(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.Email, saved.Email);
    System.assertEquals(joe.Phone, saved.Phone);
    System.assert(string.isBlank(saved.npe01__HomeEmail__c));
    System.assert(string.isBlank(saved.npe01__AlternateEmail__c));
    System.assert(string.isBlank(saved.HomePhone));
    System.assert(string.isBlank(saved.OtherPhone));
  }

  @isTest
  static void update_setsBoardTermEnd_whenStartInJanuary() {
    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      LastBoardTermStartDate__c = null
    );
    insert joe;

    Date start = Date.newInstance(2023, 1, 1);
    joe.LastBoardTermStartDate__c = start;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(
      Date.newInstance(2026, 4, 30),
      saved.BoardTermValidUntil__c
    );
  }

  @isTest
  static void update_setsBoardTermEnd_whenStartInEndMonth() {
    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      LastBoardTermStartDate__c = null
    );
    insert joe;

    Date start = Date.newInstance(2023, 4, 30);
    joe.LastBoardTermStartDate__c = start;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(
      Date.newInstance(2026, 4, 30),
      saved.BoardTermValidUntil__c
    );
  }

  @isTest
  static void update_setsBoardTermEnd_whenStartJuly() {
    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      LastBoardTermStartDate__c = null
    );
    insert joe;

    Date start = Date.newInstance(2022, 7, 4);
    joe.LastBoardTermStartDate__c = start;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(
      Date.newInstance(2026, 4, 30),
      saved.BoardTermValidUntil__c
    );
  }

  @isTest
  static void update_setsBoardTermEnd_whenStartDecember() {
    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      LastBoardTermStartDate__c = null
    );
    insert joe;

    Date start = Date.newInstance(2022, 12, 25);
    joe.LastBoardTermStartDate__c = start;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(
      Date.newInstance(2026, 4, 30),
      saved.BoardTermValidUntil__c
    );
  }

  @isTest
  static void update_setsBoardTermEnd_whenEndMonth0() {
    AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
    settings.BoardTermEndMonth__c = 0;
    upsert settings;

    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      LastBoardTermStartDate__c = null
    );
    insert joe;

    Date start = Date.newInstance(2022, 12, 25);
    joe.LastBoardTermStartDate__c = start;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(
      Date.newInstance(2025, 12, 31),
      saved.BoardTermValidUntil__c
    );
  }

  @isTest
  static void update_setsBoardTermEnd_whenEndMonth6() {
    AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
    settings.BoardTermEndMonth__c = 6;
    upsert settings;

    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      LastBoardTermStartDate__c = null
    );
    insert joe;

    Date start = Date.newInstance(2022, 12, 25);
    joe.LastBoardTermStartDate__c = start;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(
      Date.newInstance(2026, 6, 30),
      saved.BoardTermValidUntil__c
    );
  }

  @isTest
  static void insert_setsFirstAidValidUntil_whenFirstAidSet() {
    AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
    upsert settings;
    Date received = Date.newInstance(2022, 12, 25);

    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      FirstAidReceived__c = received
    );

    // Act
    Test.startTest();
    Database.SaveResult result = Database.insert(joe, true);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = [
      SELECT id, FirstAidValidUntil__c
      FROM Contact
      WHERE id = :result.getId()
    ];
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(received.addYears(2), saved.FirstAidValidUntil__c);
  }

  @isTest
  static void update_setsFirstAidValidUntil_whenFirstAidSet() {
    AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
    upsert settings;
    Date received = Date.newInstance(2022, 12, 25);

    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      FirstAidReceived__c = null,
      FirstAidValidUntil__c = received
    );
    insert joe;

    joe.FirstAidReceived__c = received;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, true);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = [
      SELECT id, FirstAidValidUntil__c
      FROM Contact
      WHERE id = :result.getId()
    ];
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(received.addYears(2), saved.FirstAidValidUntil__c);
  }

  @isTest
  static void update_leavesFirstAidValidUntil_whenValidUntilSet() {
    AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
    upsert settings;
    Date received = Date.newInstance(2022, 12, 25);

    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      FirstAidReceived__c = received,
      FirstAidValidUntil__c = received
    );
    insert joe;

    Date expected = received.addYears(3);
    joe.FirstAidValidUntil__c = expected;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, true);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = [
      SELECT id, FirstAidValidUntil__c
      FROM Contact
      WHERE id = :result.getId()
    ];
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(expected, saved.FirstAidValidUntil__c);
  }

  @isTest
  static void update_leavesFirstAidValidUntil_whenReceivedNotSet() {
    AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
    upsert settings;
    Date received = Date.newInstance(2022, 12, 25);

    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      FirstAidReceived__c = received
    );
    insert joe;

    joe.FirstAidReceived__c = null;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, true);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = [
      SELECT id, FirstAidValidUntil__c
      FROM Contact
      WHERE id = :result.getId()
    ];
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(null, saved.FirstAidValidUntil__c);
  }

  @isTest
  static void update_setsTrainerCertValidUntil_whenFirstCert() {
    AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
    upsert settings;
    Date received = Date.newInstance(2022, 12, 25);

    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      Positions__c = 'Trainer'
    );
    insert joe;

    joe.TrainerCertAgreementReceived__c = received;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, true);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = [
      SELECT id, TrainerInitialCertificationDate__c, TrainerCertValidUntil__c
      FROM Contact
      WHERE id = :result.getId()
    ];
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(received, saved.TrainerInitialCertificationDate__c);
    System.assertEquals(received.addYears(1), saved.TrainerCertValidUntil__c);
  }

  @isTest
  static void update_changesTrainerCertValidUntil_when30daysBefore() {
    AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
    upsert settings;
    Date received = Date.newInstance(2022, 12, 25);

    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      Positions__c = 'Trainer',
      TrainerInitialCertificationDate__c = received,
      TrainerCertAgreementReceived__c = received,
      TrainerCertValidUntil__c = received.addYears(1)
    );
    insert joe;

    joe.TrainerCertAgreementReceived__c = received.addYears(1).addDays(-30);

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, true);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = [
      SELECT id, TrainerInitialCertificationDate__c, TrainerCertValidUntil__c
      FROM Contact
      WHERE id = :result.getId()
    ];
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(received, saved.TrainerInitialCertificationDate__c);
    System.assertEquals(received.addYears(2), saved.TrainerCertValidUntil__c);
  }
}
