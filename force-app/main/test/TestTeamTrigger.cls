@isTest
public with sharing class TestTeamTrigger {
    private static Contact joe;
    private static Dog__c boomer;

    private static void setup() {
        joe = new Contact(FirstName = 'Joe', LastName = 'Blow');
        insert joe;
        boomer = new Dog__c(Name = 'Boomer');
        insert boomer;
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

    @isTest
    public static void triggerUpdatesRelationship_WhenNotClient() {
        setup();
        DogRelationShip__c dr = new DogRelationShip__c(
            Contact__c = joe.Id,
            Dog__c = boomer.Id,
            Type__c = 'Owner'
        );
        insert dr;
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
        System.assert(relationship.Type__c.contains('Client'));
        System.assert(relationship.Type__c.contains('Owner'));
        System.assert(relationship.Type__c.contains(';'));
    }

    @isTest
    public static void triggerDoesNothing_WhenRelationShipExists() {
        setup();
        DogRelationShip__c dr = new DogRelationShip__c(
            Contact__c = joe.Id,
            Dog__c = boomer.Id,
            Type__c = 'Client;Owner'
        );
        insert dr;
        dr = [SELECT LastModifiedDate FROM DogRelationShip__c WHERE Id = :dr.Id];
        Datetime modified = dr.LastModifiedDate;

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
            SELECT Type__c, LastModifiedDate
            FROM DogRelationShip__c
            WHERE Dog__c = :boomer.Id AND Contact__c = :joe.Id
        ];
        System.assert(relationship.Type__c.contains('Client'));
        System.assert(relationship.Type__c.contains('Owner'));
        System.assert(relationship.Type__c.contains(';'));
        System.assertEquals(modified, relationship.LastModifiedDate);
    }

    @isTest
    public static void triggerCreatesRelationShip_WhenDogChanged() {
        setup();
        DogRelationShip__c dr = new DogRelationShip__c(
            Contact__c = joe.Id,
            Dog__c = boomer.Id,
            Type__c = 'Client;Owner'
        );
        insert dr;
        dr = [SELECT LastModifiedDate FROM DogRelationShip__c WHERE Id = :dr.Id];
        Datetime modified = dr.LastModifiedDate;

        Team__c team = new Team__c(
            Name = 'Joe_Boomer',
            Client__c = joe.Id,
            Dog__c = boomer.Id
        );
        insert team;

        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;

        team.Dog__c = ace.Id;

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(team, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        DogRelationShip__c relationship = [
            SELECT Type__c, LastModifiedDate
            FROM DogRelationShip__c
            WHERE Dog__c = :boomer.Id AND Contact__c = :joe.Id
        ];
        System.assertEquals(modified, relationship.LastModifiedDate);
        relationship = [
            SELECT Type__c, LastModifiedDate
            FROM DogRelationShip__c
            WHERE Dog__c = :ace.Id AND Contact__c = :joe.Id
        ];
        System.assertEquals('Client', relationship.Type__c);
    }
}
