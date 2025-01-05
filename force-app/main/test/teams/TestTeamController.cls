@isTest
public with sharing class TestTeamController {
    private static Contact debbie;
    private static Contact ken;
    private static Contact wanda;
    private static Dog__c ace;
    private static Team__c team;

    public static Team__c setup() {
        debbie = new Contact(FirstName = 'Debbie', LastName = 'Queen');
        ken = new Contact(FirstName = 'Ken', LastName = 'King');
        wanda = new Contact(FirstName = 'Wanda', LastName = 'Around');
        List<Contact> contacts = new List<Contact>{debbie, ken, wanda};
        insert contacts;

        ace = new Dog__c(Name = 'Ace');
        insert ace;

        team = new Team__c(
            Client__c = ken.Id,
            Dog__c = ace.Id,
            Handler__c = debbie.Id,
            Facilitator__c = wanda.Id,
            Name = 'Camelot',
            PatValidUntil__c = Date.today().addMonths(12),
            PatCount__c = 21,
            PrimaryCertification__c = 'Allergen Alert',
            SecondaryCertification__c = 'Autism',
            Status__c = 'Certified',
            TrainingStartDate__c = Date.today()
        );
        insert team;
        return team;
    }

    private static void teamsMatch(Team__c expected, Object actualObject) {
        Team__c actual = ((TeamRow)actualObject).team;
        System.assertEquals(expected.Id, actual.Id);
        System.assertEquals(expected.Client__c, actual.Client__c);
        System.assertEquals(expected.Dog__c, actual.Dog__c);
        System.assertEquals(expected.Handler__c, actual.Handler__c);
        System.assertEquals(expected.Name, actual.Name);
        System.assertEquals(expected.PatValidUntil__c, actual.PatValidUntil__c);
        System.assertEquals(expected.PatCount__c, actual.PatCount__c);
        System.assertEquals(expected.PrimaryCertification__c, actual.PrimaryCertification__c);
        System.assertEquals(expected.SecondaryCertification__c, actual.SecondaryCertification__c);
        System.assertEquals(expected.Status__c, actual.Status__c);
    }

    @isTest
    public static void getRelatedTeams_ReturnsRelatedToDog() {
        setup();
        RelatedObjects teams = TeamController.getRelatedTeams(ace.Id, 6);
        System.assertEquals(1, teams.items.size());
        System.assertEquals(1, teams.total);
        teamsMatch(team, teams.items[0]);
    }

    @isTest
    public static void getRelatedTeams_ReturnsRelatedToClient() {
        setup();
        RelatedObjects teams = TeamController.getRelatedTeams(ken.Id, 6);
        System.assertEquals(1, teams.items.size());
        System.assertEquals(1, teams.total);
        teamsMatch(team, teams.items[0]);
    }

    @isTest
    public static void getRelatedTeams_ReturnsRelatedToHandler() {
        setup();
        RelatedObjects teams = TeamController.getRelatedTeams(debbie.Id, 6);
        System.assertEquals(1, teams.items.size());
        System.assertEquals(1, teams.total);
        teamsMatch(team, teams.items[0]);
    }

    @isTest
    public static void getRelatedTeams_ReturnsError() {
        Boolean hasError = false;
        try {
            RelatedObjects teams = TeamController.getRelatedTeams('debbie.Id', 6);
        }
        catch (Exception exc) {
            hasError = true;
        }
        System.assert(hasError);
    }
}
