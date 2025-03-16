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

  // Create certification for 2 contacts of both Trainer and Facilitator
  // types and going back 3 years
  static private void createCertifications(Contact con1, Contact con2) {
    Certification__c[] certs = new List<Certification__c>();
    for (Integer i = 3; i >= 0; i--) {
      for (Certification__c cert : certs) {
        cert.Status__c = 'Complete';
      }
      update certs;

      certs.clear();
      String status = 'Active';
      certs.add(
        new Certification__c(
          Status__c = status,
          Contact__c = con1.Id,
          End__c = Date.today().addYears(-i),
          Start__c = Date.today().addYears(-i + 1),
          Type__c = 'Trainer'
        )
      );
      certs.add(
        new Certification__c(
          Status__c = status,
          Contact__c = con1.Id,
          End__c = Date.today().addYears(-i),
          Start__c = Date.today().addYears(-i + 1),
          Type__c = 'Facilitator'
        )
      );
      certs.add(
        new Certification__c(
          Status__c = status,
          Contact__c = con2.Id,
          End__c = Date.today().addYears(-i),
          Start__c = Date.today().addYears(-i + 1),
          Type__c = 'Trainer'
        )
      );
      certs.add(
        new Certification__c(
          Status__c = status,
          Contact__c = con2.Id,
          End__c = Date.today().addYears(-i),
          Start__c = Date.today().addYears(-i + 1),
          Type__c = 'Facilitator'
        )
      );
      insert certs;

      Certification__c cert = certs[0];
      CEU__c[] ceus = new List<CEU__c>();
      // Create CEUS for these certs
      for (Integer j = 0; j < 5; j++) {
        Date day = cert.Start__c.addMonths(j + 1);
        ceus.add(
          new Ceu__c(
            Authority__c = 'Atlas',
            Comments__c = 'Comments1',
            DateCompleted__c = day,
            DateSubmitted__c = day,
            ProgramDate__c = day,
            ProgramHours__c = 2,
            ProgramTitle__c = 'A Day in the Life of a Dog',
            Quantity__c = 2,
            Role__c = 'Attendee',
            Status__c = 'Approved',
            Contact__c = con2.Id
          )
        );
        ceus.add(
          new Ceu__c(
            Authority__c = 'Atlas',
            Comments__c = 'Comments1',
            DateCompleted__c = day,
            DateSubmitted__c = day,
            ProgramDate__c = day,
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
  }

  @IsTest
  static void getForContact_returnsCertifications() {
    Contact con1 = new Contact(FirstName = 'John', LastName = 'Smith');
    Contact con2 = new Contact(FirstName = 'Sarah', LastName = 'Smith');
    insert new List<Contact>{ con1, con2 };
    createCertifications(con1, con2);
    // Act
    List<Certification__c> actual = repo.getForContact(con1.Id);
    // Assert
    System.Assert.areEqual(6, actual.size(), 'Should have 6');
  }
}
