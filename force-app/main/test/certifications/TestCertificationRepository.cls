/**
 * This class contains unit tests for validating the behavior of CertificationRepository
 */
@isTest
private class TestCertificationRepository {
  private static CertificationRepository repo = new CertificationRepository();

  @isTest
  static void getForContact_returnsEmpty_whenNullId() {
    List<Certification__c> certs = repo.getForContact(null);
    System.assert(certs.isEmpty(), 'Should be empty');
  }

  @isTest
  static void getForContact_returnsEmpty_whenNotContactId() {
    List<Certification__c> certs = repo.getForContact(
      MockProvider.createId(Account.class)
    );
    System.assert(certs.isEmpty(), 'Should be empty');
  }

  @IsTest
  static void getForContact_returnsEmpty_whenNoCertifications() {
    Contact con = new Contact(FirstName = 'John', LastName = 'Smith');
    insert con;
    List<Certification__c> certs = repo.getForContact(
      MockProvider.createId(Account.class)
    );
    System.assert(certs.isEmpty(), 'Should be empty');
  }

  // Create certification for a contact of both Trainer and Facilitator types
  static private void createCertifications(Contact con1) {
    String status = 'Active';
    Date start = Date.today().addYears(-1).addMonths(3);
    Date ending = start.addYears(1);
    Certification__c[] certs = new List<Certification__c>{
      new Certification__c(
        Status__c = status,
        Contact__c = con1.Id,
        End__c = ending,
        Start__c = start,
        Type__c = 'Trainer'
      ),
      new Certification__c(
        Status__c = status,
        Contact__c = con1.Id,
        End__c = ending.addMonths(1),
        Start__c = start.addMonths(1),
        Type__c = 'Facilitator'
      )
    };

    insert certs;

    CEU__c[] ceus = new List<CEU__c>();
    // Create CEUS for these certs
    for (Integer j = 0; j < 5; j++) {
      Date day = start.addMonths(j + 1);
      ceus.add(
        new Ceu__c(
          Authority__c = 'Atlas',
          Comments__c = 'Comments1',
          DateCompleted__c = day,
          DateSubmitted__c = day,
          ProgramHours__c = 2,
          ProgramTitle__c = 'A Day in the Life of a Dog',
          Quantity__c = 2,
          Role__c = 'Attendee',
          Status__c = 'Approved',
          Contact__c = con1.Id
        )
      );
    }

    insert ceus;
  }

  @IsTest
  static void getForContact_Returns_Certifications() {
    Contact con1 = new Contact(FirstName = 'John', LastName = 'Smith');
    Contact con2 = new Contact(FirstName = 'Sarah', LastName = 'Smith');
    insert new List<Contact>{ con1, con2 };
    createCertifications(con1);
    createCertifications(con2);
    // Act
    List<Certification__c> actual = repo.getForContact(con1.Id);
    // Assert
    System.Assert.areEqual(2, actual.size(), 'Should have 2');
    Certification__c cert = actual[0];
    System.assertEquals(con1.Id, cert.Contact__c);
    System.assertEquals('Active', cert.Status__c);
    System.assertNotEquals(null, cert.Start__c);
    System.assertNotEquals(null, cert.End__c);
    System.assertNotEquals(null, cert.Approved__c);
    System.assertNotEquals(null, cert.Type__c);
  }

  @IsTest
  static void getForContact_Sorts_Certifications() {
    Contact con1 = new Contact(FirstName = 'John', LastName = 'Smith');
    Contact con2 = new Contact(FirstName = 'Sarah', LastName = 'Smith');
    insert new List<Contact>{ con1, con2 };
    createCertifications(con1);
    createCertifications(con2);
    // Act
    List<Certification__c> actual = repo.getForContact(con1.Id);
    // Assert
    System.Assert.areEqual(2, actual.size(), 'Should have 2');
    Certification__c cert1 = actual[0];
    Certification__c cert2 = actual[1];
    System.assert(
      cert1.Start__c >= cert2.Start__c,
      'not reverse sorted by date'
    );
  }

