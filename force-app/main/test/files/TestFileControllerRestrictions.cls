/**
 * This class contains unit tests for validating the behavior of FileController
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
        documents.add(new ContentVersion(
          Title = String.format('TestDocument{0}', parameters), 
          PathOnClient = String.format('TestDocument{0}.jpg', parameters), 
          Origin = 'H', 
          VersionData = Blob.valueOf('Document Body'), 
          Category__c = category, 
          Type__c = docType, 
          Date__c = Date.today().addDays(-count)
        ));
        count = count + 1;
      }
    }

    insert documents;

    // We need to do the query here to get the ContentDocumentId's
    documents = [SELECT Id, 
                        ContentDocumentId, 
                        Title, 
                        PathOnClient, 
                        Origin, 
                        VersionData, 
                        Category__c, 
                        Type__c, 
                        Date__c
                 FROM ContentVersion];
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
    System.runAs(new User(
      Id = testUser.Id
    )) {
      related = FileController.getRelatedFiles(ronan.Id, 6);
    }
    Test.stopTest();

    return related;
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForBoardVolunteerTrainer() {
    RelatedObjects related = getRelatedFilesWithGroups(new List<string>{ 'Board', 'Volunteer', 'Trainer' });
    System.assert(related.items.size() <= 6);
    System.assertEquals(18, related.total, 'should have 18 total');
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForBoard() {
    RelatedObjects related = getRelatedFilesWithGroups(new List<string>{ 'Board' });

    System.assertEquals(6, related.items.size());
    System.assertEquals(9, related.total, 'should have 9 files');
    System.assertEquals('Board', ((FileInfo)related.items[0]).category);
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForVolunteer() {
    RelatedObjects related = getRelatedFilesWithGroups(new List<string>{ 'Volunteer' });

    System.assertEquals(6, related.items.size(), 'should have 6 files returned');
    System.assertEquals(7, related.total, 'should have 7 total');
    Set<String> cats = new Set<String>{ 'N/A', 'Volunteer' };
    for (Object obj : related.items) {
      FileInfo info = (FileInfo)obj;
      System.assert(cats.contains(info.category), 'should be N/A or Volunteer');
    }
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForTrainer() {
    RelatedObjects related = getRelatedFilesWithGroups(new List<string>{ 'Trainer' });

    System.assertEquals(6, related.items.size(), 'should have 6 files returned');
    System.assertEquals(10, related.total, 'should have 10 total');
    Set<String> cats = new Set<String>{ 'N/A', 'Trainer' };
    for (Object obj : related.items) {
      FileInfo info = (FileInfo)obj;
      System.assert(cats.contains(info.category), 'should be N/A or Trainer');
    }
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForTeam() {
    RelatedObjects related = getRelatedFilesWithGroups(new List<string>{ 'Team' });

    System.assertEquals(6, related.items.size(), 'should have 6 files returned');
    System.assertEquals(24, related.total, 'should have 24 total');
  }

  @isTest
  public static void getRelatedFiles_ReturnsRelatedRecords_ForBoardTrainer() {
    RelatedObjects related = getRelatedFilesWithGroups(new List<string>{ 'Board', 'Trainer' });

    System.assertEquals(6, related.items.size(), 'should have 6 files returned');
    System.assertEquals(15, related.total, 'should have 15 total');
  }

}
