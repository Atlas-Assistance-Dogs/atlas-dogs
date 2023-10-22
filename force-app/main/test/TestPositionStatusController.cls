@isTest
public with sharing class TestPositionStatusController {
    @isTest
    public static void getPositionStatusForContact_ReturnsEmptyList_WhenNoPositions() {
        // Arrange
        Contact joe = new Contact(FirstName = 'Joe', LastName = 'Blow');
        insert joe;

        // Act
        List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
            joe.Id
        );

        // Assert
        System.assert(statuses.isEmpty());
    }

    @isTest
    public static void getPositionStatusForContact_ReturnsEmptyList_WhenPositionsBlank() {
        // Arrange
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Blow',
            Positions__c = ''
        );
        insert joe;

        // Act
        List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
            joe.Id
        );

        // Assert
        System.assert(statuses.isEmpty());
    }

    private static final List<PositionStatus> EXPECTED_POSITION_STATUSES = new List<PositionStatus>{
        new PositionStatus('Volunteer', 'Active'),
        new PositionStatus(
            PositionStatusController.POSITION_LIST[1],
            'Certified-Active'
        ),
        new PositionStatus(
            PositionStatusController.POSITION_LIST[2],
            'Inactive'
        ),
        new PositionStatus(
            PositionStatusController.POSITION_LIST[3],
            'Onboarding'
        ),
        new PositionStatus(
            PositionStatusController.POSITION_LIST[4],
            'In Training'
        ),
        new PositionStatus(
            PositionStatusController.POSITION_LIST[5],
            'Suspended'
        ),
        new PositionStatus(PositionStatusController.POSITION_LIST[6], 'Initial Inquiry')
    };

    private static Contact joe;

    private static Id setupFullStatus() {
        joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Blow',
            Positions__c = 'Client;Volunteer;Trainer;Team Facilitator;Team Facilitator Lead;Puppy Raiser;Board Member;Standalone',
            GW_Volunteers__Volunteer_Status__c = 'Active',
            FacilitatorStatus__c = 'Certified-Active',
            FacilitatorCertAgreementReceived__c = Date.today().addDays(-250),
            PuppyRaiserStatus__c = 'Inactive',
            PuppyCertAgreementReceived__c = Date.today().addDays(-400),
            BoardMemberStatus__c = 'Onboarding',
            ClientStatus__c = 'In Training',
            ClientCertificationValidUntil__c = Date.today().addDays(300),
            StandaloneStatus__c = 'Initial Inquiry',
            TrainerStatus__c = 'Suspended',
            TrainerCertAgreementReceived__c = Date.today()
        );
        insert joe;
        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;
        Program__c program = new Program__c(
            Name = 'Super Dogs',
            Standalone__c = true,
            Months__c = 6
        );
        insert program;
        ProgramAssignment__c pa = new ProgramAssignment__c(
            Contact__c = joe.Id,
            Program__c = program.Id,
            AssignedDate__c = Date.today()
        );
        insert pa;
        return joe.Id;
    }

    @isTest
    public static void getPositionStatusForContact_ReturnsFullList_WhenPositionsFull() {
        // Arrange
        Id joeId = setupFullStatus();

        // Act
        List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
            joeId
        );

        // Assert
        Integer idx = 0;
        for (PositionStatus ps : EXPECTED_POSITION_STATUSES) {
            PositionStatus status = statuses[idx++];
            System.assertEquals(ps.position, status.position);
            System.assertEquals(ps.status, status.status);
        }
    }

    @isTest
    public static void getPositionStatusForContact_ReturnsVolunteer_WhenUserVolunteer() {
        // Arrange
        Id joeId = setupFullStatus();

        User buddy = TestUtilities.createUser('Minimum Access - Salesforce');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasBase');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasVolunteer');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joeId
            );

            // Assert
            System.assertEquals(1, statuses.size());
            PositionStatus volunteerStatus = statuses[0];
            System.assertEquals(EXPECTED_POSITION_STATUSES[0].position, volunteerStatus.position);
            System.assertEquals(EXPECTED_POSITION_STATUSES[0].status, volunteerStatus.status);
        }
    }

    @isTest
    public static void getPositionStatusForContact_ReturnsFacilitator_WhenContactTeamFacilitatorLead() {
        // Arrange
        Id joeId = setupFullStatus();
        joe.Positions__c = 'Team Facilitator Lead';
        update joe;

        User buddy = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasSuperUser');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joeId
            );

            // Assert
            System.assertEquals(1, statuses.size());
            PositionStatus facilitatorStatus = statuses[0];
            System.assertEquals(EXPECTED_POSITION_STATUSES[1].position, facilitatorStatus.position);
            System.assertEquals(EXPECTED_POSITION_STATUSES[1].status, facilitatorStatus.status);
        }
    }

    @isTest
    public static void getPositionStatusForFacilitator_ReturnsActionNeeded_WhenCertValidDatePast() {
        // Arrange
        Id joeId = setupFullStatus();
        joe.FacilitatorCertAgreementReceived__c = Date.today().addDays(-366);

        update joe;

        User buddy = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasSuperUser');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joeId
            );

            // Assert
            System.assertEquals(7, statuses.size());
            PositionStatus facilitatorStatus = statuses[1];
            System.assertEquals(EXPECTED_POSITION_STATUSES[1].position, facilitatorStatus.position);
            System.assertEquals('Action Needed', facilitatorStatus.status);
        }
    }

    @isTest
    public static void getPositionStatusForFacilitator_ReturnsActionNeededSoon_WhenCertExpiresSoon() {
        // Arrange
        Id joeId = setupFullStatus();
        joe.FacilitatorCertAgreementReceived__c = Date.today().addDays(-276);

        update joe;

        User buddy = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasSuperUser');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joeId
            );

            // Assert
            System.assertEquals(7, statuses.size());
            PositionStatus facilitatorStatus = statuses[1];
            System.assertEquals(EXPECTED_POSITION_STATUSES[1].position, facilitatorStatus.position);
            System.assertEquals('Action Needed Soon', facilitatorStatus.status);
        }
    }

    @isTest
    public static void getPositionStatusForClient_ReturnsActionNeeded_WhenCertValidDatePast() {
        // Arrange
        Id joeId = setupFullStatus();
        joe.ClientStatus__c = 'Certified';
        joe.ClientCertificationValidUntil__c = Date.today().addDays(-3);

        update joe;

        User buddy = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasBase');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasTeam');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joeId
            );

            // Assert
            System.assertEquals(1, statuses.size());
            PositionStatus clientStatus = statuses[0];
            System.assertEquals(EXPECTED_POSITION_STATUSES[4].position, clientStatus.position);
            System.assertEquals('Action Needed', clientStatus.status);
        }
    }

    @isTest
    public static void getPositionStatusForPuppyRaiser_ReturnsActionNeededSoon_WhenCertExpiresSoon() {
        // Arrange
        Id joeId = setupFullStatus();
        joe.PuppyRaiserStatus__c = 'Certified-Active';
        joe.PuppyCertAgreementReceived__c = Date.today().addMonths(-10);

        update joe;

        User buddy = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasBase');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasPuppyRaiser');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joeId
            );

            // Assert
            System.assertEquals(1, statuses.size());
            PositionStatus status = statuses[0];
            System.assertEquals(EXPECTED_POSITION_STATUSES[2].position, status.position);
            System.assertEquals('Action Needed Soon', status.status);
        }
    }

    @isTest
    public static void getPositionStatusForPuppyRaiser_ReturnsActionNeeded_WhenCertExpired() {
        // Arrange
        Id joeId = setupFullStatus();
        joe.PuppyRaiserStatus__c = 'Certified-Active';
        joe.PuppyCertAgreementReceived__c = Date.today().addMonths(-13);

        update joe;

        User buddy = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasBase');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasPuppyRaiser');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joeId
            );

            // Assert
            System.assertEquals(1, statuses.size());
            PositionStatus status = statuses[0];
            System.assertEquals(EXPECTED_POSITION_STATUSES[2].position, status.position);
            System.assertEquals('Action Needed', status.status);
        }
    }

    @isTest
    public static void getPositionStatusForPuppyRaiser_ReturnsStatus_WhenCertNull() {
        // Arrange
        Id joeId = setupFullStatus();
        joe.PuppyRaiserStatus__c = 'Certified-Active';
        joe.PuppyCertAgreementReceived__c = null;

        update joe;

        User buddy = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasBase');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasPuppyRaiser');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joeId
            );

            // Assert
            System.assertEquals(1, statuses.size());
            PositionStatus status = statuses[0];
            System.assertEquals(EXPECTED_POSITION_STATUSES[2].position, status.position);
            System.assertEquals('Certified-Active', status.status);
        }
    }

    @isTest
    public static void getPositionStatusForTrainer_ReturnsActionNeededSoon_WhenCertExpiresSoon() {
        // Arrange
        Id joeId = setupFullStatus();
        joe.TrainerStatus__c = 'Certified-Active';
        joe.TrainerCertAgreementReceived__c = Date.today().addMonths(-10);

        update joe;

        User buddy = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasBase');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasTrainer');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joeId
            );

            // Assert
            System.assertEquals(1, statuses.size());
            PositionStatus status = statuses[0];
            System.assertEquals(EXPECTED_POSITION_STATUSES[5].position, status.position);
            System.assertEquals('Action Needed Soon', status.status);
        }
    }

    @isTest
    public static void getPositionStatusForTrainer_ReturnsActionNeededSoon_WhenCertExpired() {
        // Arrange
        Id joeId = setupFullStatus();
        joe.TrainerStatus__c = 'Certified-Active';
        joe.TrainerCertAgreementReceived__c = Date.today().addMonths(-12).addDays(-2);

        update joe;

        User buddy = TestUtilities.createUser('Standard User');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasBase');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasTrainer');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joeId
            );

            // Assert
            System.assertEquals(1, statuses.size());
            PositionStatus status = statuses[0];
            System.assertEquals(EXPECTED_POSITION_STATUSES[5].position, status.position);
            System.assertEquals('Action Needed', status.status);
        }
    }
}
