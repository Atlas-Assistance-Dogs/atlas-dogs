@isTest
private class TestContactController {
    @isTest
    public static void getCotacts() {
        Test.startTest();

        PagedResult res = ContactController.getPagedContacts('Test', 1);
        System.assertEquals(res.records.size(), 2);

        List<Contact> conList2 = ContactController.getContactsByName('Test');
        System.assertEquals(conList2.size(), 2);

        List<Contact> conList3 = ContactController.getContactsWithPosition(
            'Trainer'
        );
        System.assertEquals(conList3.size(), 2);

        Test.stopTest();
    }

    @TestSetup
    static void makeData() {
        AtlasSettings__c settings = new AtlasSettings__c();
        upsert settings;

        List<Contact> conLst = new List<Contact>();

        Contact con = new Contact();

        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'abc@abc.com';
        con.Positions__c = 'Trainer;Client';

        conLst.add(con);

        Contact con2 = new Contact();

        con2.FirstName = 'Client';
        con2.LastName = 'TestData';
        con2.Email = 'abcde@abc.com';
        con2.Positions__c = 'Trainer;Volunteer';

        conLst.add(con2);

        insert conLst;
    }

    @isTest
    public static void getRelatedLogs_ReturnsEmptyList_WhenNoLogs() {
        Test.startTest();

        Contact contact = [
            SELECT id
            FROM Contact
            WHERE FirstName = 'Client'
            LIMIT 1
        ];
        List<ContactLog__c> related = ContactController.getRelatedLogs(
            contact.Id
        );

        Test.stopTest();
        System.assertEquals(0, related.size());
    }

    @isTest
    public static void getRelatedLogs_ReturnsExpectedLogs() {
        List<Log__c> logs = new List<Log__c>();
        logs.add(
            new Log__c(
                Date__c = Date.today(),
                PublicAccessHours__c = 10,
                OtherHours__c = 0,
                Details__c = 'My details',
                RequestSupportFromTeam__c = true,
                SupportDetails__c = 'Support details',
                Stress__c = 'Not at all',
                Satisfaction__c = 'No enjoyment',
                RequestSupportFromAtlas__c = false
            )
        );
        upsert logs;

        Contact contact = [
            SELECT id
            FROM Contact
            WHERE FirstName = 'Client'
            LIMIT 1
        ];

        List<ContactLog__c> clogs = new List<ContactLog__c>();
        clogs.add(
            new ContactLog__c(
                Contact__c = contact.Id,
                Log__c = logs[0].Id,
                Role__c = 'Client'
            )
        );
        upsert clogs;
        Test.startTest();

        List<ContactLog__c> related = ContactController.getRelatedLogs(
            contact.Id
        );

        Test.stopTest();
        System.assertEquals(1, related.size());
        for (Integer idx = 0; idx < clogs.size(); idx++) {
            Log__c expectedLog = logs[0];
            ContactLog__c expected = clogs[idx];
            ContactLog__c actual = related[idx];
            System.assertEquals(expectedLog.Date__c, actual.Log__r.Date__c);
            System.assertEquals(
                expectedLog.PublicAccessHours__c,
                actual.Log__r.PublicAccessHours__c
            );
            System.assertEquals(
                expectedLog.OtherHours__c,
                actual.Log__r.OtherHours__c
            );
            System.assertEquals(
                expectedLog.Details__c,
                actual.Log__r.Details__c
            );
            System.assertEquals(
                expectedLog.RequestSupportFromTeam__c,
                actual.Log__r.RequestSupportFromTeam__c
            );
            System.assertEquals(
                expectedLog.SupportDetails__c,
                actual.Log__r.SupportDetails__c
            );
            System.assertEquals(expectedLog.Stress__c, actual.Log__r.Stress__c);
            System.assertEquals(
                expectedLog.Satisfaction__c,
                actual.Log__r.Satisfaction__c
            );
            System.assertEquals(
                expectedLog.RequestSupportFromAtlas__c,
                actual.Log__r.RequestSupportFromAtlas__c
            );
            System.assertEquals(expected.Role__c, actual.Role__c);
        }
    }
}
