@isTest
private class TestProgramAssignmentController {
 
    @TestSetup
    static void makeData() {
        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;

        List<Contact> conLst = new List<Contact>();

        Contact con = new Contact(
            FirstName = 'Trainer',
            LastName = 'Contact',
            Email = 'trainer@abc.com',
            Positions__c = 'Trainer;Client',
            PreferredName__c = 'Trainer',
            Pronoun__c = 'He/Him'
        );

        conLst.add(con);

        Contact con2 = new Contact(
            FirstName = 'Client',
            LastName = 'TestData',
            Email = 'client@abc.com',
            Positions__c = 'Trainer;Volunteer',
            PreferredName__c = 'Trainer',
            Pronoun__c = 'He/Him',
            PronounOther__c = 'Xe/Xim'           
        );

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

    private static Dog__c ace;
    private static Dog__c cookie;
    private static Dog__c theo;
    private static Contact client;
    private static Contact trainer;
    private static Contact becky;

    private static Dog__c getDogAge(Dog__c dog) {
        return [SELECT Name, Breed__c, AgeYears__c, Gender__c FROM Dog__c WHERE Id = :dog.Id LIMIT 1];
    }

    private static void setupDogs() {
        ace = new Dog__c(
            Name = 'Ace',
            Breed__c = 'German Shepherd Dog',
            Birthdate__c = Date.today().addYears(-3),
            Gender__c = 'Female'
        );
        cookie = new Dog__c(
            Name = 'Cookie',
            Breed__c = 'Britany',
            Birthdate__c = Date.today().addYears(-13),
            Gender__c = 'Female'
        );
        theo = new Dog__c(
            Name = 'Theodore',
            Breed__c = 'Labrador',
            Birthdate__c = Date.today().addYears(-10),
            Gender__c = 'Male'
        );
        List<Dog__c> dogs = new List<Dog__c>{ ace, cookie, theo };
        insert dogs;

        ace = getDogAge(ace);
        cookie = getDogAge(cookie);
        theo = getDogAge(theo);

        client = [SELECT FirstName, LastName, Email, PreferredName__c, Pronoun__c, PronounOther__c, Id FROM Contact WHERE Email = 'client@abc.com'];
        trainer = [SELECT FirstName, LastName, Email, PreferredName__c, Pronoun__c, PronounOther__c, Id FROM Contact WHERE Email = 'trainer@abc.com'];
        becky = new Contact(
            FirstName = 'Becky',
            LastName = 'Robinson',
            Email = 'becky@abc.com',
            Positions__c = 'Client',
            PreferredName__c = 'Becky',
            Pronoun__c = 'She/Her'
        );
        insert becky;

        List<DogRelationship__c> relationships = new List<DogRelationship__c>();
        relationships.add(new DogRelationship__c(
            Dog__c = ace.Id,
            Contact__c = client.Id,
            Type__c = 'Owner'
        ));
        relationships.add(new DogRelationship__c(
            Dog__c = cookie.Id,
            Contact__c = trainer.Id,
            Type__c = 'Client'
        ));
        relationships.add(new DogRelationship__c(
            Dog__c = theo.Id,
            Contact__c = becky.Id,
            Type__c = 'Handler'
        ));
        insert relationships;
    }

    private static void assertReportData(ProgramReportRow row, ProgramAssignment__c pa, Contact contact, Dog__c dog) {
        System.assertEquals(pa.Status__c, row.pa.Status__c);
        System.assertEquals(pa.AssignedDate__c, row.pa.AssignedDate__c);
        System.assertEquals(contact.FirstName, row.contact.FirstName);
        System.assertEquals(contact.LastName, row.contact.LastName);
        System.assertEquals(contact.PreferredName__c, row.contact.PreferredName__c);
        System.assertEquals(contact.Pronoun__c, row.contact.Pronoun__c);
        System.assertEquals(contact.Email, row.contact.Email);

        System.assertEquals(dog.Name, row.dog.Name);
        System.assertEquals(dog.AgeYears__c, row.dog.AgeYears__c, 'Age does not match');
        System.assertEquals(dog.Breed__c, row.dog.Breed__c, 'Breed does not match');
        System.assertEquals(dog.Gender__c, row.dog.Gender__c, 'Genter does not match');
    }

    @isTest
    public static void getReport_ReturnsReportData() {
        string program = 'Teams Set in Motion Client';
        setupDogs();
        Program__c tsim = [SELECT Id FROM Program__c WHERE Name = :program LIMIT 1];
        List<ProgramAssignment__c> pas = new List<ProgramAssignment__c>();
        pas.add(new ProgramAssignment__c(
            Contact__c = client.Id,
            AssignedDate__c = Date.today().addYears(-1),
            CompletionDate__c = Date.today().addMonths(-10),
            ExpectedCompletion__c = Date.today().addMonths(-9),
            Program__c = tsim.Id,
            Status__c = 'In Progress'
        ));
        pas.add(new ProgramAssignment__c(
            Contact__c = trainer.Id,
            AssignedDate__c = Date.today().addYears(-1),
            ExpectedCompletion__c = Date.today().addMonths(1),
            Program__c = tsim.Id,
            Status__c = 'In Progress'
        ));
        pas.add(new ProgramAssignment__c(
            Contact__c = becky.Id,
            AssignedDate__c = Date.today().addYears(-3),
            ExpectedCompletion__c = Date.today().addMonths(-16),
            Program__c = tsim.Id,
            Status__c = 'Pending'
        ));
        pas.add(new ProgramAssignment__c(
            Contact__c = trainer.Id,
            AssignedDate__c = Date.today().addYears(-3),
            ExpectedCompletion__c = Date.today().addMonths(-16),
            Program__c = [SELECT Id FROM Program__c WHERE Name = 'Client' LIMIT 1].Id,
            Status__c = 'Completed'
        ));
        insert pas;

        Test.startTest();
        RelatedObjects report = ProgramAssignmentController.getReport(program);
        Test.stopTest();

        System.assertEquals(3, report.total, 'Returned wrong total');
        System.assertEquals(3, report.items.size(), 'Returned wrong number of records');
        assertReportData((ProgramReportRow)report.items[0], pas[0], client, ace);
        assertReportData((ProgramReportRow)report.items[1], pas[1], trainer, cookie);
        assertReportData((ProgramReportRow)report.items[2], pas[2], becky, theo);
    }
}
