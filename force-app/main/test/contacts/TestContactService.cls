@isTest
private class TestContactService {
  private static MockProvider mocks;
  private static ContactService service;
  private static ContactRepository contactRepo;
  private static RelationshipRepository relationshipRepo;
  private static EmailService emailSrv;
  private static CertificationService certService;
  // references to mocks

  private static void makeData() {
    mocks = new MockProvider();
    contactRepo = (ContactRepository) mocks.createMock(ContactRepository.class);
    relationshipRepo = (RelationshipRepository) mocks.createMock(
      RelationshipRepository.class
    );
    emailSrv = (EmailService) mocks.createMock(EmailService.class);
    certService = (CertificationService) mocks.createMock(
      CertificationService.class
    );
    service = new ContactService(
      contactRepo,
      relationshipRepo,
      emailSrv,
      certService
    );
  }

  @isTest
  static void getPositionStatusForContact_returnsEmptyList_whenNoPositions() {
    makeData();
    mocks.expectedCalls.add(
      new MockCallData(
        contactRepo,
        'getPositionStatusForContact',
        new Contact()
      )
    );
    // Act
    List<PositionStatus> result = service.getPositionStatusForContact(
      MockProvider.createId(Contact.class)
    );
    // Assert
    System.assert(result.isEmpty());
  }

  @isTest
  static void getPositionStatusForContact_returnsActive_whenStaffEmployee() {
    makeData();
    Contact person = new Contact(
      Id = MockProvider.createId(Contact.class),
      Positions__c = 'Staff',
      StaffStatus__c = 'Employee'
    );
    mocks.expectedCalls.add(
      new MockCallData(contactRepo, 'getPositionStatusForContact', person)
    );
    // Act
    List<PositionStatus> result = service.getPositionStatusForContact(
      person.Id
    );
    // Assert
    System.assertEquals(1, result.size());
    PositionStatus actual = result[0];
    System.assertEquals('Staff', actual.position);
    System.assertEquals('Active', actual.status);
  }

  @isTest
  static void getPositionStatusForContact_returnsActive_whenStaffContractor() {
    makeData();
    Contact person = new Contact(
      Id = MockProvider.createId(Contact.class),
      Positions__c = 'Staff',
      StaffStatus__c = 'Contractor'
    );
    mocks.expectedCalls.add(
      new MockCallData(contactRepo, 'getPositionStatusForContact', person)
    );
    // Act
    List<PositionStatus> result = service.getPositionStatusForContact(
      person.Id
    );
    // Assert
    System.assertEquals(1, result.size());
    PositionStatus actual = result[0];
    System.assertEquals('Staff', actual.position);
    System.assertEquals('Active', actual.status);
  }

  @isTest
  static void getPositionStatusForContact_returnsInactive_whenStaffInactive() {
    makeData();
    Contact person = new Contact(
      Id = MockProvider.createId(Contact.class),
      Positions__c = 'Staff',
      StaffStatus__c = 'Inactive'
    );
    mocks.expectedCalls.add(
      new MockCallData(contactRepo, 'getPositionStatusForContact', person)
    );
    // Act
    List<PositionStatus> result = service.getPositionStatusForContact(
      person.Id
    );
    // Assert
    System.assertEquals(1, result.size());
    PositionStatus actual = result[0];
    System.assertEquals('Staff', actual.position);
    System.assertEquals('Inactive', actual.status);
  }

  @isTest
  static void getPositionStatusForContact_returnsNone_whenStaffNone() {
    makeData();
    Contact person = new Contact(
      Id = MockProvider.createId(Contact.class),
      Positions__c = 'Staff',
      StaffStatus__c = 'None'
    );
    mocks.expectedCalls.add(
      new MockCallData(contactRepo, 'getPositionStatusForContact', person)
    );
    // Act
    List<PositionStatus> result = service.getPositionStatusForContact(
      person.Id
    );
    // Assert
    System.assertEquals(1, result.size());
    PositionStatus actual = result[0];
    System.assertEquals('Staff', actual.position);
    System.assertEquals('None', actual.status);
  }
  /*
    @isTest
    static void
    updateCertValidUntil_changesTrainerCertValidUntil_when30daysBefore() {
      AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
      upsert settings;
      Date received = Date.newInstance(2022, 12, 25);

      Contact joe = new Contact(
        Id = MockCallData.contactids[0],
        Email = 'joe-blow@pump.com',
        FirstName = 'Joe',
        LastName = 'Blow',
        Positions__c = 'Trainer',
        TrainerInitialCertificationDate__c = received,
        TrainerCertAgreementReceived__c = received,
        TrainerCertValidUntil__c = received.addYears(1)
      );

      joe.TrainerCertAgreementReceived__c = received.addYears(1).addDays(-30);

      // Act
      Test.startTest();
      Database.SaveResult result = Database.update(joe, true);
      Test.stopTest();

      // Assert
      System.assert(result.isSuccess());
      Contact saved = [
        SELECT id, TrainerInitialCertificationDate__c, TrainerCertValidUntil__c
        FROM Contact
        WHERE id = :result.getId()
      ];
      System.assert(result.getErrors().size() == 0);
      System.assertEquals(received, saved.TrainerInitialCertificationDate__c);
      System.assertEquals(received.addYears(2), saved.TrainerCertValidUntil__c);
    }*/
}
