@isTest
public with sharing class TestCeuReminders {
  private static MockProvider mocks;
  private static CertificationService service;
  private static RelationshipRepository relationshipRepo;
  private static ContactRepository contactRepo;
  private static EmailService emailSrv;
  private static CertificationRepository certRepo;
  // references to mocks

  private static void makeData() {
    mocks = new MockProvider();
    contactRepo = (ContactRepository) mocks.createMock(ContactRepository.class);
    relationshipRepo = (RelationshipRepository) mocks.createMock(
      RelationshipRepository.class
    );
    emailSrv = (EmailService) mocks.createMock(EmailService.class);
    certRepo = (CertificationRepository) mocks.createMock(CertificationRepository.class);
    service = new CertificationService(certRepo, emailSrv);
  }
/*
  @isTest
  static void remindFacilitatorsToGetCeus_sendsNoEmails_whenNoFacilitators() {
    makeData();
    mocks.expectedCalls.add(
      new MockCallData(contactRepo, 'getActiveFacilitators', new Set<Id>())
    );
    service.remindFacilitatorsToGetCeus();

    // Assert
    System.assert(!mocks.actualCalls.isEmpty());
    // the first call would be to get facilitators
    MockCallData getFacilitators = mocks.actualCalls[0];
    System.assertEquals('getActiveFacilitators', getFacilitators.methodName);

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
  static void remindFacilitatorsToGetCeus_sendsEmailToFacilitator() {
    makeData();
    Id contactId = MockProvider.contactids[0];
    Id templateId = MockProvider.templateIds[0];
    mocks.expectedCalls.add(
      new MockCallData(
        contactRepo,
        'getActiveFacilitators',
        new Set<Id>{ contactId }
      )
    );
    mocks.expectedCalls.add(
      new MockCallData(
        emailSrv,
        'getOrgEmailAddressId',
        MockProvider.teamids[0]
      )
    );
    mocks.expectedCalls.add(
      new MockCallData(
        emailSrv,
        'getTemplate',
        new EmailTemplate(Id = templateId)
      )
    );
    mocks.expectedCalls.add(new MockCallData(emailSrv, 'sendEmail'));
    service.remindFacilitatorsToGetCeus();

    // Assert
    System.assert(!mocks.actualCalls.isEmpty());
    // the last call would be to send emails
    MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
    List<Messaging.SingleEmailMessage> emails = (List<Messaging.SingleEmailMessage>) data.args[0];
    System.assertEquals(1, emails.size());
    Messaging.SingleEmailMessage message = emails[0];
    System.assertEquals(contactId, message.targetobjectid);
    System.assertEquals(templateId, message.templateid);
  }*/
}
