/**
 * This class contains unit tests for validating the behavior of CertificationService
 */
@isTest
private class TestCertificationService {
  private static MockProvider mocks;
  private static CertificationService service;
  private static EmailService emailSrv;
  private static CertificationRepository certRepo;
  // references to mocks

  static void makeData() {
    mocks = new MockProvider();
    emailSrv = (EmailService) mocks.createMock(EmailService.class);
    certRepo = (CertificationRepository) mocks.createMock(
      CertificationRepository.class
    );
    service = new CertificationService(certRepo, emailSrv);
  }

  @isTest
  static void sortCeus_handlesEmptyList() {
    makeData();
    // act
    Map<Id, List<Ceu__c>> actual = service.sortCeus(new List<Ceu__c>());
    System.assert(actual.isEmpty(), 'map is not empty');
  }

  @isTest
  static void sortCeus_handlesListWithOneContactsCeus() {
    makeData();
    List<Ceu__c> ceus = new List<Ceu__c>();
    Id contactId = MockProvider.createId(Contact.class);
    for (integer i = 0; i < 5; i++) {
      ceus.add(
        new CEU__c(
          Authority__c = 'Atlas',
          Comments__c = 'Comments1',
          DateCompleted__c = Date.today().addMonths(-1),
          DateSubmitted__c = Date.today().addMonths(-1),
          ProgramDate__c = Date.today().addDays(-22),
          ProgramHours__c = 20,
          ProgramTitle__c = 'A Day in the Life of a Dog',
          Quantity__c = 20,
          Role__c = 'Presenter',
          Status__c = 'Approved',
          Contact__c = contactId
        )
      );
    }

    // act
    Map<Id, List<CEU__c>> actual = service.sortCeus(ceus);
    System.assertEquals(
      ceus.size(),
      actual.get(contactId).size(),
      'map does not have contact id'
    );
  }

  @isTest
  static void sortCeus_handlesListWithBunchOfContactsCeus() {
    makeData();
    List<Ceu__c> ceus = new List<Ceu__c>();
    for (integer i = 0; i < 5; i++) {
      Id contactId = MockProvider.createId(Contact.class);
      ceus.add(
        new CEU__c(
          Authority__c = 'Atlas',
          Comments__c = 'Comments1',
          DateCompleted__c = Date.today().addMonths(-1),
          DateSubmitted__c = Date.today().addMonths(-1),
          ProgramDate__c = Date.today().addDays(-22),
          ProgramHours__c = 20,
          ProgramTitle__c = 'A Day in the Life of a Dog',
          Quantity__c = 20,
          Role__c = 'Presenter',
          Status__c = 'Approved',
          Contact__c = contactId
        )
      );
    }

    // act
    Map<Id, List<CEU__c>> actual = service.sortCeus(ceus);
    System.assertEquals(
      ceus.size(),
      actual.keySet().size(),
      'map does not have all contacts'
    );
    for (List<Ceu__c> cs : actual.values()) {
      System.assertEquals(1, cs.size());
    }
  }

  @isTest
  static void sortCertifications_handlesEmptyList() {
    makeData();
    // act
    Map<Id, List<Certification__c>> actual = service.sortCertifications(
      new List<Certification__c>()
    );
    System.assert(actual.isEmpty(), 'map is not empty');
  }

  @isTest
  static void sortCertifications_handlesListWithOneContactsCertifications() {
    makeData();
    List<Certification__c> certs = new List<Certification__c>();
    Id contactId = MockProvider.createId(Contact.class);
    for (integer i = 0; i < 5; i++) {
      certs.add(
        new Certification__c(
          Type__c = 'Trainer',
          Status__c = 'Completed',
          Start__c = Date.today().addMonths(-1),
          End__c = Date.today().addMonths(-1),
          Contact__c = contactId
        )
      );
    }

    // act
    Map<Id, List<Certification__c>> actual = service.sortCertifications(certs);
    System.assertEquals(
      certs.size(),
      actual.get(contactId).size(),
      'map does not have contact id'
    );
  }

  @isTest
  static void sortCertifications_handlesListWithBunchOfContactsCertifications() {
    makeData();
    List<Certification__c> certs = new List<Certification__c>();
    for (integer i = 0; i < 5; i++) {
      Id contactId = MockProvider.createId(Contact.class);
      certs.add(
        new Certification__c(
          Type__c = 'Facilitator',
          Status__c = 'Active',
          Start__c = Date.today().addMonths(-1),
          End__c = Date.today().addMonths(-1),
          Contact__c = contactId
        )
      );
    }

    // act
    Map<Id, List<Certification__c>> actual = service.sortCertifications(certs);
    System.assertEquals(
      certs.size(),
      actual.keySet().size(),
      'map does not have all contacts'
    );
    for (List<Certification__c> cs : actual.values()) {
      System.assertEquals(1, cs.size());
    }
  }

