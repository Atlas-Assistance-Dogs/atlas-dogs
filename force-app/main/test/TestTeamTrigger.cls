@IsTest
public with sharing class TestTeamTrigger {

    private static Team__c team;

    private static void setup(Date expiration) {
        List<Contact> contacts = new List<Contact>();
        Contact debbie = new Contact(FirstName = 'Debbie', LastName = 'Queen');
        Contact ken = new Contact(FirstName = 'Ken', LastName = 'King');
        contacts.add(debbie);
        contacts.add(ken);
        insert contacts;

        Dog__c ace = new Dog__c(Name = 'Ace');
        insert ace;

        team = new Team__c(
            Client__c = ken.Id,
            Dog__c = ace.Id,
            Handler__c = debbie.Id,
            Name = 'Camelot',
            PatValidUntil__c = expiration,
            PatCount__c = 21,
            PrimaryCertification__c = 'Allergen Alert',
            SecondaryCertification__c = 'Autism'
        );
    }

    private static Contact getContact(Id contactId) {
        return [SELECT Id, ClientValidUntil__c from Contact where Id = :contactId];
    }

    private static Team__c getTeam(Id teamId) {
        return [SELECT id, PatValidUntil__c, Client__c FROM Team__c where Id = :teamId LIMIT 1];
    }

    @isTest
    static void insert_setsValidUntil_whenPatValidSet() {
        setup(Date.today().addMonths(12));

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(team, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        Team__c team = getTeam(result.getId());
        Contact contact = getContact(team.Client__c);
        System.assertEquals(contact.ClientValidUntil__c, team.PatValidUntil__c);
    }

    @isTest
    static void insert_setsValidUntil_whenPatValidUpdated() {
        setup(Date.today().addMonths(12));
        insert team;

        team.PatValidUntil__c = Date.today().addDays(200);

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(team, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        Team__c team = getTeam(result.getId());
        Contact contact = getContact(team.Client__c);
        System.assertEquals(contact.ClientValidUntil__c, team.PatValidUntil__c);
    }
}
