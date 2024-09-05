@isTest
public class TestBackgroundCheckController {
    @isTest
    public static void getRelatedChecks_ReturnsEmptyList_WhenNone() {
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com'
        );
        insert contact;

        Test.startTest();
        RelatedObjects checks = BackgroundCheckController.getRelatedChecks(
            contact.Id,
            6
        );
        Test.stopTest();

        System.assertEquals(0, checks.items.size());
        System.assertEquals(0, checks.total);
    }

    private static Contact jack;
    private static Contact jill;

    private static void insertContacts() {
        List<Contact> contacts = new List<Contact>();
        contacts.add(
            new Contact(
                FirstName = 'Jack',
                LastName = 'Contact',
                Email = 'jack@test.com',
                VolunteerAccess__c = ''
            )
        );
        contacts.add(
            new Contact(
                FirstName = 'Jill',
                LastName = 'Contact',
                Email = 'jill@test.com',
                VolunteerAccess__c = ''
            )
        );
        insert contacts;

        jack = contacts[0];
        jill = contacts[1];
    }

    private static void insertContactsWithAccess() {
        jack = new Contact(
            FirstName = 'Jack',
            LastName = 'Contact',
            Email = 'jack@test.com',
            VolunteerAccess__c = 'Credit Check Required'
        );

        jill = new Contact(
            FirstName = 'Jill',
            LastName = 'Contact',
            Email = 'jill@test.com',
            VolunteerAccess__c = 'Background Check Required'
        );

        insert new List<Contact>{ jack, jill };
    }

    @isTest
    public static void getRelatedChecks_ReturnsEmptyList_WhenNoneForThisContact() {
        insertContacts();

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = jill.Id,
            Date__c = Date.today(),
            Status__c = 'Pass'
        );
        insert bgCheck;

        Test.startTest();
        RelatedObjects checks = BackgroundCheckController.getRelatedChecks(
            jack.Id,
            6
        );
        Test.stopTest();

        System.assertEquals(0, checks.items.size());
        System.assertEquals(0, checks.total);
    }

    @isTest
    public static void getRelatedChecks_ReturnsList_WhenOneForThisContact() {
        insertContacts();

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = jill.Id,
            Date__c = Date.today(),
            Status__c = 'Pass'
        );
        insert bgCheck;

        Test.startTest();
        RelatedObjects checks = BackgroundCheckController.getRelatedChecks(
            jill.Id,
            6
        );
        Test.stopTest();

        System.assertEquals(1, checks.items.size());
        System.assertEquals(1, checks.total);
        BackgroundCheck__c check = ((BackgroundCheck) checks.items[0]).check;
        System.assertEquals(bgCheck.Date__c, check.Date__c);
        System.assertEquals('Criminal', check.Type__c);
        System.assertEquals('Pass', check.Status__c);
    }

    @isTest
    public static void getRelatedChecks_IncludesRelatedFile() {
        insertContacts();

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = jill.Id,
            Date__c = Date.today(),
            Status__c = 'Pass',
            Type__c = 'Credit'
        );
        insert bgCheck;

        ContentVersion document = new ContentVersion(
            Title = 'TestDocument',
            PathOnClient = 'TestDocument.jpg',
            Origin = 'H',
            VersionData = Blob.valueOf('Document Body')
        );
        insert document;

        Id contentDocumentId = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id = :document.Id
        ]
        .ContentDocumentId;
        FileController.relateFile(contentDocumentId, bgCheck.Id, Date.today());

        Test.startTest();
        RelatedObjects checks = BackgroundCheckController.getRelatedChecks(
            jill.Id,
            6
        );
        Test.stopTest();

        System.assertEquals(1, checks.items.size());
        System.assertEquals(1, checks.total);
        BackgroundCheck info = (BackgroundCheck) checks.items[0];
        BackgroundCheck__c check = info.check;
        System.assertEquals(contentDocumentId, info.documentId);
        System.assertEquals('Pass', check.Status__c);
        System.assertEquals('Credit', check.Type__c);
        System.assertEquals(Date.today(), check.Date__c);
        System.assertEquals(document.Title, info.fileName);
    }

    @isTest
    public static void createReminderTask_createsNoTasksWhenNoContactsWithAccess() {
        insertContacts();

        Test.startTest();
        BackgroundCheckController.createReminderTask();
        Test.stopTest();

        Task[] tasks = [SELECT Id FROM Task];
        System.assertEquals(0, tasks.size());
    }

    @isTest
    public static void createReminderTask_createsTasksWhenContactsWithAccess() {
        insertContactsWithAccess();

        Test.startTest();
        BackgroundCheckController.createReminderTask();
        Test.stopTest();

        Task[] tasks = [SELECT Id FROM Task];
        System.assertEquals(2, tasks.size());
    }

    @isTest
    public static void createReminderTask_createsNoTasksWhenContactsWithAccessUpToDate() {
        insertContactsWithAccess();
        update new List<Contact>{ jill, jack };

        List<BackgroundCheck__c> bgChecks = new List<BackgroundCheck__c> {
            new BackgroundCheck__c(
            Contact__c = jill.Id,
            Date__c = Date.today().addMonths(-10),
            Status__c = 'Pass',
            Type__c = 'Credit'
        ),
        new BackgroundCheck__c(
            Contact__c = jack.Id,
            Date__c = Date.today().addMonths(-9),
            Status__c = 'Pass',
            Type__c = 'Criminal'
        )};
        insert bgChecks;

        Test.startTest();
        BackgroundCheckController.createReminderTask();
        Test.stopTest();

        Task[] tasks = [SELECT Id FROM Task];
        System.assertEquals(0, tasks.size());
    }

    @isTest
    public static void createReminderTask_createsTaskWhenContactWithAccessNeedsNew() {
        insertContactsWithAccess();
        update new List<Contact>{ jill, jack };
        Group adminGroup = [SELECT Id FROM Group WHERE Name = 'Background Check Administrator' AND Type = 'Queue'];

        List<BackgroundCheck__c> bgChecks = new List<BackgroundCheck__c> {
            new BackgroundCheck__c(
            Contact__c = jill.Id,
            Date__c = Date.today().addMonths(-12),
            Status__c = 'Pass',
            Type__c = 'Credit'
        ),
        new BackgroundCheck__c(
            Contact__c = jack.Id,
            Date__c = Date.today().addMonths(-9),
            Status__c = 'Pass',
            Type__c = 'Criminal'
        )};
        insert bgChecks;

        Test.startTest();
        BackgroundCheckController.createReminderTask();
        Test.stopTest();

        Task[] tasks = [SELECT Id, OwnerId, Subject, WhoId, ActivityDate FROM Task];
        System.assertEquals(1, tasks.size());
        Task reminder = tasks[0];
        System.assertEquals(jill.Id, reminder.WhoId);
        System.assert(reminder.Subject.contains('Order background check'));
        System.assertEquals(adminGroup.Id, reminder.OwnerId);
        System.assertEquals(Date.today().addMonths(1), reminder.ActivityDate);
    }

    @isTest
    public static void createReminderTask_createsTaskWhenOtherContactWithAccessNeedsNew() {
        insertContactsWithAccess();
        update new List<Contact>{ jill, jack };
        Group adminGroup = [SELECT Id FROM Group WHERE Name = 'Background Check Administrator' AND Type = 'Queue'];

        List<BackgroundCheck__c> bgChecks = new List<BackgroundCheck__c> {
            new BackgroundCheck__c(
            Contact__c = jill.Id,
            Date__c = Date.today().addMonths(-10),
            Status__c = 'Pass',
            Type__c = 'Credit'
        ),
        new BackgroundCheck__c(
            Contact__c = jack.Id,
            Date__c = Date.today().addMonths(-11).addDays(-1),
            Status__c = 'Pass',
            Type__c = 'Criminal'
        )};
        insert bgChecks;

        Test.startTest();
        BackgroundCheckController.createReminderTask();
        Test.stopTest();

        Task[] tasks = [SELECT Id, OwnerId, Subject, WhoId, ActivityDate FROM Task];
        System.assertEquals(1, tasks.size());
        Task reminder = tasks[0];
        System.assertEquals(jack.Id, reminder.WhoId);
        System.assert(reminder.Subject.contains('Order background check'));
        System.assertEquals(adminGroup.Id, reminder.OwnerId);
        System.assertEquals(Date.today().addMonths(1), reminder.ActivityDate);
    }
}
