/**
 * This class contains unit tests for validating the behavior of Apex classe TeamService.
 */
@isTest
private class TestTeamService {
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
    static void updateDogStatus_updatesDogStatusAndXrayRequired() {
        makeData();
        Dog__c dog = new Dog__c(Name = 'fido', Id = MockProvider.createId(Dog__c.class));
        mocks.expectedCalls.add(new MockCallData(dogRepo, 'getById', dog));
        Team__c team = new Team__c(Id = MockProvider.createId(Team__c.class), Name = 'team1', Dog__c = dog.Id, Status__c = 'Active', XrayRequired__c = true);
        // act
        service.updateDogStatus(team);
        // assert
        System.assertEquals(2, mocks.actualCalls.size(), 'Only 2 method calls should be made');
        Dog__c actual = (Dog__c)mocks.actualCalls[1].args[0];
        System.assertEquals('Active', actual.Status__c, 'Should match team status');
        System.assertEquals(true, actual.XrayRequired__c, 'Should match team x-ray required');
    }

    @isTest
    static void updateClientStatus_updatesClient() {
        makeData();
        Contact client = new Contact(Id = MockProvider.createId(Contact.class), LastName = 'Doe', FirstName = 'Jane');
        mocks.expectedCalls.add(new MockCallData(contactRepo, 'getClientStatus', client));
        Dog__c dog = new Dog__c(Name = 'fido', Id = MockProvider.createId(Dog__c.class));
        mocks.expectedCalls.add(new MockCallData(dogRepo, 'getById', dog));
        Team__c team = new Team__c(
          Id = MockProvider.createId(Team__c.class), Name = 'team1', Dog__c = dog.Id, Client__c = client.Id,
          Status__c = 'Active', PatValidUntil__c = Date.today().addMonths(5), PatCount__c = 1,
          InitialCertificationDate__c = Date.today().addYears(-2), FacilitatorAvailability__c = 'Available'
        );
        // act
        service.updateClientStatus(team);
        // assert
        System.assertEquals(3, mocks.actualCalls.size(), 'Only 3 method calls should be made');
        Contact actual = (Contact)mocks.actualCalls[2].args[0];
        System.assertEquals(team.Status__c, actual.ClientStatus__c, 'Should match team name');
        System.assertEquals(team.PatValidUntil__c, actual.ClientCertificationValidUntil__c, 'should match team pat-valid-until');
        System.assertEquals(team.InitialCertificationDate__c, actual.ClientInitialCertificationDate__c, 'should match team initial cert data');
        System.assertEquals(team.FacilitatorAvailability__c, actual.ClientFacilitatorAvailability__c, 'should match team facilitator availability');
        System.assertEquals(dog.Name, actual.ClientDog__c, 'should match dog name');
    }
}