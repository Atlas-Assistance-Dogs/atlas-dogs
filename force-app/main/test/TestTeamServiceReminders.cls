@isTest
public with sharing class TestTeamServiceReminders {
    private static TeamService service;
    private static ITeamRepository teamRepo;
    private static ILogRepository logRepo;
    private static IRelationshipRepository relationshipRepo;
    private static IEmailService emailSrv;

    @TestSetup
    static void makeData(){
        teamRepo = new MockTeamRepository();
        logRepo = new MockLogRepository();
        relationshipRepo = new MockRelationshipRepository();
        emailSrv = new MockEmailService();
        service = new TeamService(teamRepo, logRepo, relationshipRepo, emailSrv);
    }

    @isTest
    static void createReminders_sendsEmailsToClients_InTraining() {
        //     Team__c team = createMockTeam();
        // createTeam();
        // Test.startTest();
        // TeamService.createReminders();
        // Integer invocations = Limits.getEmailInvocations();
        // Test.stopTest();
        // system.assertEquals(1, invocations, 'An email should be sent');
    }

}
