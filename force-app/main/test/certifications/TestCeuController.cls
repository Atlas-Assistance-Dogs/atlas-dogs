@isTest
public with sharing class TestCeuController {
  private static Contact ace;
  private static Contact cookie;
  private static CEU__c aceCeu;
  private static CEU__c cookieCeu1;
  private static CEU__c cookieCeu2;

  static void setup() {
    List<Contact> contacts = new List<Contact>();
    ace = new Contact(FirstName = 'Ace', LastName = 'GSD');
    cookie = new Contact(FirstName = 'Cookie', LastName = 'Monster');
    contacts.add(ace);
    contacts.add(cookie);
    insert contacts;

    List<CEU__c> ceus = new List<CEU__c>();
    aceCeu = new CEU__c(
      Authority__c = 'Atlas',
      Comments__c = 'Comments1',
      DateCompleted__c = Date.today().addMonths(-1),
      DateSubmitted__c = Date.today().addMonths(-1),
      ProgramHours__c = 20,
      ProgramTitle__c = 'A Day in the Life of a Dog',
      Quantity__c = 20,
      Role__c = 'Presenter',
      Status__c = 'Approved',
      Contact__c = ace.Id
    );
    ceus.add(aceCeu);

    cookieCeu1 = new CEU__c(
      Authority__c = 'KPA',
      Comments__c = 'Comments2',
      DateCompleted__c = Date.today().addMonths(-2),
      DateSubmitted__c = Date.today().addMonths(-2),
      ProgramHours__c = 10,
      ProgramTitle__c = 'A Day in the Life of a Trainer',
      Quantity__c = 2,
      Role__c = 'Attendee',
      Status__c = 'Pending',
      Contact__c = cookie.Id
    );
    ceus.add(cookieCeu1);

    cookieCeu2 = new CEU__c(
      Authority__c = 'CCPDT',
      Comments__c = 'Comments3',
      DateCompleted__c = Date.today().addMonths(-3),
      DateSubmitted__c = Date.today().addMonths(-3),
      ProgramHours__c = 30,
      ProgramTitle__c = 'A Day in the Life of a Cookie',
      Quantity__c = 3,
      Role__c = 'Attendee',
      Status__c = 'Denied',
      Contact__c = cookie.Id
    );
    ceus.add(cookieCeu2);

    insert ceus;
  }

  private static void ceusMatch(CEU__c expected, CEU__c actual) {
    System.assertEquals(
      expected.Authority__c,
      actual.Authority__c,
      'authority mismatch'
    );
    System.assertEquals(
      expected.Comments__c,
      actual.Comments__c,
      'comments mismatch'
    );
    System.assertEquals(
      expected.DateCompleted__c,
      actual.DateCompleted__c,
      'date completed mismatch'
    );
    System.assertEquals(
      expected.DateSubmitted__c,
      actual.DateSubmitted__c,
      'date submitted mismatch'
    );
    System.assertEquals(
      expected.ProgramHours__c,
      actual.ProgramHours__c,
      'program hours mismatch'
    );
    System.assertEquals(
      expected.ProgramTitle__c,
      actual.ProgramTitle__c,
      'program title mismatch'
    );
    System.assertEquals(
      expected.Quantity__c,
      actual.Quantity__c,
      'quantity mismatch'
    );
    System.assertEquals(expected.Role__c, actual.Role__c, 'role mismatch');
    System.assertEquals(
      expected.Contact__c,
      actual.Contact__c,
      'contact mismatch'
    );
  }

  @isTest
  public static void getRelatedCeus_ReturnsRelated() {
    setup();
    RelatedObjects ceus = CEUController.getRelatedCeus(ace.Id, 10);

    System.assertEquals(1, ceus.items.size(), 'Wrong number of CEUs');
    System.assertEquals(1, ceus.total, 'wrong CEU total');
    CEU__c ceu = (CEU__c) ceus.items[0];
    ceusMatch(aceCeu, ceu);
  }

  @isTest
  public static void getRelatedCeus_ReturnsRelatedList() {
    setup();
    RelatedObjects ceus = CEUController.getRelatedCeus(cookie.Id, 5);

    System.assertEquals(2, ceus.items.size(), 'Wrong number of CEUs');
    System.assertEquals(2, ceus.total);
    ceusMatch(cookieCeu1, (CEU__c) ceus.items[0]);
    ceusMatch(cookieCeu2, (CEU__c) ceus.items[1]);
  }

  @isTest
  public static void getRelatedCeus_ReturnsRelatedList_whenCertification() {
    setup();
    Certification__c cert = new Certification__c(
      Contact__c = cookie.Id,
      Type__c = 'Trainer',
      Start__c = Date.today().addMonths(-6),
      End__c = Date.today().addMonths(6)
    );
    insert cert; // the trigger will connect the CEUs to the cert
    RelatedObjects ceus = CEUController.getRelatedCeus(cert.Id, 5);

    System.assertEquals(2, ceus.items.size(), 'Wrong number of CEUs');
    System.assertEquals(2, ceus.total, 'wrong total');
    ceusMatch(cookieCeu1, (CEU__c) ceus.items[0]);
    ceusMatch(cookieCeu2, (CEU__c) ceus.items[1]);
  }

  static MockProvider mocks;
  static CeuRepository ceuRepo;

  static void makeData() {
    mocks = new MockProvider();
    ceuRepo = (CeuRepository) mocks.createMock(CeuRepository.class);
  }

  @isTest
  static void getRelatedCeus_setsMax_whenNull() {
    makeData();
    CeuController.setRepo(ceuRepo);
    mocks.expectedCalls.add(
      new MockCallData(ceuRepo, 'getForContact', new List<Ceu__c>())
    );
    //act
    RelatedObjects ceus = CEUController.getRelatedCeus(
      MockProvider.createId(Contact.class),
      null
    );
    //assert
    System.assertEquals(6, mocks.actualCalls[0].args[1], 'wrong max');
  }

  @isTest
  static void getRelatedCeus_getsForCert_whenIdForCert() {
    makeData();
    CeuController.setRepo(ceuRepo);
    mocks.expectedCalls.add(
      new MockCallData(ceuRepo, 'getForCertification', new List<Ceu__c>())
    );
    //act
    RelatedObjects ceus = CEUController.getRelatedCeus(
      MockProvider.createId(Certification__c.class),
      null
    );
    //assert
    System.assertEquals(
      1,
      mocks.actualCalls[0].args.size(),
      'wrong number of args'
    );
  }

  @isTest
  static void getRelatedCeus_returnsEmpty_whenIdForOtherObject() {
    makeData();
    CeuController.setRepo(ceuRepo);
    mocks.expectedCalls.add(
      new MockCallData(ceuRepo, 'getForCertification', new List<Ceu__c>())
    );
    //act
    RelatedObjects ceus = CEUController.getRelatedCeus(
      MockProvider.createId(Dog__c.class),
      null
    );
    //assert
    System.assertEquals(
      0,
      ceus.total,
      'wrong number of ceus'
    );
  }
}