  @IsTest
  static void getForContacts_Sorts_Certifications() {
    Contact con1 = new Contact(FirstName = 'John', LastName = 'Smith');
    Contact con2 = new Contact(FirstName = 'Sarah', LastName = 'Smith');
    insert new List<Contact>{ con1, con2 };
    createCertifications(con1);
    createCertifications(con2);
    // Act
    List<Certification__c> actual = repo.getForContacts(
      new List<Contact>{ con1, con2 }
    );
    // Assert
    System.Assert.areEqual(4, actual.size(), 'Should have 4');
    for (Integer i = 1; i < 4; i++) {
      Certification__c cert1 = actual[i - 1];
      Certification__c cert2 = actual[i];
      System.assert(
        cert1.Start__c >= cert2.Start__c,
        'not reverse sorted by date'
      );
    }
  }

  @IsTest
  static void getForContactsSet_Sorts_Certifications() {
    Contact con1 = new Contact(FirstName = 'John', LastName = 'Smith');
    Contact con2 = new Contact(FirstName = 'Sarah', LastName = 'Smith');
    insert new List<Contact>{ con1, con2 };
    createCertifications(con1);
    createCertifications(con2);
    // Act
    List<Certification__c> actual = repo.getForContacts(
      new Set<Id>{ con1.Id, con2.Id }
    );
    // Assert
    System.Assert.areEqual(4, actual.size(), 'Should have 4');
    for (Integer i = 1; i < 4; i++) {
      Certification__c cert1 = actual[i - 1];
      Certification__c cert2 = actual[i];
      System.assert(
        cert1.Start__c >= cert2.Start__c,
        'not reverse sorted by date'
      );
    }
  }

  @IsTest
  static void createCert_handlesNull() {
    // Act
    Certification__c data = null;
    Certification__c actual = repo.create(data);
    System.assertEquals(null, actual);
  }

  @IsTest
  static void createCert_handlesCert() {
    Contact con1 = new Contact(FirstName = 'John', LastName = 'Smith');
    insert con1;
    Date start = Date.today().addYears(-1).addMonths(3);
    Date ending = start.addYears(1);
    Certification__c cert = new Certification__c(
      Status__c = 'Active',
      Contact__c = con1.Id,
      End__c = ending,
      Start__c = start,
      Type__c = 'Trainer'
    );
    // Act
    Certification__c actual = repo.create(cert);
    System.assertNotEquals(null, actual.Id, 'not created');
  }

  @IsTest
  static void createCerts_handlesNull() {
    List<Certification__c> data = null;
    // Act
    List<Certification__c> actual = repo.create(data);
    System.assertEquals(null, actual);
  }

  @IsTest
  static void createCerts_handlesEmpty() {
    // Act
    List<Certification__c> actual = repo.create(new List<Certification__c>());
    System.assert(actual.isEmpty(), 'not empty');
  }

  @IsTest
  static void createCerts_inserts() {
    Contact con1 = new Contact(FirstName = 'John', LastName = 'Smith');
    insert con1;
    Date start = Date.today().addYears(-1).addMonths(3);
    Date ending = start.addYears(1);
    List<Certification__c> certs = new List<Certification__c>{
      new Certification__c(
        Status__c = 'Active',
        Contact__c = con1.Id,
        End__c = ending,
        Start__c = start,
        Type__c = 'Trainer'
      )
    };
    // Act
    List<Certification__c> actual = repo.create(certs);
    System.assertEquals(1, actual.size(), 'not one element');
  }

  @IsTest
  static void modifyCert_handlesNull() {
    // Act
    Certification__c data = null;
    Certification__c actual = repo.modify(data);
    System.assertEquals(null, actual);
  }

