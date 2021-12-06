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
        List<BackgroundCheck> checks = BackgroundCheckController.getRelatedChecks(
            contact.Id
        );
        Test.stopTest();

        System.assertEquals(0, checks.size());
    }

    private static Contact jack;
    private static Contact jill;

    private static void insertContacts() {
        List<Contact> contacts = new List<Contact>();
        contacts.add(
            new Contact(
                FirstName = 'Jack',
                LastName = 'Contact',
                Email = 'jack@test.com'
            )
        );
        contacts.add(
            new Contact(
                FirstName = 'Jill',
                LastName = 'Contact',
                Email = 'jill@test.com'
            )
        );
        insert contacts;

        jack = contacts[0];
        jill = contacts[1];
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
        List<BackgroundCheck> checks = BackgroundCheckController.getRelatedChecks(
            jack.Id
        );
        Test.stopTest();

        System.assertEquals(0, checks.size());
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
        List<BackgroundCheck> checks = BackgroundCheckController.getRelatedChecks(
            jill.Id
        );
        Test.stopTest();

        System.assertEquals(1, checks.size());
    }

    @isTest
    public static void getRelatedChecks_IncludesRelatedFile() {
        insertContacts();

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = jill.Id,
            Date__c = Date.today(),
            Status__c = 'Pass'
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
        FileController.relateFile(contentDocumentId, bgCheck.Id);

        Test.startTest();
        List<BackgroundCheck> checks = BackgroundCheckController.getRelatedChecks(
            jill.Id
        );
        Test.stopTest();

        System.assertEquals(1, checks.size());
        BackgroundCheck check = checks[0];
        System.assertEquals(contentDocumentId, check.documentId);
        System.assertEquals('Pass', check.status);
        System.assertEquals(Date.today(), check.completedDate);
        System.assertEquals(document.Title, check.fileName);
    }

    @isTest
    public static void deleteCheck_DeletesCheck_WhenPresent() {
        insertContacts();

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = jack.Id,
            Date__c = Date.today(),
            Status__c = 'Pass'
        );
        insert bgCheck;

        Test.startTest();
        BackgroundCheckController.deleteCheck(bgCheck.Id);
        Test.stopTest();

        List<BackgroundCheck__c> checks = [SELECT Id FROM BackgroundCheck__c];
        System.assert(checks.isEmpty());
    }

    @isTest
    public static void deleteCheck_DoesNotDelete_WhenInvalidId() {
        insertContacts();

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = jack.Id,
            Date__c = Date.today(),
            Status__c = 'Pass'
        );
        insert bgCheck;

        Test.startTest();
        BackgroundCheckController.deleteCheck(jill.Id);
        Test.stopTest();

        List<BackgroundCheck__c> checks = [SELECT Id FROM BackgroundCheck__c];
        System.assertEquals(1, checks.size());
    }

    @isTest
    public static void addBackgroundCheck_InsertsCheck() {
        insertContacts();

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = jack.Id,
            Date__c = Date.today(),
            Status__c = 'Pass'
        );

        Test.startTest();
        BackgroundCheckController.addBackgroundCheck(bgCheck, null);
        Test.stopTest();

        List<BackgroundCheck__c> checks = [SELECT Id FROM BackgroundCheck__c];
        System.assertEquals(1, checks.size());
    }

    @isTest
    public static void addBackgroundCheck_RelatesFile_WhenPresent() {
        insertContacts();

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = jack.Id,
            Date__c = Date.today(),
            Status__c = 'Pass'
        );

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

        Test.startTest();
        BackgroundCheckController.addBackgroundCheck(
            bgCheck,
            contentDocumentId
        );
        Test.stopTest();

        BackgroundCheck__c check = [SELECT Id FROM BackgroundCheck__c LIMIT 1];
        List<ContentVersion> contentVersion = FileController.getRelatedFiles(
            check.Id
        );
        System.assertEquals(
            contentDocumentId,
            contentVersion[0].ContentDocumentId
        );
    }

    @isTest
    public static void updateBackgroundCheck_ThrowsError_WhenNotInserted() {
        insertContacts();

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = jack.Id,
            Date__c = Date.today(),
            Status__c = 'Pass'
        );
        Boolean thrown = false;

        Test.startTest();
        try {
            BackgroundCheckController.updateBackgroundCheck(bgCheck);
        } catch (AuraHandledException e) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void updateBackgroundCheck_UpdatesCheck() {
        insertContacts();

        BackgroundCheck__c bgCheck = new BackgroundCheck__c(
            Contact__c = jack.Id,
            Date__c = Date.today(),
            Status__c = 'Pass'
        );
        insert bgCheck;

        bgCheck.Contact__c = jill.Id;
        bgCheck.Date__c = Date.today().addDays(-1);
        bgCheck.Status__c = 'Fail';

        Test.startTest();
        BackgroundCheckController.updateBackgroundCheck(bgCheck);
        Test.stopTest();

        BackgroundCheck__c actual = [
            SELECT Id, Contact__c, Date__c, Status__c
            FROM BackgroundCheck__c
            LIMIT 1
        ];
        System.assertEquals(bgCheck.Contact__c, actual.Contact__c);
        System.assertEquals(bgCheck.Date__c, actual.Date__c);
        System.assertEquals(bgCheck.Status__c, actual.Status__c);
    }
}
