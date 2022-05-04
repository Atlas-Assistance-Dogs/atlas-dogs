@isTest
public with sharing class TestTeamController {
    private static Contact debbie;
    private static Contact ken;
    private static Dog__c ace;
    private static Team__c team;

    private static void setup() {
        List<Contact> contacts = new List<Contact>();
        debbie = new Contact(FirstName = 'Debbie', LastName = 'Queen');
        ken = new Contact(FirstName = 'Ken', LastName = 'King');
        contacts.add(debbie);
        contacts.add(ken);
        insert contacts;

        ace = new Dog__c(Name = 'Ace');
        insert ace;

        team = new Team__c(
            Client__c = ken.Id,
            Dog__c = ace.Id,
            Handler__c = debbie.Id,
            Name = 'Camelot',
            PatValidUntil__c = Date.today().addMonths(12),
            PatCount__c = 21,
            PrimaryCertification__c = 'Allergen Alert',
            SecondaryCertification__c = 'Autism'
        );
        insert team;
    }

    private static void teamsMatch(Team__c expected, Team__c actual) {
        System.assertEquals(expected.Id, actual.Id);
        System.assertEquals(expected.Client__c, actual.Client__c);
        System.assertEquals(expected.Dog__c, actual.Dog__c);
        System.assertEquals(expected.Handler__c, actual.Handler__c);
        System.assertEquals(expected.Name, actual.Name);
        System.assertEquals(expected.PatValidUntil__c, actual.PatValidUntil__c);
        System.assertEquals(expected.PatCount__c, actual.PatCount__c);
        System.assertEquals(expected.PrimaryCertification__c, actual.PrimaryCertification__c);
        System.assertEquals(expected.SecondaryCertification__c, actual.SecondaryCertification__c);
    }

    @isTest
    public static void getRelatedTeams_ReturnsRelatedToDog() {
        setup();
        List<Team__c> teams = TeamController.getRelatedTeams(ace.Id);
        System.assertEquals(1, teams.size());
        teamsMatch(team, teams[0]);
    }

    @isTest
    public static void getRelatedTeams_ReturnsRelatedToClient() {
        setup();
        List<Team__c> teams = TeamController.getRelatedTeams(ken.Id);
        System.assertEquals(1, teams.size());
        teamsMatch(team, teams[0]);
    }

    @isTest
    public static void getRelatedTeams_ReturnsRelatedToHandler() {
        setup();
        List<Team__c> teams = TeamController.getRelatedTeams(debbie.Id);
        System.assertEquals(1, teams.size());
        teamsMatch(team, teams[0]);
    }

    @isTest
    public static void getRelatedTeams_ReturnsError() {
        Boolean hasError = false;
        try {
            List<Team__c> teams = TeamController.getRelatedTeams('debbie.Id');
        }
        catch (Exception exc) {
            hasError = true;
        }
        System.assert(hasError);
    }
}
