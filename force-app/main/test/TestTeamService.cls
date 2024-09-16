@isTest
private class TestTeamService {
    private static Contact joe;
    private static Contact jack;
    private static Dog__c buddy;
    private static Team__c team;

    private static void createTeam() {
        joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Blow',
            email = 'joe@test.org'
        );
        jack = new Contact(
            FirstName = 'Jack',
            LastName = 'Nimble',
            email = 'jack@test.org'
        );
        buddy = new Dog__c(Name = 'Buddy');
        insert new List<Contact>{ joe, jack };
        insert buddy;
        team = new Team__c(
            Client__c = joe.Id,
            Dog__c = buddy.Id,
            Facilitator__c = jack.Id,
            Status__c = 'In Training',
            TrainingStartDate__c = Date.today()
        );
        insert team;
        // TODO: prevent creating duplicate relationships
        // npe4__Relationship__c relationship = new npe4__Relationship__c(
        //     npe4__Contact__c = joe.Id,
        //     npe4__RelatedContact__c = jack.Id,
        //     npe4__Status__c = 'Current',
        //     npe4__Type__c = 'Team Faciliator'
        // );
        // insert relationship;
    }
    @isTest
    static void createReminders_sendsNoEmailWhenNoTeamsInTraining() {
        createTeam();
        team.Status__c = 'Certified';
        update team;
        Test.startTest();
        TeamService.createReminders();
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(0, invocations, 'An email should be sent');
    }
    @isTest
    static void createReminders_sendsEmailToClient_InTraining() {
        createTeam();
        Test.startTest();
        TeamService.createReminders();
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(1, invocations, 'An email should be sent');
    }
    @isTest
    static void createReminders_sendsEmailToClientAndFacilitator_InTraining() {
        createTeam();
        team.TrainingStartDate__c = Date.today().addDays(-10);
        update team;
        Test.startTest();
        TeamService.createReminders();
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(2, invocations, 'Two emails should be sent');
    }
    @isTest
    static void createReminders_sendsEmailToClientsAndFacilitator_InTraining() {
        createTeam();
        Contact jill = new Contact(
            FirstName = 'Jill',
            LastName = 'Hill',
            email = 'jill@test.org'
        );
        insert jill;
        Team__c team2 = new Team__c(
            Name = 'Jill_Buddy',
            Client__c = jill.Id,
            Dog__c = buddy.Id,
            Facilitator__c = jack.Id,
            Status__c = 'In Training',
            TrainingStartDate__c = Date.today().addDays(-10)
        );
        insert team2;
        npe4__Relationship__c relationship = new npe4__Relationship__c(
            npe4__Contact__c = jill.Id,
            npe4__RelatedContact__c = jack.Id,
            npe4__Status__c = 'Current',
            npe4__Type__c = 'Team Faciliator'
        );
        insert relationship;
        Test.startTest();
        TeamService.createReminders();
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(3, invocations, 'Three emails should be sent');
    }
}
