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
            contact.Id, 6
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
        RelatedObjects checks = BackgroundCheckController.getRelatedChecks(
            jack.Id, 6
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
            jill.Id, 6
        );
        Test.stopTest();

        System.assertEquals(1, checks.items.size());
        System.assertEquals(1, checks.total);
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
        FileController.relateFile(contentDocumentId, bgCheck.Id, Date.today());

        Test.startTest();
        RelatedObjects checks = BackgroundCheckController.getRelatedChecks(
            jill.Id, 6
        );
        Test.stopTest();

        System.assertEquals(1, checks.items.size());
        System.assertEquals(1, checks.total);
        BackgroundCheck check = (BackgroundCheck)checks.items[0];
        System.assertEquals(contentDocumentId, check.documentId);
        System.assertEquals('Pass', check.status);
        System.assertEquals(Date.today(), check.completedDate);
        System.assertEquals(document.Title, check.fileName);
    }
}
