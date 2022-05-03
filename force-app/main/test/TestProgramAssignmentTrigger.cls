@isTest
public with sharing class TestProgramAssignmentTrigger {
    @testSetup
    static void setup() {
        Contact joe = new Contact(FirstName = 'Joe', LastName = 'Blow');
        insert joe;
    }

    public static List<Program__c> programs;

    public static void setProgramDurations() {
        // Set some durations, all different to make testing more clear
        programs = new List<Program__c>();
        programs.Add(new Program__c(Name = 'Volunteer', Months__c = 0.5));
        programs.Add(new Program__c(Name = 'Client', Months__c = 3));
        programs.Add(new Program__c(Name = 'Team Facilitator', Months__c =  4));
        programs.Add(new Program__c(Name = 'Teams Set in Motion Client', Months__c =  5));
        programs.Add(new Program__c(Name = 'Trainer', Months__c =  6));
        programs.Add(new Program__c(Name = 'Medical Disability', Months__c =  7));
        programs.Add(new Program__c(Name = 'Medical Disability [CEU]', Months__c =  8));
        insert programs;
    }

    static ProgramAssignment__c getProgramAssignment(Id ProgramAssignmentId) {
        ProgramAssignment__c saved = [
            SELECT
                AssignedDate__c,
                CompletionDate__c,
                Contact__c,
                ExpectedCompletion__c,
                Program2__c,
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
            Program2__c = programs[0].Id,
            Contact__c = joe.Id,
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

    static void testInsertSetsExpected(string programName) {
        // Arrange
        setProgramDurations();
        Program__c program = [SELECT Id, Months__c FROM Program__c WHERE Name = :programName LIMIT 1];
        Contact joe = [SELECT Id FROM Contact WHERE FirstName = 'Joe' LIMIT 1];
        // Create a ProgramAssignment__c with Volunteer program
        Date assigned = Date.newInstance(2021, 1, 10);
        ProgramAssignment__c assignment = new ProgramAssignment__c(
            AssignedDate__c = assigned,
            Program2__c = program.Id,
            Contact__c = joe.Id
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(assignment, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        ProgramAssignment__c saved = getProgramAssignment(result.getId());
        Date expected = assigned.addDays((Integer) (program.Months__c * 30));
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(expected, saved.ExpectedCompletion__c);
        System.assertEquals(assigned, saved.AssignedDate__c);
    }

    @isTest
    static void insertVolunteerProgramAssignment_SetsExpected() {
        testInsertSetsExpected('Volunteer');
    }

    @isTest
    static void insertClientProgramAssignment_SetsExpected() {
        testInsertSetsExpected('Client');
    }

    @isTest
    static void insertTeamFacilitatorProgramAssignment_SetsExpected() {
        testInsertSetsExpected('Team Facilitator');
    }

    @isTest
    static void insertTrainerProgramAssignment_SetsExpected() {
        testInsertSetsExpected('Trainer');
    }

    @isTest
    static void insertHandlesMissingDuration() {
        // Arrange
        Program__c program = new Program__c(Name = 'Volunteer', Months__c = 0);
        insert program;
        Contact joe = [SELECT Id FROM Contact WHERE FirstName = 'Joe' LIMIT 1];
        // Create a ProgramAssignment__c with Volunteer program
        Date assigned = Date.newInstance(2021, 1, 10);
        ProgramAssignment__c assignment = new ProgramAssignment__c(
            AssignedDate__c = assigned,
            Program2__c = program.Id,
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
        System.assertEquals(assigned, saved.AssignedDate__c);
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
            Program2__c = programs[0].Id,
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
            Program2__c = programs[0].Id,
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
