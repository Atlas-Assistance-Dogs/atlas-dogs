@isTest
private class TestProgramAssignmentController {
 
    @TestSetup
    static void makeData() {
        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;

        List<Contact> conLst = new List<Contact>();

        Contact con = new Contact();

        con.FirstName = 'Trainer';
        con.LastName = 'Contact';
        con.Email = 'trainer@abc.com';
        con.Positions__c = 'Trainer;Client';

        conLst.add(con);

        Contact con2 = new Contact();

        con2.FirstName = 'Client';
        con2.LastName = 'TestData';
        con2.Email = 'client@abc.com';
        con2.Positions__c = 'Trainer;Volunteer';

        conLst.add(con2);

        insert conLst;

        TestProgramAssignmentTrigger.setProgramDurations();
    }

    @isTest
    public static void getProgramAssignments_ReturnsAssignments() {
        Contact client = [SELECT FirstName, LastName, Id FROM Contact WHERE Email = 'client@abc.com'];
        Contact trainer = [SELECT FirstName, LastName, Id FROM Contact WHERE Email = 'trainer@abc.com'];
        List<ProgramAssignment__c> pas = new List<ProgramAssignment__c>();
        pas.add(new ProgramAssignment__c(
            Contact__c = client.Id,
            AssignedDate__c = Date.today().addYears(-1),
            CompletionDate__c = Date.today().addMonths(-10),
            ExpectedCompletion__c = Date.today().addMonths(-9),
            Program__c = [SELECT Id FROM Program__c WHERE Name = 'Volunteer' LIMIT 1].Id,
            Status__c = 'Completed'
        ));
        pas.add(new ProgramAssignment__c(
            Contact__c = client.Id,
            AssignedDate__c = Date.today().addYears(-1),
            ExpectedCompletion__c = Date.today().addMonths(1),
            Program__c = [SELECT Id FROM Program__c WHERE Name = 'Medical Disability' LIMIT 1].Id,
            Status__c = 'In Progress'
        ));
        pas.add(new ProgramAssignment__c(
            Contact__c = trainer.Id,
            AssignedDate__c = Date.today().addYears(-3),
            ExpectedCompletion__c = Date.today().addMonths(-16),
            Program__c = [SELECT Id FROM Program__c WHERE Name = 'Client' LIMIT 1].Id,
            Status__c = 'Discontinued'
        ));
        insert pas;

        Test.startTest();
        List<ProgramAssignment__c> clientPas = ProgramAssignmentController.getProgramAssignments(client.Id);
        Test.stopTest();

        System.assertEquals(2, clientPas.size(), 'Returned wrong number of records');
    }

    @isTest
    public static void getProgramAssignments_ReturnsNoAssignments_WhenIdNull() {
        Test.startTest();
        List<ProgramAssignment__c> clientPas = ProgramAssignmentController.getProgramAssignments(null);
        Test.stopTest();

        System.assertEquals(new List<ProgramAssignment__c>(), clientPas);
    }

    @isTest
    public static void getProgramAssignments_ThrowsException_WhenIdInvalid() {
        boolean thrown = false;
        Test.startTest();
        try {
            List<ProgramAssignment__c> clientPas = ProgramAssignmentController.getProgramAssignments('null');
        }
        catch (Exception exc) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }
}
