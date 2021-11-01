@isTest
public with sharing class TestLogController {
    @isTest
    public static void getRelatedLogs_ReturnsEmptyList_WhenNoLogs() {
        Test.startTest();

        Contact contact = [
            SELECT id
            FROM Contact
            WHERE FirstName = 'Client'
            LIMIT 1
        ];
        List<Log__c> related = LogController.getRelatedLogs(contact.Id);

        Test.stopTest();
        System.assertEquals(0, related.size());
    }

    @isTest
    public static void getRelatedLogs_ReturnsExpectedLogs() {
        Contact contact = [
            SELECT id
            FROM Contact
            WHERE FirstName = 'Client'
            LIMIT 1
        ];

        List<Log__c> logs = new List<Log__c>();
        logs.add(
            new Log__c(
                Date__c = Date.today(),
                Client__c = contact.Id,
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

        Test.startTest();

        List<Log__c> related = LogController.getRelatedLogs(contact.Id);

        Test.stopTest();
        System.assertEquals(1, related.size());
        for (Integer idx = 0; idx < logs.size(); idx++) {
            Log__c expectedLog = logs[0];
            Log__c actual = related[idx];
            System.assertEquals(expectedLog.Date__c, actual.Date__c);
            System.assertEquals(
                expectedLog.PublicAccessHours__c,
                actual.PublicAccessHours__c
            );
            System.assertEquals(
                expectedLog.OtherHours__c,
                actual.OtherHours__c
            );
            System.assertEquals(expectedLog.Details__c, actual.Details__c);
            System.assertEquals(
                expectedLog.RequestSupportFromTeam__c,
                actual.RequestSupportFromTeam__c
            );
            System.assertEquals(
                expectedLog.SupportDetails__c,
                actual.SupportDetails__c
            );
            System.assertEquals(expectedLog.Stress__c, actual.Stress__c);
            System.assertEquals(
                expectedLog.Satisfaction__c,
                actual.Satisfaction__c
            );
            System.assertEquals(
                expectedLog.RequestSupportFromAtlas__c,
                actual.RequestSupportFromAtlas__c
            );
            System.assertEquals(contact.Id, actual.Client__c);
        }
    }
}
