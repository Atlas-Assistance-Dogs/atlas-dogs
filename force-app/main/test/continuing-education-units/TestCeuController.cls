@isTest
public with sharing class TestCeuController {
  private static Contact ace;
  private static Contact cookie;
  private static ContinuingEducationUnit__c aceCeu;
  private static ContinuingEducationUnit__c cookieCeu1;
  private static ContinuingEducationUnit__c cookieCeu2;

  static void setup() {
    List<Contact> contacts = new List<Contact>();
    ace = new Contact(FirstName = 'Ace', LastName = 'GSD');
    cookie = new Contact(FirstName = 'Cookie', LastName = 'Monster');
    contacts.add(ace);
    contacts.add(cookie);
    insert contacts;

    List<ContinuingEducationUnit__c> ceus = new List<ContinuingEducationUnit__c>();
    aceCeu = new ContinuingEducationUnit__c(
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
      Trainer__c = ace.Id
    );
    ceus.add(aceCeu);

    cookieCeu1 = new ContinuingEducationUnit__c(
      Authority__c = 'KPA',
      Comments__c = 'Comments2',
      DateCompleted__c = Date.today().addMonths(-2),
      DateSubmitted__c = Date.today().addMonths(-2),
      ProgramDate__c = Date.today().addDays(-20),
      ProgramHours__c = 10,
      ProgramTitle__c = 'A Day in the Life of a Trainer',
      Quantity__c = 2,
      Role__c = 'Attendee',
      Status__c = 'Pending',
      Trainer__c = cookie.Id
    );
    ceus.add(cookieCeu1);

    cookieCeu2 = new ContinuingEducationUnit__c(
      Authority__c = 'CCPDT',
      Comments__c = 'Comments3',
      DateCompleted__c = Date.today().addMonths(-3),
      DateSubmitted__c = Date.today().addMonths(-3),
      ProgramDate__c = Date.today().addDays(-30),
      ProgramHours__c = 30,
      ProgramTitle__c = 'A Day in the Life of a Cookie',
      Quantity__c = 3,
      Role__c = 'Attendee',
      Status__c = 'Denied',
      Trainer__c = cookie.Id
    );
    ceus.add(cookieCeu2);

    insert ceus;
  }

  private static void ceusMatch(
    ContinuingEducationUnit__c expected,
    ContinuingEducationUnit__c actual
  ) {
    System.assertEquals(expected.Authority__c, actual.Authority__c);
    System.assertEquals(expected.Comments__c, actual.Comments__c);
    System.assertEquals(expected.DateCompleted__c, actual.DateCompleted__c);
    System.assertEquals(expected.DateSubmitted__c, actual.DateSubmitted__c);
    System.assertEquals(expected.ProgramDate__c, actual.ProgramDate__c);
    System.assertEquals(expected.ProgramHours__c, actual.ProgramHours__c);
    System.assertEquals(expected.ProgramTitle__c, actual.ProgramTitle__c);
    System.assertEquals(expected.Quantity__c, actual.Quantity__c);
    System.assertEquals(expected.Role__c, actual.Role__c);
    System.assertEquals(expected.Trainer__c, actual.Trainer__c);
  }

  @isTest
  public static void getRelatedCeus_ReturnsRelated() {
    setup();
    RelatedObjects ceus = ContinuingEducationUnitController.getRelatedCeus(
      ace.Id,
      10
    );

    System.assertEquals(1, ceus.items.size(), 'Wrong number of CEUs');
    System.assertEquals(1, ceus.total);
    ContinuingEducationUnit__c ceu = (ContinuingEducationUnit__c) ceus.items[0];
    ceusMatch(aceCeu, ceu);
  }

  @isTest
  public static void getRelatedCeus_ReturnsRelatedList() {
    setup();
    RelatedObjects ceus = ContinuingEducationUnitController.getRelatedCeus(
      cookie.Id,
      5
    );

    System.assertEquals(2, ceus.items.size(), 'Wrong number of CEUs');
    System.assertEquals(2, ceus.total);
    ceusMatch(cookieCeu1, (ContinuingEducationUnit__c) ceus.items[0]);
    ceusMatch(cookieCeu2, (ContinuingEducationUnit__c) ceus.items[1]);
  }
}
