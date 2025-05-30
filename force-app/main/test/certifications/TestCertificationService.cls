/**
 * This class contains unit tests for validating the behavior of CertificationService
 */
@isTest
private class TestCertificationService {
  private static MockProvider mocks;
  private static CertificationService service;
  private static EmailService emailSrv;
  private static CertificationRepository certRepo;
  private static CeuRepository ceuRepo;

  // references to mocks
  static void makeData() {
    mocks = new MockProvider();
    emailSrv = (EmailService)mocks.createMock(EmailService.class);
    certRepo = (CertificationRepository)mocks.createMock(CertificationRepository.class);
    ceuRepo = (CeuRepository)mocks.createMock(CeuRepository.class);
    service = new CertificationService(certRepo, emailSrv, ceuRepo);
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
      ceus.add(new CEU__c(
        Authority__c = 'Atlas', 
        Comments__c = 'Comments1', 
        DateCompleted__c = Date.today().addMonths(-1), 
        DateSubmitted__c = Date.today().addMonths(-1), 
        ProgramHours__c = 20, 
        ProgramTitle__c = 'A Day in the Life of a Dog', 
        Quantity__c = 20, 
        Role__c = 'Presenter', 
        Status__c = 'Approved', 
        Contact__c = contactId
      ));
    }

    // act
    Map<Id, List<CEU__c>> actual = service.sortCeus(ceus);
    System.assertEquals(ceus.size(), actual.get(contactId).size(), 'map does not have contact id');
  }

  @isTest
  static void sortCeus_handlesListWithBunchOfContactsCeus() {
    makeData();
    List<Ceu__c> ceus = new List<Ceu__c>();
    for (integer i = 0; i < 5; i++) {
      Id contactId = MockProvider.createId(Contact.class);
      ceus.add(new CEU__c(
        Authority__c = 'Atlas', 
        Comments__c = 'Comments1', 
        DateCompleted__c = Date.today().addMonths(-1), 
        DateSubmitted__c = Date.today().addMonths(-1), 
        ProgramHours__c = 20, 
        ProgramTitle__c = 'A Day in the Life of a Dog', 
        Quantity__c = 20, 
        Role__c = 'Presenter', 
        Status__c = 'Approved', 
        Contact__c = contactId
      ));
    }

    // act
    Map<Id, List<CEU__c>> actual = service.sortCeus(ceus);
    System.assertEquals(ceus.size(), actual.keySet().size(), 'map does not have all contacts');
    for (List<Ceu__c> cs : actual.values()) {
      System.assertEquals(1, cs.size());
    }
  }

  @isTest
  static void sortCertifications_handlesEmptyList() {
    makeData();
    // act
    Map<Id, List<Certification__c>> actual = service.sortCertifications(new List<Certification__c>());
    System.assert(actual.isEmpty(), 'map is not empty');
  }

  @isTest
  static void sortCertifications_handlesListWithOneContactsCertifications() {
    makeData();
    List<Certification__c> certs = new List<Certification__c>();
    Id contactId = MockProvider.createId(Contact.class);
    for (integer i = 0; i < 5; i++) {
      certs.add(new Certification__c(
        Type__c = 'Trainer', 
        Status__c = 'Completed', 
        Start__c = Date.today().addMonths(-1), 
        End__c = Date.today().addMonths(-1), 
        Contact__c = contactId
      ));
    }

    // act
    Map<Id, List<Certification__c>> actual = service.sortCertifications(certs);
    System.assertEquals(certs.size(), actual.get(contactId).size(), 'map does not have contact id');
  }

  @isTest
  static void sortCertifications_handlesListWithBunchOfContactsCertifications() {
    makeData();
    List<Certification__c> certs = new List<Certification__c>();
    for (integer i = 0; i < 5; i++) {
      Id contactId = MockProvider.createId(Contact.class);
      certs.add(new Certification__c(
        Type__c = 'Facilitator', 
        Status__c = 'Active', 
        Start__c = Date.today().addMonths(-1), 
        End__c = Date.today().addMonths(-1), 
        Contact__c = contactId
      ));
    }

    // act
    Map<Id, List<Certification__c>> actual = service.sortCertifications(certs);
    System.assertEquals(certs.size(), actual.keySet().size(), 'map does not have all contacts');
    for (List<Certification__c> cs : actual.values()) {
      System.assertEquals(1, cs.size());
    }
  }

  @isTest
  static void addCeus_stops_whenNoCertifications() {
    makeData();
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getForContacts', new List<Certification__c>()));
    // act
    service.addCeus(new List<Ceu__c>());
    // assert
    MockCallData createCall = mocks.actualCalls[1];
    System.assertEquals('create', createCall.methodName, 'wrong method');
    System.assertEquals(new List<CeuCertification__c>(), createCall.args[0], 'wrong data');
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
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getForContacts', new List<Certification__c>{ new Certification__c(
      Contact__c = contactId, 
      Start__c = startDate, 
      End__c = endDate, 
      Type__c = 'Trainer'
    ) }));
    // act
    service.addCeus(new List<Ceu__c>{ new Ceu__c(
      Contact__c = contactId, 
      DateCompleted__c = ceuDate
    ) });
    // assert
    MockCallData createCall = mocks.actualCalls[1];
    System.assertEquals('create', createCall.methodName, 'wrong method');
    System.assertEquals(new List<CeuCertification__c>(), createCall.args[0], 'wrong data');
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
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getForContacts', new List<Certification__c>{ new Certification__c(
      Contact__c = contactId, 
      Start__c = startDate, 
      End__c = endDate, 
      Type__c = 'Trainer', 
      Id = certId, 
      Status__c = 'Active'
    ) }));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'ceuNotAssignedToCert', true));
    // act
    service.addCeus(new List<Ceu__c>{ new Ceu__c(
      Contact__c = contactId, 
      DateCompleted__c = startDate.addDays(days), 
      Id = ceuId, 
      Quantity__c = 5, 
      Status__c = 'Approved'
    ) });
    // assert
    MockCallData createCall = mocks.actualCalls[2];
    System.assertEquals('create', createCall.methodName, 'wrong method');
    System.assertEquals(new List<CeuCertification__c>{ new CeuCertification__c(
      Ceu__c = ceuId, 
      Certification__c = certId, 
      Approved__c = 5
    ) }, createCall.args[0], 'wrong data');
    System.assertEquals(3, mocks.actualCalls.size(), 'wrong number of calls');
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

  // verify the CEU is added to both certs in range.
  // days is only valid from startDate + 10 to endDate
  static void addCeusAddsConnectorToBothCerts(Integer days, Integer[] matches) {
    makeData();
    Id contactId = MockProvider.createId(Contact.class);
    Date startDate = Date.today().addMonths(-2);
    Date endDate = startDate.addYears(1);
    Id ceuId = MockProvider.createId(Ceu__c.class);
    List<Certification__c> certs = new List<Certification__c>{ new Certification__c(
      Contact__c = contactId, 
      Start__c = startDate, 
      End__c = endDate, 
      Type__c = 'Trainer', 
      Id = MockProvider.createId(Certification__c.class), 
      Status__c = 'Active'
    ), new Certification__c(
      Contact__c = contactId, 
      Start__c = startDate.addDays(10), 
      End__c = endDate.addDays(10), 
      Type__c = 'Facilitator', 
      Id = MockProvider.createId(Certification__c.class), 
      Status__c = 'Active'
    ) };
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getForContacts', certs));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'ceuNotAssignedToCert', true));
    // act
    service.addCeus(new List<Ceu__c>{ new Ceu__c(
      Contact__c = contactId, 
      DateCompleted__c = startDate.addDays(days), 
      Id = ceuId, 
      Quantity__c = 5, 
      Status__c = 'Approved'
    ) });
    // assert
    MockCallData createCall = mocks.actualCalls[mocks.actualCalls.size() - 1];
    System.assertEquals('create', createCall.methodName, 'wrong method');
    List<CeuCertification__c> ccs = (List<CeuCertification__c>)createCall.args[0];
    if (matches == null) {
      System.assertEquals(0, ccs.size(), 'ccs should not be created');
      return;
    }
    System.assertEquals(matches.size(), ccs.size(), 'wrong number of connections');
    for (Integer i = 0; i < matches.size(); i++) {
      System.assertEquals(new CeuCertification__c(
        Ceu__c = ceuId, 
        Certification__c = certs[matches[i]].Id, 
        Approved__c = 5
      ), ccs[i], 'wrong data');
    }
  }

  @isTest
  static void addCeus_addsToBoth_whenCertificationInRange() {
    addCeusAddsConnectorToBothCerts(10, new List<Integer>{ 0, 1 });
  }

  @isTest
  static void addCeus_addsToBoth_whenCertificationInMiddleOfRange() {
    addCeusAddsConnectorToBothCerts(100, new List<Integer>{ 0, 1 });
  }

  @isTest
  static void addCeus_addsToBoth_whenCertificationAtEndOfRange1() {
    addCeusAddsConnectorToBothCerts(365, new List<Integer>{ 0, 1 });
  }

  @isTest
  static void addCeus_addsToNeither_whenCertificationOutOfRange() {
    addCeusAddsConnectorToBothCerts(-1, null);
  }

  @isTest
  static void addCeus_addsToFirst() {
    addCeusAddsConnectorToBothCerts(9, new List<Integer>{ 0 });
  }

  @isTest
  static void addCeus_addsToSecond() {
    addCeusAddsConnectorToBothCerts(366, new List<Integer>{ 1 });
  }

  // verify the CEU is added only to active Certification
  @isTest
  static void addCeus_addsConnectorToActiveCert() {
    makeData();
    Id contactId = MockProvider.createId(Contact.class);
    Date startDate = Date.today().addMonths(-2);
    Date endDate = startDate.addYears(1);
    Id ceuId = MockProvider.createId(Ceu__c.class);
    List<Certification__c> certs = new List<Certification__c>{ new Certification__c(
      Contact__c = contactId, 
      Start__c = startDate, 
      End__c = endDate, 
      Type__c = 'Trainer', 
      Id = MockProvider.createId(Certification__c.class), 
      Status__c = 'Complete'
    ), new Certification__c(
      Contact__c = contactId, 
      Start__c = startDate.addDays(10), 
      End__c = endDate.addDays(10), 
      Type__c = 'Facilitator', 
      Id = MockProvider.createId(Certification__c.class), 
      Status__c = 'Active'
    ) };
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getForContacts', certs));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'ceuNotAssignedToCert', true));
    // act
    service.addCeus(new List<Ceu__c>{ new Ceu__c(
      Contact__c = contactId, 
      DateCompleted__c = startDate.addDays(20), 
      Id = ceuId, 
      Quantity__c = 5, 
      Status__c = 'Approved'
    ) });
    // assert
    MockCallData createCall = mocks.actualCalls[2];
    System.assertEquals('create', createCall.methodName, 'wrong method');
    List<CeuCertification__c> ccs = (List<CeuCertification__c>)createCall.args[0];
    System.assertEquals(3, mocks.actualCalls.size(), 'wrong number of calls');
    System.assertEquals(1, ccs.size(), 'wrong number of connections');
    System.assertEquals(new CeuCertification__c(
      Ceu__c = ceuId, 
      Certification__c = certs[1].Id, 
      Approved__c = 5
    ), ccs[0], 'wrong data');
  }

  @isTest
  static void updateCeus_updatesQuantity_whenPassed() {
    makeData();

    List<CeuCertification__c> ccs = new List<CeuCertification__c>{ new CeuCertification__c(
      Id = MockProvider.createId(CeuCertification__c.class), 
      Approved__c = 2, 
      CEU__r = new Ceu__c(
        Id = MockProvider.createid(Ceu__c.class), 
        Status__c = 'Approved', 
        Quantity__c = 4, 
        DateCompleted__c = Date.today()
      ), Certification__r = new Certification__c(
        Id = MockProvider.createId(Certification__c.class), 
        Start__c = Date.today().addMonths(-1), 
        End__c = Date.today().addMonths(11)
      )
    ), new CeuCertification__c(
      Id = MockProvider.createId(CeuCertification__c.class), 
      Approved__c = 2, 
      CEU__r = new Ceu__c(
        Id = MockProvider.createid(Ceu__c.class), 
        Status__c = 'Pending', 
        Quantity__c = 4, 
        DateCompleted__c = Date.today()
      ), Certification__r = new Certification__c(
        Id = MockProvider.createId(Certification__c.class), 
        Start__c = Date.today().addMonths(-1), 
        End__c = Date.today().addMonths(11)
      )
    ) };
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getCeuCerts', ccs));
    // act
    service.updateCeus(new List<Ceu__c>());
    // assert
    MockCallData updateCall = mocks.actualCalls[1];
    System.assertEquals('modify', updateCall.methodName, 'wrong method');
    List<CeuCertification__c> updatedCcs = (List<CeuCertification__c>)updateCall.args[0];
    System.assertEquals(2, mocks.actualCalls.size(), 'wrong number of calls');
    System.assertEquals(ccs.size(), updatedCcs.size(), 'wrong number of records');
    System.assertEquals(4, updatedCcs[0].Approved__c, 'did not update approved');
    System.assertEquals(0, updatedCcs[1].Approved__c, 'did not reset approved');
  }

  @isTest
  static void updateCeus_updatesConnection_whenDateChanged() {
    makeData();
    Id contactId = MockProvider.createId(Contact.class);
    Certification__c[] certs = new List<Certification__c>{ new Certification__c(
      Id = MockProvider.createId(Certification__c.class), 
      Contact__c = contactId, 
      Start__c = Date.today().addMonths(-14), 
      End__c = Date.today().addMonths(-2)
    ), new Certification__c(
      Id = MockProvider.createId(Certification__c.class), 
      Contact__c = contactId, 
      Start__c = Date.today().addMonths(-2), 
      End__c = Date.today().addMonths(10)
    ) };

    CeuCertification__c cc = new CeuCertification__c(
      Id = MockProvider.createId(CeuCertification__c.class), 
      Approved__c = 2, 
      CEU__r = new Ceu__c(
        Id = MockProvider.createid(Ceu__c.class), 
        Contact__c = contactId, 
        Status__c = 'Approved', 
        Quantity__c = 4, 
        DateCompleted__c = Date.today().addMonths(-3)
      ), Certification__c = certs[1].Id, Certification__r = certs[1]
    );
    List<CeuCertification__c> ccs = new List<CeuCertification__c>{ cc };
    List<Ceu__c> ceus = new List<Ceu__c>{ ccs[0].Ceu__r };
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getCeuCerts', ccs));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getForContacts', certs));
    // act
    service.updateCeus(ceus);
    // assert
    System.assertEquals(ceus, mocks.actualCalls[0].args[0], 'wrong data sent to getCeuCerts');
    List<CeuCertification__c> updated = (List<CeuCertification__c>)mocks.actualCalls[2].args[0];
    System.assertEquals(1, updated.size(), 'wrong number updated');
    CeuCertification__c actual = updated[0];
    System.assertEquals(cc.Id, actual.Id, 'wrong cc');
    System.assertEquals(cc.Ceu__c, actual.Ceu__c, 'wrong CEU');
    System.assertEquals(certs[0].Id, actual.Certification__c, 'wrong certification');
    System.assertEquals(cc.Approved__c, actual.Approved__c, 'approved count changed');
  }

  @isTest
  static void updateCeus_removesConnection_whenDateChangedOutOfCert() {
    makeData();
    Id contactId = MockProvider.createId(Contact.class);
    Certification__c[] certs = new List<Certification__c>{ new Certification__c(
      Id = MockProvider.createId(Certification__c.class), 
      Contact__c = contactId, 
      Start__c = Date.today().addMonths(-14), 
      End__c = Date.today().addMonths(-2)
    ) };

    CeuCertification__c cc = new CeuCertification__c(
      Id = MockProvider.createId(CeuCertification__c.class), 
      Approved__c = 2, 
      CEU__r = new Ceu__c(
        Id = MockProvider.createid(Ceu__c.class), 
        Contact__c = contactId, 
        Status__c = 'Approved', 
        Quantity__c = 4, 
        DateCompleted__c = Date.today().addMonths(1)
      ), Certification__c = certs[0].Id, Certification__r = certs[0]
    );
    List<CeuCertification__c> ccs = new List<CeuCertification__c>{ cc };
    List<Ceu__c> ceus = new List<Ceu__c>{ cc.Ceu__r };
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getCeuCerts', ccs));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getForContacts', certs));
    // act
    service.updateCeus(ceus);
    // assert
    System.assertEquals(ceus, mocks.actualCalls[0].args[0], 'wrong data sent to getCeuCerts');
    System.assertEquals('remove', mocks.actualCalls[2].methodName, 'not removing bad');
    List<CeuCertification__c> deleted = (List<CeuCertification__c>)mocks.actualCalls[2].args[0];
    System.assertEquals(1, deleted.size(), 'wrong number deleted');
    CeuCertification__c actual = deleted[0];
    System.assertEquals(cc.Id, actual.Id, 'wrong cc');
  }

  @isTest
  static void updateCert_creates_whenInitialDate() {
    makeData();
    Contact person = new Contact(
      Id = MockProvider.createId(Contact.class)
    );
    Date certDate = Date.today();
    Certification__c cert = new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Trainer', 
      Status__c = 'Active', 
      Start__c = certDate, 
      End__c = certDate.addYears(1)
    );
    mocks.expectedCalls.add(new MockCallData(certRepo, 'create', cert));
    // act
    Certification__c actual = service.updateCert(person.Id, 'Trainer', certDate, null, null);
    // assert
    System.assertEquals(cert, actual, 'wrong return');
    MockCallData createCall = mocks.actualCalls[0];
    System.assertEquals(cert, createCall.args[0], 'wrong data');
  }

  @isTest
  static void updateCert_creates_whenNone() {
    makeData();
    Contact person = new Contact(
      Id = MockProvider.createId(Contact.class)
    );
    Date certDate = Date.today();
    Certification__c cert = new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Trainer', 
      Status__c = 'Active', 
      Start__c = certDate, 
      End__c = certDate.addYears(1)
    );
    mocks.expectedCalls.add(new MockCallData(certRepo, 'create', cert));
    // act
    Certification__c actual = service.updateCert(person.Id, 'Trainer', null, null, certDate);
    // assert
    System.assertEquals(cert, actual, 'wrong return');
    MockCallData createCall = mocks.actualCalls[0];
    System.assertEquals(cert, createCall.args[0], 'wrong data');
  }

  @isTest
  static void updateCert_returnsNull_whenCertDateUpdatedAfterInitial() {
    makeData();
    Contact person = new Contact(
      Id = MockProvider.createId(Contact.class)
    );
    Date initial = Date.today().addDays(-5);
    Date certDate = Date.today();
    Certification__c cert = new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = certDate.addYears(-1), 
      End__c = certDate
    );
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getActiveCert', null));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'create', cert));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'modify', new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Complete', 
      Start__c = certDate.addYears(-1), 
      End__c = certDate
    )));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'create', new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = certDate, 
      End__c = certDate.addYears(1)
    )));
    // act
    Certification__c actual = service.updateCert(person.Id, 'Facilitator', initial, initial.addYears(1), certDate);
    // assert
    System.assertEquals(null, actual, 'wrong return');
  }

  static void updateCertCompletesAndCreatesNextWithinLeeway(Integer offset) {
    makeData();
    Contact person = new Contact(
      Id = MockProvider.createId(Contact.class)
    );
    Date certDate = Date.today();
    Date initial = Date.today().addYears(-1);
    Certification__c cert = new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = initial, 
      End__c = initial.addYears(1)
    );
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getActiveCert', cert));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'modify', new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Complete', 
      Start__c = initial, 
      End__c = initial.addYears(1)
    )));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'create', new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = initial.addYears(1), 
      End__c = initial.addYears(2)
    )));
    // act
    Certification__c actual = service.updateCert(person.Id, 'Facilitator', initial, initial.addYears(1), certDate.addDays(offset));
    // assert
    System.assertEquals(new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = initial.addYears(1), 
      End__c = initial.addYears(2)
    ), actual, 'wrong return');
    MockCallData modifyCall = mocks.actualCalls[1];
    System.assertEquals('modify', modifyCall.methodName, 'wrong call');
    System.assertEquals(cert, modifyCall.args[0], 'wrong update data');
    MockCallData create = mocks.actualCalls[2];
    System.assertEquals('create', create.methodName, 'wrong call');
    // re-creating the certification object because the method is changing the object returned by the mock
    System.assertEquals(new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = initial.addYears(1), 
      End__c = initial.addYears(2)
    ), create.args[0], 'wrong create arg data');
  }

  @isTest
  static void updateCert_creates_whenOnRenewDate() {
    updateCertCompletesAndCreatesNextWithinLeeway(0);
  }

  @isTest
  static void updateCert_creates_when30DaysEarly() {
    updateCertCompletesAndCreatesNextWithinLeeway(-30);
  }

  @isTest
  static void updateCert_creates_when89DaysEarly() {
    updateCertCompletesAndCreatesNextWithinLeeway(-89);
  }

  @isTest
  static void updateCert_creates_whenSuperLate() {
    updateCertCompletesAndCreatesNextWithinLeeway(30);
  }

  @isTest
  static void updateCertCompletesAndCreatesLaterAfterLeeway() {
    makeData();
    Contact person = new Contact(
      Id = MockProvider.createId(Contact.class)
    );
    Date certDate = Date.today();
    Date newCertDate = certDate.addDays(91);
    Certification__c cert = new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = certDate.addYears(-1), 
      End__c = certDate
    );
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getActiveCert', cert));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'modify', new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Complete', 
      Start__c = certDate.addYears(-1), 
      End__c = certDate
    )));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'create', new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = newCertDate, 
      End__c = newCertDate.addYears(1)
    )));
    // act
    Certification__c actual = service.updateCert(person.Id, 'Facilitator', certDate.addYears(-1), certDate, newCertDate);
    // assert
    System.assertEquals(new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = newCertDate, 
      End__c = newCertDate.addYears(1)
    ), actual, 'wrong return');
    MockCallData modifyCall = mocks.actualCalls[1];
    System.assertEquals('modify', modifyCall.methodName, 'wrong call');
    System.assertEquals(cert, modifyCall.args[0], 'wrong update data');
    MockCallData create = mocks.actualCalls[2];
    System.assertEquals('create', create.methodName, 'wrong call');
    // re-creating the certification object because the method is changing the object returned by the mock
    System.assertEquals(new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = newCertDate, 
      End__c = newCertDate.addYears(1)
    ), create.args[0], 'wrong create arg data');
  }

  @isTest
  static void updateCert_leavesCurrent_whenBeforeLeeway() {
    makeData();
    Contact person = new Contact(
      Id = MockProvider.createId(Contact.class)
    );
    Date certDate = Date.today();
    Date newCertDate = certDate.addDays(-91);
    Certification__c cert = new Certification__c(
      Contact__c = person.Id, 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = certDate.addYears(-1), 
      End__c = certDate
    );
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getActiveCert', cert));
    // act
    Certification__c actual = service.updateCert(person.Id, 'Facilitator', certDate.addYears(-1), certDate, newCertDate);
    // assert
    System.assertEquals(null, actual, 'wrong return');
    System.assertEquals(0, mocks.actualCalls.size(), 'wrong number of calls');
  }

  @isTest
  static void addCeus_addsNothing_whenNoCeus() {
    makeData();
    mocks.expectedCalls.add(new MockCallData(ceuRepo, 'getForContact', new List<Ceu__c>()));
    Id contactId = MockProvider.createId(Contact.class);
    // act
    service.addCeus(new Certification__c(
      Contact__c = contactId
    ));
    // assert
    System.assertEquals(2, mocks.actualCalls.size(), 'wrong number of calls');
    System.assertEquals(contactId, mocks.actualCalls[0].args[0], 'wrong contact id');
    List<CeuCertification__c> ccs = (List<CeuCertification__c>)mocks.actualCalls[1].args[0];
    System.assert(ccs.isEmpty(), 'connections is not empty');
  }

  @isTest
  static void addCeus_addsCeusInRange_whenCertActive() {
    makeData();
    Ceu__c[] ceus = new List<Ceu__c>{ new Ceu__c(
      Id = MockProvider.createId(Ceu__c.class), 
      Status__c = 'Approved', 
      Quantity__c = 4, 
      DateCompleted__c = Date.today()
    ), new Ceu__c(
      Id = MockProvider.createId(Ceu__c.class), 
      Status__c = 'Approved', 
      Quantity__c = 4, 
      DateCompleted__c = Date.today().addYears(-1)
    ), new Ceu__c(
      Id = MockProvider.createId(Ceu__c.class), 
      Status__c = 'Pending', 
      Quantity__c = 4, 
      DateCompleted__c = Date.today()
    ) };
    mocks.expectedCalls.add(new MockCallData(ceuRepo, 'getForContact', ceus));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'ceuNotAssignedToCert', true));
    Id contactId = MockProvider.createId(Contact.class);
    Certification__c cert = new Certification__c(
      Id = MockProvider.createId(Certification__c.class),
      Type__c = 'Trainer',
      Contact__c = contactId, 
      Start__c = Date.today().addMonths(-1), 
      End__c = Date.today().addMonths(11)
    );
    // act
    service.addCeus(cert);
    // assert
    System.assertEquals(4, mocks.actualCalls.size(), 'wrong number of calls');
    System.assertEquals(contactId, mocks.actualCalls[0].args[0], 'wrong contact id');
    List<CeuCertification__c> ccs = (List<CeuCertification__c>)mocks.actualCalls[3].args[0];
    System.assertEquals(2, ccs.size(), 'connections is wrong length');
    CeuCertification__c cc1 = ccs[0];
    System.assertEquals(new CeuCertification__c(
      Ceu__c = ceus[0].Id, 
      Certification__c = cert.Id, 
      Approved__c = 4
    ), cc1, 'wrong data in first cc');
    CeuCertification__c cc2 = ccs[1];
    System.assertEquals(new CeuCertification__c(
      Ceu__c = ceus[2].Id, 
      Certification__c = cert.Id, 
      Approved__c = 0
    ), cc2, 'wrong data in second cc');
  }

  @isTest
  static void addCeus_doesNotAddCeu_whenCeuInAnotherCertActive() {
    makeData();
    Ceu__c[] ceus = new List<Ceu__c>{ new Ceu__c(
      Id = MockProvider.createId(Ceu__c.class), 
      Status__c = 'Approved', 
      Quantity__c = 4, 
      DateCompleted__c = Date.today()
    )};
    mocks.expectedCalls.add(new MockCallData(ceuRepo, 'getForContact', ceus));
    mocks.expectedCalls.add(new MockCallData(certRepo, 'ceuNotAssignedToCert', false));
    Id contactId = MockProvider.createId(Contact.class);
    Certification__c cert = new Certification__c(
      Id = MockProvider.createId(Certification__c.class), 
      Type__c = 'Facilitator',
      Contact__c = contactId, 
      Start__c = Date.today().addMonths(-1), 
      End__c = Date.today().addMonths(11)
    );
    // act
    service.addCeus(cert);
    // assert
    System.assertEquals(3, mocks.actualCalls.size(), 'wrong number of calls');
    System.assertEquals(contactId, mocks.actualCalls[0].args[0], 'wrong contact id');
    System.assertEquals(ceus[0].id, mocks.actualCalls[1].args[0], 'wrong ceu id');
    System.assertEquals(cert.Type__c, mocks.actualCalls[1].args[1], 'wrong cert type');
  }

  @isTest
  static void remindToGetCeus_doesNothing_whenNoCerts() {
    makeData();
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getActiveCerts', new List<Certification__c>()));
    // act
    service.remindToGetCeus();
    // assert
    System.assertEquals(1, mocks.actualCalls.size(), 'too many calls');
  }

  @isTest
  static void remindToGetCeus_email_whenCerts() {
    makeData();
    Certification__c[] certs = new List<Certification__c>{ new Certification__c(
      Contact__c = MockProvider.createId(Contact.class), 
      Type__c = 'Facilitator', 
      Status__c = 'Active', 
      Start__c = Date.today(), 
      End__c = Date.today().addYears(1)
    ), new Certification__c(
      Contact__c = MockProvider.createId(Contact.class), 
      Type__c = 'Trainer', 
      Status__c = 'Active', 
      Start__c = Date.today().addMonths(1), 
      End__c = Date.today().addYears(1).addMonths(1)
    ) };
    Id emailId = MockProvider.createId(OrgWideEmailAddress.class);
    Id facTemplateId = MockProvider.createId(EmailTemplate.class);
    Id trainTemplateId = MockProvider.createId(EmailTemplate.class);
    mocks.expectedCalls.add(new MockCallData(certRepo, 'getActiveCerts', certs));
    mocks.expectedCalls.add(new MockCallData(emailSrv, 'getOrgEmailAddressId', emailId));
    mocks.expectedCalls.add(new MockCallData(emailSrv, 'getTemplate', new EmailTemplate(
      Id = facTemplateId
    )));
    mocks.expectedCalls.add(new MockCallData(emailSrv, 'getTemplate', new EmailTemplate(
      Id = trainTemplateId
    )));
    // act
    service.remindToGetCeus();
    // assert
    System.assertEquals(5, mocks.actualCalls.size(), 'wrong number of calls');
    Messaging.SingleEmailMessage[] messages = (Messaging.SingleEmailMessage[])mocks.actualCalls[4].args[0];
    for (Integer i; i < certs.size(); i++) {
      Messaging.SingleEmailMessage message = messages[i];
      Certification__c cert = certs[i];
      Id templateId = facTemplateId;
      if (i == 1) {
        templateId = trainTemplateId;
      }
      System.assertEquals(emailId, message.orgwideemailaddressid, 'wrong target object');
      System.assertEquals(cert.Contact__c, message.TargetObjectId, 'wrong target object');
      System.assertEquals(cert.Id, message.WhatId, 'wrong target object');
      System.assertEquals(templateId, message.templateid, 'wrong template id');
    }
  }

}