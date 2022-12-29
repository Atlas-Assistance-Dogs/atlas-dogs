@isTest
public with sharing class TestTeamTrigger {
    private static Contact joe;
    private static Dog__c boomer;

    private static void setup() {
        joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Blow',
            ClientStatus__c = 'Onboarding',
            ClientCertificationValidUntil__c = Date.today().addMonths(3));
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

    private static void testClientStatus(string status, Date cert, string expectedStatus, Date expectedCert) {
        Team__c team = new Team__c(
            Name = 'Joe_Boomer',
            Client__c = joe.Id,
            Dog__c = boomer.Id,
            Status__c = status,
            CertificationValidUntil__c = cert
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(team, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact client = [
            SELECT ClientStatus__c, ClientCertificationValidUntil__c
            FROM Contact
            WHERE Id = :joe.Id
        ];
        System.assertEquals(expectedStatus, client.ClientStatus__c);
        System.assertEquals(expectedCert, client.ClientCertificationValidUntil__c);
    }
    
    @isTest
    public static void trigger_DoesNotUpdateClientStatus_WhenDecertified() {
        setup();
        testClientStatus('Decertified', Date.today().addMonths(5), joe.ClientStatus__c, joe.ClientCertificationValidUntil__c);
    }
    
    @isTest
    public static void trigger_DoesNotUpdateClientStatus_WhenDiscontinued() {
        setup();
        testClientStatus('Discontinued', Date.today().addMonths(5), joe.ClientStatus__c, joe.ClientCertificationValidUntil__c);
    }
    
    @isTest
    public static void trigger_UpdatesClientStatus_WhenNone() {
        setup();
        string status = 'None';
        Date expected = Date.today().addMonths(5);
        testClientStatus(status, expected, status, expected);
    }
    
    @isTest
    public static void trigger_UpdatesClientStatus_WhenInitialInquiry() {
        setup();
        string status = 'Initial Inquiry';
        Date expected = Date.today().addMonths(5);
        testClientStatus(status, expected, status, expected);
    }
    
    @isTest
    public static void trigger_UpdatesClientStatus_WhenInADSiM() {
        setup();
        string status = 'In ADSiM';
        Date expected = Date.today().addMonths(5);
        testClientStatus(status, expected, status, expected);
    }
    
    @isTest
    public static void trigger_UpdatesClientStatus_WhenOnboarding() {
        setup();
        string status = 'Onboarding';
        Date expected = Date.today().addMonths(5);
        testClientStatus(status, expected, status, expected);
    }
    
    @isTest
    public static void trigger_UpdatesClientStatus_WhenInTraining() {
        setup();
        string status = 'In Training';
        Date expected = Date.today().addMonths(5);
        testClientStatus(status, expected, status, expected);
    }
    
    @isTest
    public static void trigger_UpdatesClientStatus_WhenCertified() {
        setup();
        string status = 'Certified';
        Date expected = Date.today().addMonths(5);
        testClientStatus(status, expected, status, expected);
    }
}
