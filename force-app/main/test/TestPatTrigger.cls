@IsTest
public with sharing class TestPatTrigger {

    private static Team__c team;
    private static PublicAccessTest__c pat;

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
            Client__c = contacts[1].Id,
            Dog__c = ace.Id,
            Handler__c = contacts[0].Id,
            Name = 'Camelot',
            PatValidUntil__c = expiration.addMonths(5),
            PatCount__c = 21,
            PrimaryCertification__c = 'Allergen Alert',
            SecondaryCertification__c = 'Autism'
        );
        insert team;

        pat = new PublicAccessTest__c(
            Assessor__c = ken.Id,
            DateCompleted__c = Date.today(),
            Location__c = 'In Person',
            Status__c = 'Passed',
            Team__c = team.Id,
            Type__c = 'Initial',
            ValidUntil__c = expiration
        );
    }

    private static Contact getContact(Id contactId) {
        return [SELECT Id, ClientCertificationValidUntil__c from Contact where Id = :contactId];
    }

    private static Team__c getTeam(Id teamId) {
        return [SELECT id, PatValidUntil__c, Client__c FROM Team__c where Id = :teamId LIMIT 1];
    }

    @isTest
    static void insert_setsValidUntil_whenPatValidSet() {
        Date expiration = Date.today().addMonths(12);
        setup(expiration);

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(pat, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        Team__c team = getTeam(team.Id);
        Contact contact = getContact(team.Client__c);
        System.assertEquals(expiration, team.PatValidUntil__c);
        System.assertEquals(expiration, contact.ClientCertificationValidUntil__c);
    }

    @isTest
    static void insert_doesNotUpdate_whenPatValidSetBackward() {
        Date expiration = Date.today().addMonths(12);
        setup(expiration);
        insert pat;

        pat.ValidUntil__c = Date.today().addDays(200);

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(pat, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        Team__c team = getTeam(team.Id);
        Contact contact = getContact(team.Client__c);
        System.assertEquals(contact.ClientCertificationValidUntil__c, team.PatValidUntil__c);
    }
}