  @isTest
  static void addCeus_stops_whenNoCertifications() {
    makeData();
    mocks.expectedCalls.add(
      new MockCallData(certRepo, 'getForContacts', new List<Certification__c>())
    );
    // act
    service.addCeus(new List<Ceu__c>());
    // assert
    MockCallData createCall = mocks.actualCalls[1];
    System.assertEquals('create', createCall.methodName, 'wrong method');
    System.assertEquals(
      new List<CeuCertification__c>(),
      createCall.args[0],
      'wrong data'
    );
    System.assertEquals(2, mocks.actualCalls.size(), 'wrong number of calls');
  }

  static void addCeusDoesNotAddWhenOutside(Integer outside) {
    makeData();
    Id contactId = MockProvider.createId(Contact.class);
    Date startDate = Date.today().addMonths(-2);
    Date endDate = startDate.addYears(1);
    Date ceuDate = endDate.addDays(outside);
    if (outside < 0) {
        ceuDate = startDate.addDays(outside);
    }
    mocks.expectedCalls.add(
      new MockCallData(
        certRepo,
        'getForContacts',
        new List<Certification__c>{
          new Certification__c(
            Contact__c = contactId,
            Start__c = startDate,
            End__c = endDate,
            Type__c = 'Trainer'
          )
        }
      )
    );
    // act
    service.addCeus(
      new List<Ceu__c>{
        new Ceu__c(
          Contact__c = contactId,
          DateCompleted__c = ceuDate
        )
      }
    );
    // assert
    MockCallData createCall = mocks.actualCalls[1];
    System.assertEquals('create', createCall.methodName, 'wrong method');
    System.assertEquals(
      new List<CeuCertification__c>(),
      createCall.args[0],
      'wrong data'
    );
    System.assertEquals(2, mocks.actualCalls.size(), 'wrong number of calls');
  }

  @isTest
  static void addCeus_stops_whenCertificationsDayBefore() {
    addCeusDoesNotAddWhenOutside(-1);
  }

  @isTest
  static void addCeus_stops_whenCertificationsWeekBefore() {
    addCeusDoesNotAddWhenOutside(-7);
  }

  @isTest
  static void addCeus_stops_whenCertificationsDayAfter() {
    addCeusDoesNotAddWhenOutside(1);
  }

  @isTest
  static void addCeus_stops_whenCertificationsMonthsAfter() {
    addCeusDoesNotAddWhenOutside(60);
  }

  static void addCeusAddConnector(Integer days) {
  makeData();
    Id contactId = MockProvider.createId(Contact.class);
    Date startDate = Date.today().addMonths(-2);
    Date endDate = startDate.addYears(1);
    Id certId = MockProvider.createId(Certification__c.class);
    Id ceuId = MockProvider.createId(Ceu__c.class);
    mocks.expectedCalls.add(
      new MockCallData(
        certRepo,
        'getForContacts',
        new List<Certification__c>{
          new Certification__c(
            Contact__c = contactId,
            Start__c = startDate,
            End__c = endDate,
            Type__c = 'Trainer',
            Id = certId
          )
        }
      )
    );
    // act
    service.addCeus(
      new List<Ceu__c>{
        new Ceu__c(
          Contact__c = contactId,
          DateCompleted__c = startDate.addDays(1),
          Id = ceuId,
          Quantity__c = 5,
          Status__c = 'Approved'
        )
      }
    );
    // assert
    MockCallData createCall = mocks.actualCalls[1];
    System.assertEquals('create', createCall.methodName, 'wrong method');
    System.assertEquals(
      new List<CeuCertification__c>{
        new CeuCertification__c(Ceu__c = ceuId, Certification__c = certId, Approved__c = 5)
      },
      createCall.args[0],
      'wrong data'
    );
    System.assertEquals(2, mocks.actualCalls.size(), 'wrong number of calls');
  }

  @isTest
  static void addCeus_adds_whenCertificationInRangeBy1Day() {
    addCeusAddConnector(1);
  }

  @isTest
  static void addCeus_adds_whenCertificationInRangeBy0Days() {
    addCeusAddConnector(0);
  }

  @isTest
  static void addCeus_adds_whenCertificationInRangeBy364Days() {
    addCeusAddConnector(364);
  }

  @isTest
  static void addCeus_adds_whenCertificationInRangeBy365Days() {
    addCeusAddConnector(365);
  }
}
