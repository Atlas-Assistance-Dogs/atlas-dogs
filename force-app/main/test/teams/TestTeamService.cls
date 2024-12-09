/**
 * This class contains unit tests for validating the behavior of Apex class TeamService.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
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
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getPatStatus', teams));
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
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getPatStatus', teams));
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
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getPatStatus', teams));
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
        mocks.expectedCalls.add(new MockCallData(teamRepo, 'getPatStatus', teams));
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
}