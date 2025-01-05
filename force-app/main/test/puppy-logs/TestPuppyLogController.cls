@isTest
public with sharing class TestPuppyLogController {
  private static final String RAISER_NAME = 'Raiser';
  private static final String SOMEONE_ELSE = 'Debbie';
  private static final String DOG_NAME = 'Fido';

  private static Contact raiser;
  private static Contact other;
  private static Dog__c dog;

  @testSetup
  static void setup() {
    List<Contact> contacts = new List<Contact>();
    contacts.add(new Contact(FirstName = RAISER_NAME, LastName = 'Ace'));
    contacts.add(new Contact(FirstName = SOMEONE_ELSE, LastName = 'Walker'));
    insert contacts;

    dog = new Dog__c(Name = DOG_NAME);
    insert dog;
  }

  static void getContacts() {
    raiser = [
      SELECT id
      FROM Contact
      WHERE FirstName = :RAISER_NAME
      LIMIT 1
    ];

    other = [
      SELECT id
      FROM Contact
      WHERE FirstName = :SOMEONE_ELSE
      LIMIT 1
    ];

    dog = [SELECT Id, Name FROM Dog__c WHERE Name = :DOG_NAME LIMIT 1];
  }

  private static void logsMatch(PuppyLog__c expected, PuppyLog__c actual) {
    System.assertEquals(
      expected.AdditionalInformation__c,
      actual.AdditionalInformation__c
    );
    System.assertEquals(expected.Date__c, actual.Date__c);
    System.assertEquals(expected.Raiser__c, actual.Raiser__c);
    System.assertEquals(
      expected.RequestSupportFromAtlas__c,
      actual.RequestSupportFromAtlas__c
    );
    System.assertEquals(expected.Dog__c, actual.Dog__c);
  }

  private static void logsMatch(PuppyLog expected, PuppyLog actual) {
    logsMatch(expected.log, actual.log);
    System.assertEquals(
      expected.dogName,
      actual.dogName,
      'dogName does not match'
    );
    System.assertEquals(
      expected.documentId,
      actual.documentId,
      'documentId does not match'
    );
    System.assertEquals(
      expected.fileName,
      actual.fileName,
      'fileName does not match'
    );
    System.assertEquals(
      expected.raiserName,
      actual.raiserName,
      'raiserName does not match'
    );
    System.assertEquals(
      expected.noFile,
      actual.noFile,
      'noFile does not match'
    );
  }

  @isTest
  public static void getRelatedLogs_ReturnsEmptyList_WhenNoLogs() {
    Test.startTest();

    Contact contact = [
      SELECT id
      FROM Contact
      WHERE FirstName = :RAISER_NAME
      LIMIT 1
    ];
    RelatedObjects relatedObjects = PuppyLogController.getRelatedLogs(
      contact.Id,
      6
    );
    Test.stopTest();
    System.assertEquals(0, relatedObjects.items.size());
  }

  @isTest
  public static void getRelatedLogs_ThrowsException_WhenNoContactId() {
    Test.startTest();

    Boolean exceptionThrown = false;
    try {
      RelatedObjects related = PuppyLogController.getRelatedLogs('dog.Id', 6);
    } catch (Exception exc) {
      exceptionThrown = true;
    }

    Test.stopTest();
    System.assert(exceptionThrown);
  }

  @isTest
  public static void getRelatedLogs_ReturnsExpectedLogs() {
    getContacts();

    List<PuppyLog__c> logs = new List<PuppyLog__c>();
    logs.add(
      new PuppyLog__c(
        AdditionalInformation__c = 'Play Dead sit nap lazy dog wet nose Tigger run fast fish lazy cat wagging hamster toy field yawn feathers ferret yawn aquarium.',
        Raiser__c = raiser.Id,
        Date__c = Date.today().addDays(-7),
        Dog__c = dog.Id,
        RequestSupportFromAtlas__c = false
      )
    );
    logs.add(
      new PuppyLog__c(
        AdditionalInformation__c = 'Feathers bird seed food scratcher mouse running teeth licks heel walk pet gate maine coon cat collar twine parakeet.',
        Raiser__c = other.Id,
        Date__c = Date.today().addDays(-7),
        Dog__c = dog.Id,
        RequestSupportFromAtlas__c = true
      )
    );
    insert logs;

    Test.startTest();

    RelatedObjects related = PuppyLogController.getRelatedLogs(raiser.Id, 6);

    Test.stopTest();
    System.assertEquals(1, related.items.size());
    for (Integer idx = 0; idx < related.items.size(); idx++) {
      PuppyLog puppy = new PuppyLog();
      puppy.log = logs[0];
      puppy.documentId = null;
      puppy.dogName = DOG_NAME;
      puppy.noFile = true;
      puppy.raiserName = RAISER_NAME + ' Ace';
      PuppyLog__c expectedLog = logs[0];
      PuppyLog__c actual = ((PuppyLog) related.items[idx]).log;
      logsMatch(expectedLog, actual);
    }
  }

  @isTest
  public static void getRelatedLogs_ReturnsExpectedLogsWithDocumentInfo() {
    getContacts();

    List<PuppyLog__c> logs = new List<PuppyLog__c>();
    logs.add(
      new PuppyLog__c(
        AdditionalInformation__c = 'Play Dead sit nap lazy dog wet nose Tigger run fast fish lazy cat wagging hamster toy field yawn feathers ferret yawn aquarium.',
        Raiser__c = raiser.Id,
        Date__c = Date.today(),
        Dog__c = dog.Id,
        RequestSupportFromAtlas__c = false
      )
    );
    logs.add(
      new PuppyLog__c(
        AdditionalInformation__c = 'Feathers bird seed food scratcher mouse running teeth licks heel walk pet gate maine coon cat collar twine parakeet.',
        Raiser__c = raiser.Id,
        Date__c = Date.today().addDays(-7),
        Dog__c = dog.Id,
        RequestSupportFromAtlas__c = true
      )
    );
    insert logs;

    List<PuppyLog> puppies = new List<PuppyLog>();
    for (PuppyLog__c plog : logs) {
      PuppyLog puppy = new PuppyLog();
      puppy.log = plog;
      puppy.dogName = DOG_NAME;
      puppy.raiserName = RAISER_NAME + ' Ace';
      puppy.noFile = true;
      puppies.add(puppy);
    }

    // attach a document to the first log
    PuppyLog__c log1 = logs[0];
    ContentVersion cv = TestFileServiceFields.createLink(
      null,
      null,
      Date.today(),
      log1.Id
    );
    // get the ContentDocumentId
    cv = [
      SELECT Id, ContentDocumentId, Title
      FROM ContentVersion
      WHERE Id = :cv.Id
    ];
    System.debug(cv);
    PuppyLog puppy1 = puppies[0];
    puppy1.documentId = cv.ContentDocumentId;
    puppy1.fileName = cv.Title;
    puppy1.noFile = false;

    Test.startTest();

    RelatedObjects related = PuppyLogController.getRelatedLogs(raiser.Id, 6);

    Test.stopTest();
    System.assertEquals(logs.size(), related.items.size());
    System.assertEquals(logs.size(), related.total);
    for (Integer idx = 0; idx < related.items.size(); idx++) {
      PuppyLog puppy = puppies[idx];
      PuppyLog actual = (PuppyLog) related.items[idx];
      logsMatch(puppy, actual);
    }
  }
}
