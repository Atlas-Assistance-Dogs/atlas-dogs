/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestFileControllerRestrictions {
  public static List<ContentVersion> insertRecords() {
    // get a map of the category and type labels
    Map<String, List<String>> allCategories = TestUtilities.getCategoryTypeDependencies();
    List<ContentVersion> documents = new List<ContentVersion>();
    Integer count = 1;
    for (String category : allCategories.keySet()) {
      List<String> types = allCategories.get(category);
      for (String docType : types) {
        List<Object> parameters = new List<Object>{ count };
        documents.add(
          new ContentVersion(
            Title = String.format('TestDocument{0}', parameters),
            PathOnClient = String.format('TestDocument{0}.jpg', parameters),
            Origin = 'H',
            VersionData = Blob.valueOf('Document Body'),
            Category__c = category,
            Type__c = docType,
            Date__c = Date.today().addDays(-count)
          )
        );
        count = count + 1;
      }
    }

    insert documents;

    // We need to do the query here to get the ContentDocumentId's
    documents = [
      SELECT
        Id,
        ContentDocumentId,
        Title,
        PathOnClient,
        Origin,
        VersionData,
        Category__c,
        Type__c,
        Date__c
      FROM ContentVersion
    ];
    return documents;
  }

  // This method is used to setup the getRelatedFilesWith... tests.  The file records have all category/type combinations
  private static RelatedObjects getRelatedFilesWithGroups(string[] groups) {
    TestUtilities.insertCategoryRules();

    List<ContentVersion> documents = insertRecords();

    // Get the ids of all these documents
    List<Id> ids = new List<Id>();
    for (ContentVersion cv : documents) {
      ids.add(cv.ContentDocumentId);
    }
    Contact ronan = new Contact(
      FirstName = 'Ronan',
      LastName = 'Dax',
      email = 'ronan@test.com',
      Positions__c = 'Board Member;Client;Puppy Raiser;Standalone;Staff;Team Facilitator;Team Facilitator Lead;Trainer;Volunteer',
      ShareBoard__c = true,
      SharePuppyRaiser__c = true,
      ShareStaff__c = true,
      ShareStandalonePrograms__c = true,
      ShareTeam__c = true,
      ShareTrainer__c = true,
      ShareVolunteer__c = true
    );
    insert ronan;
    FileController.relateFiles(ids, ronan.Id);

    User testUser = TestUtilities.createUser('System Administrator');
    TestUtilities.addUserToGroups(testUser, groups);
    RelatedObjects related = new RelatedObjects();
    Test.startTest();
    System.runAs(new User(Id = testUser.Id)) {
      related = FileController.getRelatedFiles(ronan.Id, 6);
    }
    Test.stopTest();

    return related;
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForBoardVolunteerTrainer() {
    RelatedObjects related = getRelatedFilesWithGroups(
      new List<string>{ 'Board', 'Volunteer', 'Trainer' }
    );
    System.assert(related.items.size() <= 6);
    System.assertEquals(16, related.total);
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForBoard() {
    RelatedObjects related = getRelatedFilesWithGroups(
      new List<string>{ 'Board' }
    );

    System.assertEquals(6, related.items.size());
    System.assertEquals(7, related.total);
    System.assertEquals('Board', ((FileInfo) related.items[0]).category);
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForVolunteer() {
    RelatedObjects related = getRelatedFilesWithGroups(
      new List<string>{ 'Volunteer' }
    );

    System.assertEquals(5, related.items.size());
    System.assertEquals(5, related.total);
    System.assertEquals('Volunteer', ((FileInfo) related.items[0]).category);
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForTrainer() {
    RelatedObjects related = getRelatedFilesWithGroups(
      new List<string>{ 'Trainer' }
    );

    System.assertEquals(6, related.items.size());
    System.assertEquals(8, related.total);
    System.assertEquals('Trainer', ((FileInfo) related.items[3]).category);
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForTeam() {
    RelatedObjects related = getRelatedFilesWithGroups(
      new List<string>{ 'Team' }
    );

    System.assertEquals(6, related.items.size());
        System.assertEquals(22, related.total);
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForBoardTrainer() {
    RelatedObjects related = getRelatedFilesWithGroups(
      new List<string>{ 'Board', 'Trainer' }
    );

    System.assertEquals(6, related.items.size());
    System.assertEquals(13, related.total);
  }
}