  @IsTest
  static void modifyCert_handlesChange() {
    Contact con1 = new Contact(FirstName = 'John', LastName = 'Smith');
    insert con1;
    Certification__c data = new Certification__c(
      Status__c = 'Active',
      Contact__c = con1.Id,
      End__c = Date.today().addYears(1),
      Start__c = Date.today(),
      Type__c = 'Trainer'
    );
    insert data;
    data.Status__c = 'Complete';
    // Act
    Certification__c actual = repo.modify(data);

    System.assertEquals('Complete', actual.Status__c, 'not modified');
  }

  @IsTest
  static void modifyCerts_handlesNull() {
    List<Certification__c> data = null;
    // Act
    List<Certification__c> actual = repo.modify(data);
    System.assertEquals(null, actual);
  }

  @IsTest
  static void modifyCerts_handlesEmpty() {
    // Act
    List<Certification__c> actual = repo.modify(new List<Certification__c>());
    System.assert(actual.isEmpty(), 'not empty');
  }

  @IsTest
  static void modifyCerts_modifies() {
    Contact con1 = new Contact(FirstName = 'John', LastName = 'Smith');
    insert con1;
    List<Certification__c> certs = new List<Certification__c>{
      new Certification__c(
        Status__c = 'Active',
        Contact__c = con1.Id,
        End__c = Date.today().addYears(1),
        Start__c = Date.today(),
        Type__c = 'Trainer'
      )
    };
    insert certs;
    certs[0].Status__c = 'Complete';
    // Act
    List<Certification__c> actual = repo.modify(certs);
    System.assertEquals(certs[0].Status__c, actual[0].Status__c, 'not updated');
  }

  @IsTest
  static void createCeuCerts_handlesNull() {
    List<CeuCertification__c> data = null;
    // Act
    List<CeuCertification__c> actual = repo.create(data);
    System.assertEquals(null, actual);
  }

  @IsTest
  static void createCeuCerts_handlesEmpty() {
    // Act
    List<CeuCertification__c> actual = repo.create(
      new List<CeuCertification__c>()
    );
    System.assert(actual.isEmpty(), 'not empty');
  }

  @IsTest
  static void createCeuCerts_inserts() {
    CertificationRepositoryData data = new CertificationRepositoryData();
    // Act
    List<CeuCertification__c> actual = repo.create(
      new List<CeuCertification__c>{ data.cc }
    );
    System.assertNotEquals(null, actual[0].Id, 'no id created');
  }

  @IsTest
  static void getCeuCerts_handlesNulls() {
    CeuCertification__c actual = repo.get(null, null);
    System.assertEquals(null, actual, 'returned non-null');
  }

  @IsTest
  static void getCeuCerts_handlesWrongIds() {
    CeuCertification__c actual = repo.get(
      MockProvider.createId(Contact.class),
      MockProvider.createId(Certification__c.class)
    );
    System.assertEquals(null, actual, 'returned non-null');
  }

  @IsTest
  static void getCeuCerts_returnsNulL_whenNoMatch() {
    CertificationRepositoryData data = new CertificationRepositoryData();
    CeuCertification__c actual = repo.get(data.con1.Id, data.cert.Id);
    System.assertEquals(null, actual, 'returned non-null');
  }

  @IsTest
  static void getCeuCerts_returnsMatch_whenExists() {
    CertificationRepositoryData data = new CertificationRepositoryData();
    // the trigger adds a cc
    CeuCertification__c actual = repo.get(data.ceu.Id, data.cert.Id);
    CeuCertification__c[] all = [SELECT Id FROM CeuCertification__c WHERE CEU__c = :data.ceu.Id AND Certification__c = :data.cert.Id];
    System.assertEquals(1, all.size());
    System.assertEquals(data.ceu.Id, actual.Ceu__c);
    System.assertEquals(data.cert.Id, actual.Certification__c);
    System.assertEquals(all[0].Id, actual.Id, 'returned wrong CC');
  }
}
