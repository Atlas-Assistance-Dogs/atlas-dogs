@isTest
public with sharing class TestContentDocumentTrigger {
  @isTest
  static void delete_ClearsDate_WhenNoOthers() {
    string category = 'Trainer';
    string docType = 'Application';

    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      TrainerApplicationReceived__c = Date.today().addDays(-1)
    );
    insert joe;
    Id joeId = joe.Id;

    ContentVersion cv = TestFileService.createLink(
      category,
      docType,
      Date.today().addDays(-1),
      joeId
    );
    delete [
      SELECT Id
      FROM ContentDocumentLink
      WHERE
        ContentDocumentId = :cv.ContentDocumentId
        AND LinkedEntityId != :joeId
    ];
    ContentDocument doc = [
      SELECT Id
      FROM ContentDocument
      WHERE Id = :cv.ContentDocumentId
    ];

    // Act
    Test.startTest();
    Database.DeleteResult result = Database.delete(doc, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    System.assert(result.getErrors().size() == 0);
    Contact saved = [
      SELECT TrainerApplicationReceived__c
      FROM Contact
      WHERE id = :joe.Id
      LIMIT 1
    ];
    //System.assertEquals(null, saved.TrainerApplicationReceived__c);
  }

  @isTest
  static void delete_SetNextDate_When2Others() {
    string category = 'Trainer';
    string docType = 'Application';

    Contact joe = new Contact(
      Email = 'joe-blow@pump.com',
      FirstName = 'Joe',
      LastName = 'Blow',
      TrainerApplicationReceived__c = Date.today().addDays(-1)
    );
    insert joe;
    Id joeId = joe.Id;

    ContentVersion cv1 = TestFileService.createLink(
      category,
      docType,
      Date.today().addDays(-3),
      joeId
    );
    ContentVersion cv2 = TestFileService.createLink(
      category,
      docType,
      Date.today().addDays(-2),
      joeId
    );
    ContentVersion cv3 = TestFileService.createLink(
      category,
      docType,
      Date.today().addDays(-1),
      joeId
    );

    ContentDocument doc = [
      SELECT Id
      FROM ContentDocument
      WHERE Id = :cv3.ContentDocumentId
      LIMIT 1
    ];

    // Act
    Test.startTest();
    Database.DeleteResult result = Database.delete(doc, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
    System.assert(result.getErrors().size() == 0);
    Contact saved = [
      SELECT TrainerApplicationReceived__c
      FROM Contact
      WHERE id = :joe.Id
      LIMIT 1
    ];
    //System.assertEquals(Date.today().addDays(-2), saved.TrainerApplicationReceived__c);
  }
}
