@isTest
public with sharing class TestRelationshipTrigger {
    private static Contact joe;
    private static Contact boomer;
    private static npe4__Relationship__c relationship;

    private static void setup() {
        joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Blow');
        boomer = new Contact(FirstName = 'Boomer', LastName = 'Onboarding');
        insert new List<Contact> {joe, boomer};

        relationship = new npe4__Relationship__c(npe4_Contact__c = joe.id, npe4__Status__c = 'Current', npe4__Type__c = 'Guardian', npe4__RelatedContact__c = boomer.id);
        insert relationship;
    }

    @isTest
    public static void triggerCreatesRelationship_WhenNotDefined() {
        setup();
        Team__c team = new Team__c(
            Name = 'Joe_Boomer',
            Client__c = joe.Id,
            Dog__c = boomer.Id
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(team, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        DogRelationShip__c relationship = [
            SELECT Type__c
            FROM DogRelationShip__c
            WHERE Dog__c = :boomer.Id AND Contact__c = :joe.Id
        ];
        System.assertEquals('Client', relationship.Type__c);
    }
}