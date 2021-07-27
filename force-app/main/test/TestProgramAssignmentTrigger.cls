@isTest
public with sharing class TestProgramAssignmentTrigger {
    @testSetup
    static void setup() {
        Contact joe = new Contact(FirstName = 'Joe', LastName = 'Blow');
        insert joe;
    }

    static void setProgramDurations() {
        // Set some durations, all different to make testing more clear
        Settings.programDurations = new Map<String, Decimal>{
            'Volunteer' => 0.5,
            'Client' => 3,
            'Team Facilitator' => 4,
            'Teams Set in Motion Client' => 5,
            'Trainer' => 6
        };
        System.debug('Set programDurations');
    }

    static ProgramAssignment__c getProgramAssignment(Id ProgramAssignmentId) {
        ProgramAssignment__c saved = [
            SELECT
                AssignedDate__c,
                CompletionDate__c,
                Contact__c,
                ExpectedCompletion__c,
                Program__c,
                Status__c
            FROM ProgramAssignment__c
            WHERE id = :ProgramAssignmentId
            LIMIT 1
        ];
        return saved;
    }

    @isTest
    static void insert_setsAssignedToday_WhenAssignedNotSet() {
        // Set some durations, all different to make testing more clear
        setProgramDurations();
        Contact joe = [SELECT Id FROM Contact WHERE FirstName = 'Joe' LIMIT 1];
        ProgramAssignment__c ProgramAssignment = new ProgramAssignment__c(
            Program__c = 'Volunteer',
            Contact__c = joe.id,
            AssignedDate__c = Date.today()
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(ProgramAssignment, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        ProgramAssignment__c saved = getProgramAssignment(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(Date.today(), saved.AssignedDate__c);
    }

    static void testInsertSetsExpected(String program) {
        // Arrange
        setProgramDurations();
        Contact joe = [SELECT Id FROM Contact WHERE FirstName = 'Joe' LIMIT 1];
        // Create a ProgramAssignment__c with Volunteer program
        Date assigned = Date.newInstance(2021, 1, 10);
        ProgramAssignment__c assignment = new ProgramAssignment__c(
            AssignedDate__c = assigned,
            Program__c = program,
            Contact__c = joe.Id
        );

        Decimal duration = Settings.programDurations.get(program);

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(assignment, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        ProgramAssignment__c saved = getProgramAssignment(result.getId());
        Date expected = assigned.addDays((Integer) (duration * 30));
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(expected, saved.ExpectedCompletion__c);
        System.assertEquals(assigned, saved.AssignedDate__c);
    }

    @isTest
    static void insertVolunteerProgramAssignment_SetsExpected() {
        testInsertSetsExpected('Volunteer');
    }

    @isTest
    static void insert_DoesNotChangeExpected_WhenExpectedSet() {
        // Arrange
        setProgramDurations();
        Contact joe = [SELECT Id FROM Contact WHERE FirstName = 'Joe' LIMIT 1];
        // Create a ProgramAssignment__c with Volunteer program
        Date assigned = Date.newInstance(2021, 1, 10);
        Date expected = assigned.addMonths(1);
        ProgramAssignment__c assignment = new ProgramAssignment__c(
            AssignedDate__c = assigned,
            ExpectedCompletion__c = expected,
            Program__c = 'Volunteer',
            Contact__c = joe.Id
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(assignment, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        ProgramAssignment__c saved = getProgramAssignment(result.getId());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(expected, saved.ExpectedCompletion__c);
    }

    @isTest
    static void updateWithNoDateChangesLeavesThem() {
        setProgramDurations();
        Contact joe = [SELECT Id FROM Contact WHERE FirstName = 'Joe' LIMIT 1];
        Date assigned = Date.newInstance(2020, 1, 10);
        ProgramAssignment__c programAssignment = new ProgramAssignment__c(
            AssignedDate__c = assigned,
            ExpectedCompletion__c = Date.today(),
            Contact__c = joe.Id
        );
        insert programAssignment;

        programAssignment = getProgramAssignment(ProgramAssignment.Id);

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(programAssignment, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        ProgramAssignment__c saved = getProgramAssignment(programAssignment.Id);
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(assigned, saved.AssignedDate__c);
        System.assertEquals(Date.today(), saved.ExpectedCompletion__c);
    }
}
