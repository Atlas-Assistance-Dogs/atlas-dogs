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

    private static List<Id> patids = new List<Id>{ 'a19E1000003lL45IAE' };
    private static void makeData(){
        mocks = new MockProvider();
        teamRepo = (TeamRepository)mocks.createMock(TeamRepository.class);
        dogRepo = (DogRepository)mocks.createMock(DogRepository.class);
        patRepo = (PublicAccessTestRepository)mocks.createMock(PublicAccessTestRepository.class);
        relationshipRepo = (RelationshipRepository)mocks.createMock(RelationshipRepository.class);
        ContactRepo = (ContactRepository)mocks.createMock(ContactRepository.class);
        emailSrv = (EmailService)mocks.createMock(EmailService.class);
        service = new TeamService(teamRepo, patRepo, relationshipRepo, emailSrv, dogRepo, contactRepo);
    }

    @isTest
    static void updatePatInformation_doesNothing_whenNoTeams() {
        // Arrange
        makeData();
        List<Team__c> teams = new List<Team__c>();
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getCertificationStatus', teams));
        mocks.expectedCalls.add(new MockCallData(patRepo, 'getPassing', new PublicAccessTest__c[]{}));

        // Act
        service.updatePatInformation(new Set<Id>());

        // Assert
        System.assert(!mocks.actualCalls.isEmpty());
        
        // the last call would be to update the teams
        MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
        List<Team__c> actual = (List<Team__c>)data.args[0];
        System.assert(actual.isEmpty());
    }

    @isTest
    static void updatePatInformation_clearsDates_whenNoPats() {
        // Arrange
        makeData();
        List<Team__c> teams = new List<Team__c>{
            new Team__c(Id = MockProvider.teamids[0], Client__c = MockProvider.contactids[0], InitialCertificationDate__c = Date.today(), PatValidUntil__c = Date.today().addYears(1))
        };
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getCertificationStatus', teams));
        mocks.expectedCalls.add(new MockCallData(patRepo, 'getPassing', new PublicAccessTest__c[]{}));

        // Act
        service.updatePatInformation(new Set<Id>{ MockProvider.teamids[0] });

        // Assert
        System.assert(!mocks.actualCalls.isEmpty());
        
        // the last call would be to update the teams
        MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
        List<Team__c> actual = (List<Team__c>)data.args[0];
        System.assertEquals(1, actual.size());
        System.assertEquals(null, actual[0].InitialCertificationDate__c);
        System.assertEquals(null, actual[0].PatValidUntil__c);
    }

    @isTest
    static void updatePatInformation_setsInitialCert_whenInitialPat() {
        // Arrange
        makeData();
        List<Team__c> teams = new List<Team__c>{
            new Team__c(Id = MockProvider.teamids[0], Client__c = MockProvider.contactids[0], InitialCertificationDate__c = null, PatValidUntil__c = null)
        };
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getCertificationStatus', teams));
        PublicAccessTest__c pat = new PublicAccessTest__c(Id = patids[0], Type__c = 'Initial', DateCompleted__c = Date.today(), ValidUntil__c = Date.today().addYears(1));
        mocks.expectedCalls.add(new MockCallData(patRepo, 'getPassing', new PublicAccessTest__c[] { pat }));

        // Act
        service.updatePatInformation(new Set<Id>{ MockProvider.teamids[0] });

        // Assert
        System.assert(!mocks.actualCalls.isEmpty());
        
        // the last call would be to update the teams
        MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
        List<Team__c> actual = (List<Team__c>)data.args[0];
        System.assertEquals(1, actual.size());
        System.assertEquals(pat.DateCompleted__c, actual[0].InitialCertificationDate__c);
    }

    @isTest
    static void updatePatInformation_setsValidUntil() {
        // Arrange
        makeData();
        List<Team__c> teams = new List<Team__c>{
            new Team__c(Id = MockProvider.teamids[0], Client__c = MockProvider.contactids[0], InitialCertificationDate__c = null, PatValidUntil__c = null)
        };
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getCertificationStatus', teams));
        PublicAccessTest__c pat = new PublicAccessTest__c(Id = patids[0], Type__c = 'Initial', DateCompleted__c = Date.today(), ValidUntil__c = Date.today().addYears(1));
        mocks.expectedCalls.add(new MockCallData(patRepo, 'getPassing', new PublicAccessTest__c[] { pat }));

        // Act
        service.updatePatInformation(new Set<Id>{ MockProvider.teamids[0] });

        // Assert
        System.assert(!mocks.actualCalls.isEmpty());
        
        // the last call would be to update the teams
        MockCallData data = mocks.actualCalls[mocks.actualCalls.size() - 1];
        List<Team__c> actual = (List<Team__c>)data.args[0];
        System.assertEquals(1, actual.size());
        System.assertEquals(pat.ValidUntil__c, actual[0].PatValidUntil__c);
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