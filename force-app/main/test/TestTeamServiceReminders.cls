@isTest
public with sharing class TestTeamServiceReminders {
    private static TeamService service;
    private static MockTeamRepository teamRepo;
    private static MockLogRepository logRepo;
    private static MockRelationshipRepository relationshipRepo;
    private static MockEmailService emailSrv;
    // references to mocks
    
    @TestSetup
    static void makeData(){
        teamRepo = new MockTeamRepository();
        logRepo = new MockLogRepository();
        relationshipRepo = new MockRelationshipRepository();
        emailSrv = new MockEmailService();
        service = new TeamService(teamRepo, logRepo, relationshipRepo, emailSrv);
    }
    
    private static final String[] teamids = new String[]{'a1BE200000K4ZN3MAN', 'a1BE200000K4ZN4MAN', 'a1BE200000K4ZN5MAN', 'a1BE200000K4ZN6MAN', 'a1BE200000K4ZN7MAN',
    'a1BE200000K4ZN8MAN', 'a1BE200000K4ZN9MAN', 'a1BE200000K4ZNAMA3', 'a1BE200000K4ZNBMA3', 'a1BE200000K4ZNCMA3'};
    
    private static final String[] contactids = new String[]{
        '003E200000WBWDeIAP',
        '003E200000WBWDfIAP',
        '003E200000WBWDgIAP',
        '003E200000WBWDhIAP' ,
        '003E200000WBWDiIAP' ,
        '003E200000WBWDjIAP' ,
        '003E200000WBWDkIAP' ,
        '003E200000WBWDlIAP' ,
        '003E200000WBWDmIAP' ,
        '003E200000WBWDnIAP' };
    private static final String templateId = '00XE20000053FkPMAU';
    private static final String template2Id = '00XE200000539jrMAA';
    @isTest
    static void createReminders_sendsEmailToClient_InTraining() {
        makeData();
        Team__c team = new Team__c(Id = teamids[0], Client__c = contactids[0], Status__c = 'In Training', TrainingStartDate__c = Date.today().addDays(-6));
        teamRepo.teams = new List<Team__c>{team};
        emailSrv.templateId = templateId;
        service.createReminders();
        System.assertEquals(1, emailSrv.sentEmails.size());
        Messaging.SingleEmailMessage message = emailSrv.sentEmails[0];
        System.assertEquals(team.Client__c, message.targetobjectid);
        System.assertEquals(team.Id, message.whatid);
        System.assertEquals(templateId, message.templateid);
    }

    @isTest
    static void createReminders_sendsEmailsToClients_InTraining() {
        makeData();
        Team__c[] teams = new Team__c[5];
        for (Integer i = 0; i < 5; i++) {
            teams[i] = new Team__c(Id = teamids[i], Client__c = contactids[i], Status__c = 'In Training', TrainingStartDate__c = Date.today().addDays(0 - i));
        }
        teamRepo.teams = teams;
        emailSrv.templateId = templateId;
        service.createReminders();
        System.assertEquals(5, emailSrv.sentEmails.size());
        for (Integer i = 0; i < 5; i++) {
            Team__c team = teams[i];
            Messaging.SingleEmailMessage message = emailSrv.sentEmails[i];
            System.assertEquals(team.Client__c, message.targetobjectid);
            System.assertEquals(team.Id, message.whatid);
            System.assertEquals(templateId, message.templateid);
        }
    }

}