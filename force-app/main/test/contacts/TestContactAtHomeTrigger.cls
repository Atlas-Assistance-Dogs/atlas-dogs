@isTest
public with sharing class TestContactAtHomeTrigger {
  private static Contact createContact() {
    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      npe01__HomeEmail__c = 'joe-blow@pump.com',
      npe01__AlternateEmail__c = 'joe-blew@pump.com',
      Phone = 'home-phone',
      HomePhone = 'home-phone',
      OtherPhone = 'other-phone',
      Contact__c = 'Home'
    );
    insert joe;
    return joe;
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

  private static void assertEmail(string email, Id contactId) {
    Contact saved = getContact(contactId);
    System.assertEquals(email, saved.Email);
    System.assertEquals(email, saved.npe01__HomeEmail__c);
  }

  @isTest
  static void insert_setsEmail_WhenHomeEmailSetAndContactAtHome() {
    Contact joe = new Contact(
      Email = 'joe@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      npe01__HomeEmail__c = 'joe-blow@pump.com',
      Contact__c = 'Home'
    );

    // Act
    Test.startTest();
    Database.SaveResult result = Database.insert(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    System.assert(result.getErrors().size() == 0);
    assertEmail(joe.npe01__HomeEmail__c, result.getId());
  }

  @isTest
  static void update_setsEmail_WhenHomeEmailSetAndContactAtHome() {
    Contact joe = createContact();

    joe.npe01__HomeEmail__c = 'joe-blow@bikepump.com';

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    System.assert(result.getErrors().size() == 0);
    assertEmail(joe.npe01__HomeEmail__c, result.getId());
  }

  @isTest
  static void update_setsHomeEmail_WhenEmailChangedAndContactAtHome() {
    Contact joe = createContact();

    joe.Email = 'joe-blow@bikepump.com';

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    System.assert(result.getErrors().size() == 0);
    assertEmail(joe.Email, result.getId());
  }

  @isTest
  static void update_leavesEmail_WhenHomeEmailClearedAndContactAtHome() {
    Contact joe = createContact();

    joe.npe01__HomeEmail__c = '';

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.Email, saved.Email);
    System.assert(String.isBlank(saved.npe01__HomeEmail__c));
  }

  @isTest
  static void update_leavesEmail_WhenHomeEmailNullAndContactAtHome() {
    Contact joe = createContact();

    joe.npe01__HomeEmail__c = null;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.Email, saved.Email);
    System.assert(String.isBlank(saved.npe01__HomeEmail__c));
  }

  @isTest
  static void update_leavesHomeEmail_WhenEmailNullAndContactAtHome() {
    Contact joe = createContact();

    joe.Email = null;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.npe01__HomeEmail__c, saved.npe01__HomeEmail__c);
    System.assert(String.isBlank(saved.Email));
  }

  @isTest
  static void update_leavesHomeEmail_WhenEmailBlankAndContactAtHome() {
    Contact joe = createContact();

    joe.Email = ' ';

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.npe01__HomeEmail__c, saved.npe01__HomeEmail__c);
    System.assert(String.isBlank(saved.Email));
  }

  @isTest
  static void update_setsPhone_WhenHomePhoneSetAndContactAtHome() {
    Contact joe = createContact();

    joe.HomePhone = 'vacation-phone';

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.HomePhone, saved.Phone);
    System.assertEquals(joe.HomePhone, saved.HomePhone);
  }

  @isTest
  static void update_setsHomePhone_WhenPhoneChangedAndContactAtHome() {
    Contact joe = createContact();

    joe.Phone = 'vacation-phone';

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.Phone, saved.Phone);
    System.assertEquals(joe.Phone, saved.HomePhone);
  }

  @isTest
  static void update_leavesPhone_WhenHomePhoneClearedAndContactAtHome() {
    Contact joe = createContact();

    joe.HomePhone = '';

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.Phone, saved.Phone);
    System.assert(String.isBlank(saved.HomePhone));
  }

  @isTest
  static void update_leavesPhone_WhenHomePhoneNullAndContactAtHome() {
    Contact joe = createContact();

    joe.HomePhone = null;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.Phone, saved.Phone);
    System.assert(String.isBlank(saved.HomePhone));
  }

  @isTest
  static void update_leavesHomePhone_WhenPhoneNullAndContactAtHome() {
    Contact joe = createContact();

    joe.Phone = null;

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.HomePhone, saved.HomePhone);
    System.assert(String.isBlank(saved.Phone));
  }

  @isTest
  static void update_leavesHomePhone_WhenPhoneBlankAndContactAtHome() {
    Contact joe = createContact();

    joe.Phone = ' ';

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(joe, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    Contact saved = getContact(result.getId());
    System.assert(result.getErrors().size() == 0);
    System.assertEquals(joe.HomePhone, saved.HomePhone);
    System.assert(String.isBlank(saved.Phone));
  }
}
