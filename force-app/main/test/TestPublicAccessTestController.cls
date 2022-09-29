@isTest
public class TestPublicAccessTestController {
    private static Contact jack;
    private static Contact jill;
    private static Dog__c fido;
    private static Dog__c rover;
    private static Team__c team;
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

        fido = new Dog__c(Name = 'Fido');
        rover = new Dog__c(Name = 'Rover');
        insert new List<Dog__c>{ fido, rover };

        team = new Team__c(
            Client__c = jack.Id,
            Dog__c = fido.Id,
            Handler__c = jill.Id,
            PatCount__c = 2,
            PatValidUntil__c = Date.today().addYears(1),
            PrimaryCertification__c = 'Allergen Alert',
            SecondaryCertification__c = 'Autism'
        );
        insert team;
    }

    @isTest
    public static void getRelatedPats_ReturnsEmpty_WhenNoId() {
        Test.startTest();
        RelatedObjects result = PublicAccessTestController.getRelatedPats(
            null, 5
        );
        Test.stopTest();

        System.assert(result.items.isEmpty());
        System.assertEquals(0, result.total);
    }

    @isTest
    public static void getRelatedPats_ReturnsEmpty_WhenNoPats() {
        insertContacts();

        Test.startTest();
        RelatedObjects result = PublicAccessTestController.getRelatedPats(
            jill.Id, 5
        );
        Test.stopTest();

        System.assert(result.items.isEmpty());
        System.assertEquals(0, result.total);
    }

    @isTest
    public static void getRelatedPats_ReturnsEmpty_WhenNoPatsForTheContact() {
        insertContacts();
        List<PublicAccessTest__c> pats = new List<PublicAccessTest__c>();
        pats.add(
            new PublicAccessTest__c(
                Assessor__c = jill.Id,
                AssessorComments__c = 'AssessorComments__c',
                DateCompleted__c = Date.today().addDays(-2),
                Location__c = 'In Person',
                ReviewComments__c = 'ReviewComments__c',
                Status__c = 'Passed',
                Team__c = team.Id,
                Type__c = 'Recertification'
            )
        );

        pats.add(
            new PublicAccessTest__c(
                AssessorComments__c = 'AssessorComments__c',
                DateCompleted__c = Date.today().addDays(-2),
                Location__c = 'In Person',
                ReviewComments__c = 'ReviewComments__c',
                Status__c = 'Passed',
                Team__c = team.Id,
                Type__c = 'Recertification'
            )
        );

        pats.add(
            new PublicAccessTest__c(
                AssessorComments__c = 'AssessorComments__c',
                DateCompleted__c = Date.today().addDays(-2),
                Location__c = 'In Person',
                ReviewComments__c = 'ReviewComments__c',
                Status__c = 'Passed',
                Team__c = team.Id,
                Type__c = 'Recertification'
            )
        );
        insert pats;

        Test.startTest();
        RelatedObjects result = PublicAccessTestController.getRelatedPats(
            jack.Id, 5
        );
        Test.stopTest();

        System.assert(result.items.isEmpty());
        System.assertEquals(0, result.total);
    }

    @isTest
    public static void getRelatedPats_ReturnsAllPatsForTheTeam() {
        insertContacts();
        List<PublicAccessTest__c> pats = new List<PublicAccessTest__c>();
        pats.add(
            new PublicAccessTest__c(
                Assessor__c = jill.Id,
                AssessorComments__c = 'AssessorComments 1',
                DateCompleted__c = Date.today(),
                Location__c = 'In Person',
                ReviewComments__c = 'ReviewComments 1',
                Status__c = 'Passed',
                Team__c = team.Id,
                Type__c = 'Initial'
            )
        );

        pats.add(
            new PublicAccessTest__c(
                AssessorComments__c = 'AssessorComments 2',
                DateCompleted__c = Date.today().addDays(-1),
                Location__c = 'Virtual',
                ReviewComments__c = 'ReviewComments 2',
                Status__c = 'Failed',
                Team__c = team.Id,
                Type__c = 'Recertification'
            )
        );

        pats.add(
            new PublicAccessTest__c(
                AssessorComments__c = 'AssessorComments 3',
                DateCompleted__c = Date.today().addDays(-2),
                Location__c = 'In Person',
                ReviewComments__c = 'ReviewComments 3',
                Status__c = 'Provisionally Passed',
                Team__c = team.Id,
                Type__c = 'Retest'
            )
        );
        insert pats;

        Test.startTest();
        RelatedObjects result = PublicAccessTestController.getRelatedPats(
            team.Id, 5
        );
        Test.stopTest();

        System.assertEquals(3, result.items.size());
        System.assertEquals(3, result.total);
        for (Integer idx = 0; idx < pats.size(); idx++) {
            PublicAccessTest__c actual = (PublicAccessTest__c)result.items[idx];
            PublicAccessTest__c expected = pats[idx];
            System.assertEquals(expected.Id, actual.Id);
            System.assertEquals(expected.Assessor__c, actual.Assessor__c);
            System.assertEquals(
                expected.AssessorComments__c,
                actual.AssessorComments__c
            );
            System.assertEquals(
                expected.DateCompleted__c,
                actual.DateCompleted__c
            );
            System.assertEquals(expected.Location__c, actual.Location__c);
            System.assertEquals(
                expected.ReviewComments__c,
                actual.ReviewComments__c
            );
            System.assertEquals(expected.Status__c, actual.Status__c);
            System.assertEquals(expected.Team__c, actual.Team__c);
            System.assertEquals(expected.Type__c, actual.Type__c);
        }
    }

    @isTest
    public static void createPat_ReturnsException() {
        insertContacts();

        PublicAccessTest__c pat = new PublicAccessTest__c(
            Assessor__c = fido.Id,
            AssessorComments__c = 'AssessorComments',
            DateCompleted__c = Date.today().addDays(-2),
            Location__c = 'In Person',
            ReviewComments__c = 'ReviewComments',
            Status__c = 'Provisionally Passed',
            Team__c = team.Id,
            Type__c = 'Retest'
        );
        Boolean thrown = false;

        Test.startTest();
        try {
            PublicAccessTestController.createPat(pat, null);
        } catch (AuraHandledException e) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void createPat_InsertsPat() {
        insertContacts();

        PublicAccessTest__c expected = new PublicAccessTest__c(
            Assessor__c = jack.Id,
            AssessorComments__c = 'AssessorComments',
            DateCompleted__c = Date.today().addDays(-2),
            Location__c = 'In Person',
            ReviewComments__c = 'ReviewComments',
            Status__c = 'Provisionally Passed',
            Team__c = team.Id,
            Type__c = 'Retest'
        );

        Test.startTest();
        PublicAccessTestController.createPat(expected, null);
        Test.stopTest();

        PublicAccessTest__c actual = [
            SELECT
                Assessor__c,
                AssessorComments__c,
                DateCompleted__c,
                Location__c,
                ReviewComments__c,
                Status__c,
                Team__c,
                Type__c
            FROM PublicAccessTest__c
            LIMIT 1
        ];

        System.assertEquals(expected.Assessor__c, actual.Assessor__c);
        System.assertEquals(
            expected.AssessorComments__c,
            actual.AssessorComments__c
        );
        System.assertEquals(expected.DateCompleted__c, actual.DateCompleted__c);
        System.assertEquals(expected.Location__c, actual.Location__c);
        System.assertEquals(
            expected.ReviewComments__c,
            actual.ReviewComments__c
        );
        System.assertEquals(expected.Status__c, actual.Status__c);
        System.assertEquals(expected.Team__c, actual.Team__c);
        System.assertEquals(expected.Type__c, actual.Type__c);
    }

    @isTest
    public static void createPat_InsertsPatAndRelatesFile() {
        insertContacts();

        PublicAccessTest__c expected = new PublicAccessTest__c(
            Assessor__c = jack.Id,
            AssessorComments__c = 'AssessorComments',
            DateCompleted__c = Date.today().addDays(-2),
            Location__c = 'In Person',
            ReviewComments__c = 'ReviewComments',
            Status__c = 'Provisionally Passed',
            Team__c = team.Id,
            Type__c = 'Retest'
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
        PublicAccessTestController.createPat(
            expected,
            new List<Id>{ contentDocumentId }
        );
        Test.stopTest();

        PublicAccessTest__c actual = [
            SELECT
                Assessor__c,
                AssessorComments__c,
                DateCompleted__c,
                Location__c,
                ReviewComments__c,
                Status__c,
                Team__c,
                Type__c
            FROM PublicAccessTest__c
            LIMIT 1
        ];

        RelatedObjects related = FileController.getRelatedFiles(
            actual.Id, 5
        );
        System.assertEquals(
            contentDocumentId,
            ((ContentVersion)related.items[0]).ContentDocumentId
        );
    }

    @isTest
    public static void updatePat_ThrowsException_WhenNoPat() {
        Boolean thrown = false;

        Test.startTest();
        try {
            BackgroundCheckController.updateBackgroundCheck(null);
        } catch (AuraHandledException e) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void updatePat_ThrowsException_WhenNotInserted() {
        insertContacts();
        PublicAccessTest__c pat = new PublicAccessTest__c(
            Assessor__c = jack.Id,
            AssessorComments__c = 'AssessorComments',
            DateCompleted__c = Date.today().addDays(-2),
            Location__c = 'In Person',
            ReviewComments__c = 'ReviewComments',
            Status__c = 'Provisionally Passed',
            Team__c = team.Id,
            Type__c = 'Retest'
        );
        Boolean thrown = false;

        Test.startTest();
        try {
            PublicAccessTestController.updatePat(pat);
        } catch (AuraHandledException e) {
            thrown = true;
        }
        Test.stopTest();

        System.assert(thrown);
    }

    @isTest
    public static void updatePat_UpdatesPat() {
        insertContacts();
        PublicAccessTest__c pat = new PublicAccessTest__c(
            Assessor__c = jack.Id,
            AssessorComments__c = 'AssessorComments',
            DateCompleted__c = Date.today().addDays(-2),
            Location__c = 'Virtual',
            ReviewComments__c = 'ReviewComments',
            Status__c = 'Provisionally Passed',
            Team__c = team.Id,
            Type__c = 'Retest'
        );
        insert pat;

        pat.Assessor__c = jill.Id;
        pat.AssessorComments__c = 'Different comments';
        pat.DateCompleted__c = Date.today();
        pat.ReviewComments__c = 'Different review comments';
        pat.Status__c = 'Failed';
        pat.Type__c = 'Initial';

        Test.startTest();
        PublicAccessTestController.updatePat(pat);
        Test.stopTest();

        PublicAccessTest__c actual = [
            SELECT
                Assessor__c,
                AssessorComments__c,
                DateCompleted__c,
                Location__c,
                ReviewComments__c,
                Status__c,
                Team__c,
                Type__c
            FROM PublicAccessTest__c
            LIMIT 1
        ];
        System.assertEquals(pat.Assessor__c, actual.Assessor__c);
        System.assertEquals(
            pat.AssessorComments__c,
            actual.AssessorComments__c
        );
        System.assertEquals(pat.DateCompleted__c, actual.DateCompleted__c);
        System.assertEquals(pat.Location__c, actual.Location__c);
        System.assertEquals(pat.ReviewComments__c, actual.ReviewComments__c);
        System.assertEquals(pat.Status__c, actual.Status__c);
        System.assertEquals(pat.Team__c, actual.Team__c);
        System.assertEquals(pat.Type__c, actual.Type__c);
    }

    @isTest
    public static void deletePat_ThrowsException_WhenNoRecordId() {
        Boolean thrown = true;

        Test.startTest();
        try {
            PublicAccessTestController.deletePat(null);
        } catch (AuraHandledException e) {
            thrown = true;
        }

        System.assert(thrown);
    }

    @isTest
    public static void deletePat_ThrowsException_WhenBadRecordId() {
        insertContacts();
        Boolean thrown = true;

        Test.startTest();
        try {
            PublicAccessTestController.deletePat(jill.Id);
        } catch (AuraHandledException e) {
            thrown = true;
        }

        System.assert(thrown);
    }

    @isTest
    public static void deletePat_DeletesPat() {
        insertContacts();
        PublicAccessTest__c pat = new PublicAccessTest__c(
            Assessor__c = jack.Id,
            AssessorComments__c = 'AssessorComments',
            DateCompleted__c = Date.today().addDays(-2),
            Location__c = 'In Person',
            ReviewComments__c = 'ReviewComments',
            Status__c = 'Provisionally Passed',
            Team__c = team.Id,
            Type__c = 'Retest'
        );
        insert pat;

        Test.startTest();
        PublicAccessTestController.deletePat(pat.Id);
        Test.stopTest();

        List<PublicAccessTest__c> actual = [SELECT Id FROM PublicAccessTest__c];
        System.assert(actual.isEmpty());
    }
}
