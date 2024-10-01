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

    public List<DogRelationShip__c> getRelationships(Id contactId, Id dogId) {
        return [
            SELECT Id, Type__c
            FROM DogRelationShip__c
            WHERE Contact__c = :contactId AND Dog__c = :dogId
        ];
    }

    public DogRelationShip__c createRelationship(DogRelationShip__c relationship) {
        insert relationship;
        return relationship;
    }

    public DogRelationShip__c modifyRelationship(DogRelationShip__c relationship) {
        upsert relationship;
        return relationship;
    }
}