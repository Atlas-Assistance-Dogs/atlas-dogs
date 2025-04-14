/**
 * This class contains unit tests for the DogRepository class
 */
@isTest
private class TestDogRepository {
  static DogRepository repo = new DogRepository();

  @isTest
  static void getById_returnsNull_whenNoDog() {
    Dog__c actual = repo.getById(MockProvider.createId(Dog__c.class));
    System.assertEquals(null, actual, 'not null');
  }

  @isTest
  static void getById_returnsDog_whenMatch() {
    Dog__c dog = new Dog__c(Name = 'fido');
    insert dog;
    //act
    Dog__c actual = repo.getById(dog.Id);
    //assert
    System.assertEquals(dog.Id, actual.Id, 'wrong id');
    System.assertEquals(dog.Name, actual.Name, 'wrong name');
  }

  @isTest
  static void modify_updatesDog() {
    Dog__c dog = new Dog__c(Name = 'fido');
    insert dog;
    dog.Status__c = 'Onboarding';
    //act
    Dog__c actual = repo.modify(dog);
    //assert
    Dog__c updated = [SELECT Status__c FROM Dog__c WHERE Id = :dog.Id];
    System.assertEquals(dog, actual, 'did not return updated record');
    System.assertEquals(
      dog.Status__c,
      updated.Status__c,
      'not saved to database'
    );
  }

  @isTest
  static void getRelationships_returnsEmpty_whenNone() {
    List<DogRelationship__c> actual = repo.getRelationships(
      MockProvider.createId(Contact.class),
      MockProvider.createId(Dog__c.class)
    );
    System.assertEquals(
      new List<DogRelationShip__c>(),
      actual,
      'unexpected result'
    );
  }

  @isTest
  static void getRelationships_returnsRelationship() {
    Team__c team = TestTeam.create();
    List<DogRelationship__c> actual = repo.getRelationships(
      team.Client__c,
      team.Dog__c
    );
    System.assertEquals(1, actual.size(), 'more relationships than expected');
    DogRelationship__c relationship = actual[0];
    System.assertEquals(
      team.Client__c,
      relationship.Contact__c,
      'wrong contact'
    );
    System.assertEquals(team.Dog__c, relationship.Dog__c, 'wrong dog');
    System.assertEquals('Client', relationship.Type__c, 'wrong status');
  }

  @isTest
  static void createRelationship_creates() {
    Contact wanda = new Contact(FirstName = 'Wanda', LastName = 'Around');
    insert wanda;

    Dog__c ace = new Dog__c(Name = 'Ace');
    insert ace;
    DogRelationship__c actual = repo.createRelationship(
      new DogRelationship__c(
        Contact__c = wanda.Id,
        Dog__c = ace.Id,
        Type__c = 'Owner'
      )
    );
    //assert
    System.assertNotEquals(null, actual.Id, 'no id assigned');
    DogRelationship__c relate = [
      SELECT Id, Contact__c, Dog__c, Type__c
      FROM DogRelationship__c
      WHERE Id = :actual.Id
    ];
    System.assertEquals(wanda.Id, relate.Contact__c, 'wring contact');
    System.assertEquals(ace.Id, relate.Dog__c, 'wrong dog');
    System.assertEquals('Owner', relate.Type__c, 'wrong type');
  }

  @isTest
  static void modifyRelationship_modifies() {
    Contact wanda = new Contact(FirstName = 'Wanda', LastName = 'Around');
    insert wanda;

    Dog__c ace = new Dog__c(Name = 'Ace');
    insert ace;
    DogRelationship__c relate = new DogRelationship__c(
      Contact__c = wanda.Id,
      Dog__c = ace.Id,
      Type__c = 'Owner'
    );
    insert relate;

    relate.Type__c = 'Handler';
    // act
    DogRelationship__c actual = repo.modifyRelationship(relate);
    // assert
    System.assertEquals(
      relate.Type__c,
      actual.Type__c,
      'did not return updated'
    );
    DogRelationship__c stored = [
      SELECT Id, Type__c
      FROM DogRelationship__c
      WHERE Id = :actual.Id
    ];
    System.assertEquals(relate.Type__c, stored.Type__c, 'did not store type');
  }
}
