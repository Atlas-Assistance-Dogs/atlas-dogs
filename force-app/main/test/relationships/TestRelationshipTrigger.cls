@isTest
public with sharing class TestRelationshipTrigger {
  private static Contact joe;
  private static Contact boomer;
  private static npe4__Relationship__c relationship;

  private static void setup() {
    joe = new Contact(
      FirstName = 'Joe',
      LastName = 'Blow',
      Positions__c = 'Volunteer'
    );
    boomer = new Contact(FirstName = 'Boomer', LastName = 'Onboarding');
    insert new List<Contact>{ joe, boomer };

    relationship = new npe4__Relationship__c(
      npe4__Contact__c = joe.id,
      npe4__Status__c = 'Current',
      npe4__Type__c = 'Primary Emergency Contact',
      npe4__RelatedContact__c = boomer.id
    );
    insert relationship;
  }

  @isTest
  public static void triggerAllowsInsert() {
    setup();

    npe4__Relationship__c testRelationship = new npe4__Relationship__c(
      npe4__Contact__c = joe.id,
      npe4__Status__c = 'Current',
      npe4__Type__c = 'Guardian',
      npe4__RelatedContact__c = boomer.id
    );

    // Act
    Test.startTest();
    Database.SaveResult result = Database.insert(testRelationship, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
  }

  @isTest
  public static void triggerAllowsUpdate() {
    setup();
    relationship.npe4__Type__c = 'Spouse';

    // Act
    Test.startTest();
    Database.SaveResult result = Database.update(relationship, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
  }

  @isTest
  public static void triggerAllowsDelete() {
    setup();

    // Act
    Test.startTest();
    Database.DeleteResult result = Database.delete(relationship, false);
    Test.stopTest();

    // Assert
    System.assert(result.isSuccess());
  }
}
