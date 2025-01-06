@isTest
private class TestContactService {
  private static MockProvider mocks;
  private static ContactService service;
  private static ContactRepository contactRepo;
  private static RelationshipRepository relationshipRepo;
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
    service = new ContactService(contactRepo, relationshipRepo, emailSrv, certRepo);
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
      MockProvider.contactids[0]
    );
    // Assert
    System.assert(result.isEmpty());
  }

  @isTest
  static void getPositionStatusForContact_returnsActive_whenStaffEmployee() {
    makeData();
    mocks.expectedCalls.add(
      new MockCallData(
        contactRepo,
        'getPositionStatusForContact',
        new Contact(Positions__c = 'Staff', StaffStatus__c = 'Employee')
      )
    );
    // Act
    List<PositionStatus> result = service.getPositionStatusForContact(
      MockProvider.contactids[0]
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
    mocks.expectedCalls.add(
      new MockCallData(
        contactRepo,
        'getPositionStatusForContact',
        new Contact(Positions__c = 'Staff', StaffStatus__c = 'Contractor')
      )
    );
    // Act
    List<PositionStatus> result = service.getPositionStatusForContact(
      MockProvider.contactids[0]
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
    mocks.expectedCalls.add(
      new MockCallData(
        contactRepo,
        'getPositionStatusForContact',
        new Contact(Positions__c = 'Staff', StaffStatus__c = 'Inactive')
      )
    );
    // Act
    List<PositionStatus> result = service.getPositionStatusForContact(
      MockProvider.contactids[0]
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
    mocks.expectedCalls.add(
      new MockCallData(
        contactRepo,
        'getPositionStatusForContact',
        new Contact(Positions__c = 'Staff', StaffStatus__c = 'None')
      )
    );
    // Act
    List<PositionStatus> result = service.getPositionStatusForContact(
      MockProvider.contactids[0]
    );
    // Assert
    System.assertEquals(1, result.size());
    PositionStatus actual = result[0];
    System.assertEquals('Staff', actual.position);
    System.assertEquals('None', actual.status);
  }
}
