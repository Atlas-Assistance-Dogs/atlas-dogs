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
        new PositionStatus(
            PositionStatusController.POSITION_LIST[6],
            'Initial Inquiry'
        )
    };

    private static Id setupFullStatus() {
        Contact joe = new Contact(
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
        AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
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
        User buddy = TestUtilities.createUser('System Administrator');

        // Act
        System.runAs(buddy) {
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
    }

    @isTest
    public static void getPositionStatusForContact_ReturnsTeamFacilitator_WhenFacilitatorLead() {
        // Arrange
        // Arrange
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Blow',
            Positions__c = 'Team Facilitator Lead',
            FacilitatorStatus__c = 'Discontinued'
        );
        insert joe;
        
        User buddy = TestUtilities.createUser('System Administrator');

        // Act
        System.runAs(buddy) {
            List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
                joe.Id
            );

            // Assert
            Integer idx = 0;
            PositionStatus status = statuses[0];
            System.assertEquals('Team Facilitator', status.position);
            System.assertEquals('Discontinued', status.status);
        }
    }

    @isTest
    public static void getPositionStatusForContact_ReturnsVolunteer_WhenUserVolunteer() {
        // Arrange
        User buddy = TestUtilities.createUser('Minimum Access - Salesforce');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasBase');
        TestUtilities.addUserToPermissionSet(buddy.Id, 'AtlasVolunteer');

        // Act
        System.runAs(buddy) {
            Id joeId = setupFullStatus();
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
}
