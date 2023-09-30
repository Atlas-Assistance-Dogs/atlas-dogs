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

    @isTest
    public static void getPositionStatusForContact_ReturnsFullList_WhenPositionsFull() {
        // Arrange
        Contact joe = new Contact(
            FirstName = 'Joe',
            LastName = 'Blow',
            Positions__c = 'Client;Volunteer;Trainer;Team Facilitator;Team Facilitator Lead;Puppy Raiser;Board Member',
            GW_Volunteers__Volunteer_Status__c = 'Active',
            FacilitatorStatus__c = 'Certified-Active',
            FacilitatorCertAgreementReceived__c = Date.today().addDays(-250),
            PuppyRaiserStatus__c = 'Inactive',
            PuppyCertAgreementReceived__c = Date.today().addDays(-400),
            BoardMemberStatus__c = 'Onboarding',
            ClientStatus__c = 'In Training',
            ClientCertificationValidUntil__c = Date.today().addDays(300),
            TrainerStatus__c = 'Suspended',
            TrainerCertAgreementReceived__c = Date.today()
        );
        insert joe;
        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;
        Program__c program = new Program__c(Name = 'Super Dogs', Standalone__c = true, Months__c = 6);
        insert program;
        ProgramAssignment__c pa = new ProgramAssignment__c(Contact__c = joe.Id, Program__c = program.Id, AssignedDate__c = Date.today());
        insert pa;

        // Act
        List<PositionStatus> statuses = PositionStatusController.getPositionStatusForContact(
            joe.Id
        );

        // Assert
        Integer idx = 0;
        for (string position : PositionStatusController.POSITION_LIST) {
            PositionStatus status = statuses[idx++];
            System.assertEquals(position, status.position);
            //System.assertEquals('Active', statuses[0].status);
        }
        System.assertEquals(PositionStatusController.POSITION_LIST.size(), statuses.size());
    }
}
