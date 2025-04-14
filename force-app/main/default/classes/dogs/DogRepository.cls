public with sharing class DogRepository {
  public DogRepository() {
  }

  public Dog__c getById(Id dogId) {
    List<Dog__c> dogs = [
      SELECT Name, Status__c
      FROM Dog__c
      WHERE Id = :dogId
    ];
    if (!dogs.isEmpty()) {
      return dogs[0];
    }
    return null;
  }

  public Dog__c modify(Dog__c dog) {
    upsert dog;
    return dog;
  }

  public List<DogRelationship__c> getRelationships(Id contactId, Id dogId) {
    return [
      SELECT Id, Dog__c, Contact__c, Type__c
      FROM DogRelationship__c
      WHERE Contact__c = :contactId AND Dog__c = :dogId
    ];
  }

  public DogRelationship__c createRelationship(
    DogRelationship__c relationship
  ) {
    insert relationship;
    return relationship;
  }

  public DogRelationship__c modifyRelationship(
    DogRelationship__c relationship
  ) {
    upsert relationship;
    return relationship;
  }
}
