@isTest
public with sharing class TestTeamServiceReminders {
  private static MockProvider mocks;
  private static TeamService service;
  private static TeamRepository teamRepo;
  private static PublicAccessTestRepository patRepo;
  private static DogRepository dogRepo;
  private static RelationshipRepository relationshipRepo;
  private static ContactRepository contactRepo;
  private static EmailService emailSrv;
  // references to mocks

  private static void makeData() {
    mocks = new MockProvider();
    teamRepo = (TeamRepository) mocks.createMock(TeamRepository.class);
    dogRepo = (DogRepository) mocks.createMock(DogRepository.class);
    patRepo = (PublicAccessTestRepository) mocks.createMock(
      PublicAccessTestRepository.class
    );
    relationshipRepo = (RelationshipRepository) mocks.createMock(
      RelationshipRepository.class
    );
    ContactRepo = (ContactRepository) mocks.createMock(ContactRepository.class);
    emailSrv = (EmailService) mocks.createMock(EmailService.class);
    service = new TeamService(
      teamRepo,
      patRepo,
      relationshipRepo,
      emailSrv,
      dogRepo,
      contactRepo
    );
  }

  @isTest
  static void remindClients_sendsNoEmails_whenNoTeams() {
    makeData();
    mocks.expectedCalls.add(
      new MockCallData(teamRepo, 'getByStatus', new List<Team__c>())
    );
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
        System.assert(
          ((List<Messaging.SingleEmailMessage>) call.args[0]).isEmpty()
        );
      }
    }
  }

  @isTest
  static void remindClients_sendsEmailToClient_InTraining() {
    makeData();
    mocks.expectedCalls.add(
      new MockCallData(
        emailSrv,
        'getTemplate',
        new EmailTemplate(Id = MockProvider.templateIds[0])
      )
    );
    mocks.expectedCalls.add(new MockCallData(emailSrv, 'sendEmail'));
    Team__c team = new Team__c(
      Id = MockProvider.teamids[0],
      Client__c = MockProvider.contactids[0],
      Status__c = 'In Training',
      TrainingStartDate__c = Date.today().addDays(-6)
    );
    mocks.expectedCalls.add(
      new MockCallData(teamRepo, 'getByStatus', new List<Team__c>{ team })
    );
    service.remindClients();

    // Assert
    System.assert(!mocks.actualCalls.isEmpty());
    // the first call would be to get teams
    MockCallData getTeams = mocks.actualCalls[0];
    System.assertEquals('getByStatus', getTeams.methodName);
    System.assertEquals('In Training', getTeams.args[0]);
    // the last call would be to send emails
    MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
    List<Messaging.SingleEmailMessage> emails = (List<Messaging.SingleEmailMessage>) data.args[0];
    System.assertEquals(1, emails.size());
    Messaging.SingleEmailMessage message = emails[0];
    System.assertEquals(team.Client__c, message.targetobjectid);
    System.assertEquals(team.Id, message.whatid);
    System.assertEquals(MockProvider.templateIds[0], message.templateid);
  }

  @isTest
  static void remindClients_sendsEmailsToClients_InTraining() {
    makeData();
    Team__c[] teams = new Team__c[5];
    for (Integer i = 0; i < 5; i++) {
      teams[i] = new Team__c(
        Id = MockProvider.teamids[i],
        Client__c = MockProvider.contactids[i],
        Status__c = 'In Training',
        TrainingStartDate__c = Date.today().addDays(0 - i)
      );
    }
    mocks.expectedCalls.add(new MockCallData(teamRepo, 'getByStatus', teams));
    mocks.expectedCalls.add(
      new MockCallData(
        emailSrv,
        'getTemplate',
        new EmailTemplate(Id = MockProvider.templateIds[0])
      )
    );
    mocks.expectedCalls.add(new MockCallData(emailSrv, 'sendEmail'));
    service.remindClients();

    // Assert
    // the last call would be to send emails
    MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
    List<Messaging.SingleEmailMessage> emails = (List<Messaging.SingleEmailMessage>) data.args[0];
    for (Integer i = 0; i < 5; i++) {
      Team__c team = teams[i];
      Messaging.SingleEmailMessage message = emails[i];
      System.assertEquals(team.Client__c, message.targetobjectid);
      System.assertEquals(team.Id, message.whatid);
      System.assertEquals(MockProvider.templateIds[0], message.templateid);
    }
  }

  private static Map<Id, Id> facilitatorToTeamIds = new Map<Id, Id>();
  private static Set<Id> facilitatorIds = new Set<Id>();
  private static Set<Id> clientIds = new Set<Id>();

  private static void setupCalls(Integer[] daysTraining) {
    makeData();
    mocks.expectedCalls.add(
      new MockCallData(
        emailSrv,
        'getTemplate',
        new EmailTemplate(Id = MockProvider.templateIds[0])
      )
    );
    mocks.expectedCalls.add(new MockCallData(emailSrv, 'sendEmail'));
    List<Team__c> teams = new List<Team__c>();
    for (Integer i = 0; i < daysTraining.size(); i++) {
      Integer days = daysTraining[i];
      teams.add(
        new Team__c(
          Id = MockProvider.teamids[i],
          Client__c = MockProvider.contactids[i],
          Status__c = 'In Training',
          TrainingStartDate__c = Date.today().addDays(0 - days)
        )
      );
    }
    mocks.expectedCalls.add(new MockCallData(teamRepo, 'getByStatus', teams));
    facilitatorToTeamIds = new Map<Id, Id>();
    facilitatorIds = new Set<Id>();
    clientIds = new Set<Id>();
    List<npe4__Relationship__c> relationships = new List<npe4__Relationship__c>();
    for (Integer i = 0; i < daysTraining.size(); i++) {
      Id currentId = MockProvider.contactids[9 - i];
      relationships.add(
        new npe4__Relationship__c(
          Id = MockProvider.relationshipids[i],
          npe4__Contact__c = MockProvider.contactids[i],
          npe4__RelatedContact__c = currentId
        )
      );
      facilitatorIds.add(currentId);
      clientIds.add(MockProvider.contactids[i]);
      facilitatorToTeamIds.put(currentId, MockProvider.teamids[i]);
    }
    mocks.expectedCalls.add(
      new MockCallData(relationshipRepo, 'getCurrentRelated', relationships)
    );
  }

  @isTest
  static void remindFacilitators_sendsEmailsToFacilitators() {
    // Arrange
    setupCalls(new List<Integer>{ 7, 14 + 8, 28 + 9, 14 * 3 + 10, 11, 12, 13 });
    // Act
    service.remindFacilitators();

    // Assert
    System.assert(!mocks.actualCalls.isEmpty());
    // the first call would be to get teams
    MockCallData getTeams = mocks.actualCalls[0];
    System.assertEquals('In Training', getTeams.args[0]);

    // find the call to get facilitators
    MockCallData getFac;
    for (MockCallData mockCall : mocks.actualCalls) {
      if (mockCall.obj == relationshipRepo) {
        getFac = mockCall;
        break;
      }
    }
    System.assertNotEquals(null, getFac);
    // first parameter is client contact ids
    System.assertEquals(clientIds, getFac.args[0]);
    // second parameter is type
    System.assertEquals('Team Faciliator', getFac.args[1]);

    // the last call would be to send emails
    MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
    List<Messaging.SingleEmailMessage> emails = (List<Messaging.SingleEmailMessage>) data.args[0];
    System.assertEquals(7, emails.size());
    for (Messaging.SingleEmailMessage message : emails) {
      System.assert(facilitatorIds.contains(message.targetobjectid));
      System.assertEquals(
        facilitatorToTeamIds.get(message.targetObjectId),
        message.whatid
      );
      System.assertEquals(MockProvider.templateIds[0], message.templateid);
      facilitatorIds.remove(message.targetobjectid);
    }
  }

  @isTest
  static void remindFacilitators_doesNotSendEmailsOnEvenWeeks() {
    // Arrange
    setupCalls(new List<Integer>{ 0, 1, 14, 28, 30, 14 * 26 + 2, 14 * 5 + 5 });
    // Act
    service.remindFacilitators();

    // Assert
    System.assert(!mocks.actualCalls.isEmpty());
    // the fourth call would be to get facilitators
    MockCallData getFac;
    MockCallData sendEmail;
    for (MockCallData mockCall : mocks.actualCalls) {
      if (mockCall.obj == relationshipRepo) {
        getFac = mockCall;
      }
      if (mockCall.obj == emailSrv && mockCall.methodName == 'sendEmail') {
        sendEmail = mockCall;
      }
    }
    System.assertEquals(null, getFac);
    System.assertEquals(null, sendEmail);
  }

  @isTest
  static void remindFacilitators_sendsNoEmailWhenTrainingJustStarted() {
    // Arrange
    setupCalls(new List<Integer>{ 1 });
    // Act
    service.remindFacilitators();

    // Assert
    System.assert(!mocks.actualCalls.isEmpty());
    // the first call would be to get teams
    MockCallData getTeams = mocks.actualCalls[0];
    System.assertEquals('In Training', getTeams.args[0]);

    // the fourth call would be to get facilitators
    MockCallData getFac;
    MockCallData sendEmail;
    for (MockCallData mockCall : mocks.actualCalls) {
      if (mockCall.obj == relationshipRepo) {
        getFac = mockCall;
      }
      if (mockCall.obj == emailSrv && mockCall.methodName == 'sendEmail') {
        sendEmail = mockCall;
      }
    }
    System.assertEquals(null, getFac);
    System.assertEquals(null, sendEmail);
  }

  @isTest
  static void remindFacilitators_sendsNoEmails_whenNoFacilitators() {
    makeData();
    mocks.expectedCalls.add(
      new MockCallData(
        emailSrv,
        'getTemplate',
        new EmailTemplate(Id = MockProvider.templateIds[0])
      )
    );
    mocks.expectedCalls.add(new MockCallData(emailSrv, 'sendEmail'));
    Team__c team = new Team__c(
      Id = MockProvider.teamids[0],
      Client__c = MockProvider.contactids[0],
      Status__c = 'In Training',
      TrainingStartDate__c = Date.today().addDays(-8)
    );
    mocks.expectedCalls.add(
      new MockCallData(teamRepo, 'getByStatus', new List<Team__c>{ team })
    );
    List<npe4__Relationship__c> relationships = new List<npe4__Relationship__c>{};
    mocks.expectedCalls.add(
      new MockCallData(relationshipRepo, 'getCurrentRelated', relationships)
    );
    service.remindFacilitators();

    // Assert
    System.assert(!mocks.actualCalls.isEmpty());

    // the last call would be to send emails
    MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
    List<Messaging.SingleEmailMessage> emails = (List<Messaging.SingleEmailMessage>) data.args[0];
    System.assertEquals(0, emails.size());
  }
}
