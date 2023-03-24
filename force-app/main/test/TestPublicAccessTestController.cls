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
                Type__c = 'Recertification',
                ValidUntil__c = Date.today().addDays(363)
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
                Type__c = 'Recertification',
                ValidUntil__c = Date.today().addDays(363)
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
                Type__c = 'Recertification',
                ValidUntil__c = Date.today().addDays(363)
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
                Type__c = 'Initial',
                ValidUntil__c = Date.today().addDays(365)
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
                Type__c = 'Retest',
                ValidUntil__c = Date.today().addDays(363)
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
            System.assertEquals(expected.ValidUntil__c, actual.ValidUntil__c);
        }
    }
}
