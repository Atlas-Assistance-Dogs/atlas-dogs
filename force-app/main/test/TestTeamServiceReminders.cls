@isTest
public with sharing class TestTeamServiceReminders {
    private static MockProvider mocks;
    private static TeamService service;
    private static TeamRepository teamRepo;
    private static LogRepository logRepo;
    private static RelationshipRepository relationshipRepo;
    private static EmailService emailSrv;
    // references to mocks
    
    private static void makeData(){
        mocks = new MockProvider();
        teamRepo = (TeamRepository)mocks.createMock(TeamRepository.class);
        logRepo = (LogRepository)mocks.createMock(LogRepository.class);
        relationshipRepo = (RelationshipRepository)mocks.createMock(RelationshipRepository.class);
        emailSrv = (EmailService)mocks.createMock(EmailService.class);
        service = new TeamService(teamRepo, logRepo, relationshipRepo, emailSrv);
    }
    
    private static final String[] teamids = new String[]{'a1BE200000K4ZN3MAN', 'a1BE200000K4ZN4MAN', 'a1BE200000K4ZN5MAN', 'a1BE200000K4ZN6MAN', 'a1BE200000K4ZN7MAN',
    'a1BE200000K4ZN8MAN', 'a1BE200000K4ZN9MAN', 'a1BE200000K4ZNAMA3', 'a1BE200000K4ZNBMA3', 'a1BE200000K4ZNCMA3'};
    
    private static final String[] contactids = new String[]{
        '003E200000WBWDeIAP',
        '003E200000WBWDfIAP',
        '003E200000WBWDgIAP',
        '003E200000WBWDhIAP',
        '003E200000WBWDiIAP',
        '003E200000WBWDjIAP',
        '003E200000WBWDkIAP',
        '003E200000WBWDlIAP',
        '003E200000WBWDmIAP',
        '003E200000WBWDnIAP'
    };

    private static final String[] relationshipids = new String[]{
        'a0FE2000003J7gsMAC', 'a0FE2000003J7gtMAC',
        'a0FE2000003J9icMAC' ,
        'a0FE2000003J9idMAC' ,
        'a0FE2000003JC6zMAG' ,
        'a0FE2000003JC70MAG' ,
        'a0FE2000003JC8bMAG' ,
        'a0FE2000003JC8cMAG' 
    };
    private static final String templateId = '00XE20000053FkPMAU';
    private static final String template2Id = '00XE200000539jrMAA';
    
    @isTest
    static void remindClients_sendsNoEmails_whenNoTeams() {
        makeData();
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getByStatus', new List<Team__c>()));
        service.remindClients();
        
        // Assert
        System.assert(!mocks.actualCalls.isEmpty());
        // the first call would be to get teams
        MockCallData getTeams = mocks.actualCalls[0];
        System.assertEquals('getByStatus', getTeams.methodName);
        System.assertEquals('In Training', getTeams.args[0]);

        // see if there is a call to sendEmail, if there is, there should be no emails
        for (MockCallData call : mocks.actualCalls) {
            if (call.obj == emailSrv && call.methodName == 'sendEmail') {
                System.assert(((List<Messaging.SingleEmailMessage>)call.args[0]).isEmpty());
            }
        }
    }
   
    @isTest
    static void remindClients_sendsEmailToClient_InTraining() {
        makeData();
        mocks.expectedCalls.add(new MockCallData(emailSrv, 'getTemplate', new EmailTemplate(Id = templateId)));
        mocks.expectedCalls.add(new MockCallData(emailSrv, 'sendEmail'));
        Team__c team = new Team__c(Id = teamids[0], Client__c = contactids[0], Status__c = 'In Training', TrainingStartDate__c = Date.today().addDays(-6));
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getByStatus', new List<Team__c>{team}));
        service.remindClients();
        
        // Assert
        System.assert(!mocks.actualCalls.isEmpty());
        // the first call would be to get teams
        MockCallData getTeams = mocks.actualCalls[0];
        System.assertEquals('getByStatus', getTeams.methodName);
        System.assertEquals('In Training', getTeams.args[0]);
        // the last call would be to send emails
        MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
        List<Messaging.SingleEmailMessage> emails = (List<Messaging.SingleEmailMessage>)data.args[0];
        System.assertEquals(1, emails.size());
        Messaging.SingleEmailMessage message = emails[0];
        System.assertEquals(team.Client__c, message.targetobjectid);
        System.assertEquals(team.Id, message.whatid);
        System.assertEquals(templateId, message.templateid);
    }
    
    @isTest
    static void remindClients_sendsEmailsToClients_InTraining() {
        makeData();
        Team__c[] teams = new Team__c[5];
        for (Integer i = 0; i < 5; i++) {
            teams[i] = new Team__c(Id = teamids[i], Client__c = contactids[i], Status__c = 'In Training', TrainingStartDate__c = Date.today().addDays(0 - i));
        }
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getByStatus', teams));
        mocks.expectedCalls.add(new MockCallData(emailSrv, 'getTemplate', new EmailTemplate(Id = templateId)));
        mocks.expectedCalls.add(new MockCallData(emailSrv, 'sendEmail'));
        service.remindClients();
        
        // Assert
        // the last call would be to send emails
        MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
        List<Messaging.SingleEmailMessage> emails = (List<Messaging.SingleEmailMessage>)data.args[0];
        for (Integer i = 0; i < 5; i++) {
            Team__c team = teams[i];
            Messaging.SingleEmailMessage message = emails[i];
            System.assertEquals(team.Client__c, message.targetobjectid);
            System.assertEquals(team.Id, message.whatid);
            System.assertEquals(templateId, message.templateid);
        }
    }
    
    @isTest
    static void remindFacilitators_sendsEmailsToFacilitators() {
        makeData();
        mocks.expectedCalls.add(new MockCallData(emailSrv, 'getTemplate', new EmailTemplate(Id = templateId)));
        mocks.expectedCalls.add(new MockCallData(emailSrv, 'sendEmail'));
        Team__c team = new Team__c(Id = teamids[0], Client__c = contactids[0], Status__c = 'In Training', TrainingStartDate__c = Date.today().addDays(-6));
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getByStatus', new List<Team__c>{team}));
        List<npe4__Relationship__c> relationships = new List<npe4__Relationship__c>{
            new npe4__Relationship__c(Id = relationshipids[0], npe4__Contact__c = contactids[0], npe4__RelatedContact__c = contactids[1]),
            new npe4__Relationship__c(Id = relationshipids[1], npe4__Contact__c = contactids[0], npe4__RelatedContact__c = contactids[2])
        };
        Set<Id> facilitatorIds = new Set<Id>{contactids[1], contactids[2]};
        mocks.expectedCalls.add(new MockCallData(relationshipRepo, 'getCurrentRelated', relationships));
        service.remindFacilitators();
        
        // Assert
        System.assert(!mocks.actualCalls.isEmpty());
        // the first call would be to get teams
        MockCallData getTeams = mocks.actualCalls[0];
        System.assertEquals('In Training', getTeams.args[0]);

        // the fourth call would be to get facilitators
        MockCallData getFac;
        for (MockCallData mockCall : mocks.actualCalls) {
            if (mockCall.obj == relationshipRepo) {
                getFac = mockCall;
                break;
            }
        }
        System.assertNotEquals(null, getFac);
        // first parameter is client contact id
        System.assertEquals(new Set<Id>{contactids[0]}, getFac.args[0]);
        // second parameter is type
        System.assertEquals('Team Faciliator', getFac.args[1]);

        // the last call would be to send emails
        MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
        List<Messaging.SingleEmailMessage> emails = (List<Messaging.SingleEmailMessage>)data.args[0];
        System.assertEquals(2, emails.size());
        for (Messaging.SingleEmailMessage message : emails) {
            System.assert(facilitatorIds.contains(message.targetobjectid));
            System.assertEquals(team.Id, message.whatid);
            System.assertEquals(templateId, message.templateid);
            facilitatorIds.remove(message.targetobjectid);
        }
    }
    
    @isTest
    static void remindFacilitators_sendsNoEmails_whenNoFacilitators() {
        makeData();
        mocks.expectedCalls.add(new MockCallData(emailSrv, 'getTemplate', new EmailTemplate(Id = templateId)));
        mocks.expectedCalls.add(new MockCallData(emailSrv, 'sendEmail'));
        Team__c team = new Team__c(Id = teamids[0], Client__c = contactids[0], Status__c = 'In Training', TrainingStartDate__c = Date.today().addDays(-6));
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getByStatus', new List<Team__c>{team}));
        List<npe4__Relationship__c> relationships = new List<npe4__Relationship__c>{};
        mocks.expectedCalls.add(new MockCallData(relationshipRepo, 'getCurrentRelated', relationships));
        service.remindFacilitators();
        
        // Assert
        System.assert(!mocks.actualCalls.isEmpty());

        // the last call would be to send emails
        MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
        List<Messaging.SingleEmailMessage> emails = (List<Messaging.SingleEmailMessage>)data.args[0];
        System.assertEquals(0, emails.size());
    }
    
}