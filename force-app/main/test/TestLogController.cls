@isTest
public with sharing class TestLogController {
    private static final String CLIENT_NAME = 'Client';
    private static final String SUBMITTER_NAME = 'Submitter';
    private static final String FACILITATOR_NAME = 'Facilitator';
    private static final String SOMEONE_ELSE = 'Debbie';
    private static final String DOG_NAME = 'Fido';

    private static Contact client;
    private static Contact submitter;
    private static Contact facilitator;
    private static Contact other;
    private static Dog__c dog;
    private static ID CLIENT_ID;
    private static ID FACILITATOR_ID;

    @testSetup
    static void setup() {
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(FirstName = CLIENT_NAME, LastName = 'Ace'));
        contacts.add(
            new Contact(FirstName = SUBMITTER_NAME, LastName = 'Smith')
        );
        contacts.add(
            new Contact(FirstName = FACILITATOR_NAME, LastName = 'Washington')
        );
        contacts.add(
            new Contact(FirstName = SOMEONE_ELSE, LastName = 'Walker')
        );
        insert contacts;

        dog = new Dog__c(Name = DOG_NAME);
        insert dog;

        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Log__c.getRecordTypeInfosByName();
        CLIENT_ID = recordTypes.get('Client').getRecordTypeId();
        FACILITATOR_ID = recordTypes.get('Team Facilitator').getRecordTypeId();
    }

    static void getContacts() {
        client = [
            SELECT id
            FROM Contact
            WHERE FirstName = :CLIENT_NAME
            LIMIT 1
        ];

        submitter = [
            SELECT id
            FROM Contact
            WHERE FirstName = :SUBMITTER_NAME
            LIMIT 1
        ];

        facilitator = [
            SELECT id
            FROM Contact
            WHERE FirstName = :FACILITATOR_NAME
            LIMIT 1
        ];

        other = [
            SELECT id
            FROM Contact
            WHERE FirstName = :SOMEONE_ELSE
            LIMIT 1
        ];

        dog = [SELECT Id, Name FROM Dog__c WHERE Name = :DOG_NAME LIMIT 1];
    }

    private static void logsMatch(Log__c expected, Log__c actual) {
        System.assertEquals(expected.Client__c, actual.Client__c);
        System.assertEquals(expected.ClientHours__c, actual.ClientHours__c);
        System.assertEquals(expected.ClientStress__c, actual.ClientStress__c);
        System.assertEquals(expected.Date__c, actual.Date__c);
        System.assertEquals(expected.Details__c, actual.Details__c);
        System.assertEquals(expected.Dog__c, actual.Dog__c);
        System.assertEquals(expected.Handler__c, actual.Handler__c);
        System.assertEquals(expected.OtherHours__c, actual.OtherHours__c);
        System.assertEquals(
            expected.PublicAccessHours__c,
            actual.PublicAccessHours__c
        );
        System.assertEquals(
            expected.RequestSupportFromAtlas__c,
            actual.RequestSupportFromAtlas__c
        );
        System.assertEquals(
            expected.RequestSupportFromTeam__c,
            actual.RequestSupportFromTeam__c
        );
        System.assertEquals(expected.Satisfaction__c, actual.Satisfaction__c);
        System.assertEquals(expected.SessionType__c, actual.SessionType__c);
        System.assertEquals(expected.Stress__c, actual.Stress__c);
        System.assertEquals(expected.Submitter__c, actual.Submitter__c);
        System.assertEquals(
            expected.SupportDetails__c,
            actual.SupportDetails__c
        );
        System.assertEquals(expected.Facilitator__c, actual.Facilitator__c);
    }

    @isTest
    public static void getRelatedLogs_ReturnsEmptyList_WhenNoLogs() {
        Test.startTest();

        Contact contact = [
            SELECT id
            FROM Contact
            WHERE FirstName = :CLIENT_NAME
            LIMIT 1
        ];
        RelatedObjects relatedObjects = LogController.getRelatedLogs(contact.Id, 6);
        Test.stopTest();
        System.assertEquals(0, relatedObjects.items.size());
    }

    @isTest
    public static void getRelatedLogs_ThrowsException_WhenNoContactId() {
        Test.startTest();

        Boolean exceptionThrown = false;
        try {
            RelatedObjects related = LogController.getRelatedLogs('dog.Id', 6);
        } catch (Exception exc) {
            exceptionThrown = true;
        }

        Test.stopTest();
        System.assert(exceptionThrown);
    }

    @isTest
    public static void getRelatedLogs_ReturnsExpectedLogs() {
        getContacts();

        List<Log__c> logs = new List<Log__c>();
        logs.add(
            new Log__c(
                Client__c = client.Id,
                ClientHours__c = 22,
                ClientStress__c = 'Only a little',
                Date__c = Date.today(),
                Details__c = 'My details',
                Dog__c = dog.Id,
                Handler__c = 'Ken',
                OtherHours__c = 5,
                PublicAccessHours__c = 10,
                RequestSupportFromAtlas__c = false,
                RequestSupportFromTeam__c = true,
                Satisfaction__c = 'No enjoyment',
                SessionType__c = 'In Person',
                Stress__c = 'Not at all',
                Submitter__c = submitter.Id,
                SupportDetails__c = 'Support details',
                Facilitator__c = facilitator.Id
            )
        );
        logs.add(
            new Log__c(
                Client__c = other.Id,
                ClientHours__c = 22,
                ClientStress__c = 'Only a little',
                Date__c = Date.today(),
                Details__c = 'My details',
                Dog__c = dog.Id,
                Handler__c = 'Ken',
                OtherHours__c = 5,
                PublicAccessHours__c = 10,
                RequestSupportFromAtlas__c = false,
                RequestSupportFromTeam__c = true,
                Satisfaction__c = 'No enjoyment',
                SessionType__c = 'In Person',
                Stress__c = 'Not at all',
                Submitter__c = other.Id,
                SupportDetails__c = 'Support details',
                Facilitator__c = other.Id
            )
        );
        insert logs;

        Test.startTest();

        RelatedObjects related = LogController.getRelatedLogs(client.Id, 6);

        Test.stopTest();
        System.assertEquals(1, related.items.size());
        for (Integer idx = 0; idx < related.items.size(); idx++) {
            Log__c expectedLog = logs[0];
            Log__c actual = (Log__c)related.items[idx];
            logsMatch(expectedLog, actual);
        }
    }

    @isTest
    public static void createLog_AddsLog() {
        getContacts();
        Date yesterday = Date.today().addDays(-1);
        Log__c log = new Log__c(
            Client__c = client.Id,
            ClientHours__c = 22,
            ClientStress__c = 'Only a little',
            Date__c = yesterday,
            Details__c = 'My details',
            Dog__c = dog.Id,
            Handler__c = 'Ken',
            OtherHours__c = 5,
            PublicAccessHours__c = 10,
            RequestSupportFromAtlas__c = false,
            RequestSupportFromTeam__c = true,
            Satisfaction__c = 'No enjoyment',
            SessionType__c = 'In Person',
            Stress__c = 'Not at all',
            Submitter__c = submitter.Id,
            SupportDetails__c = 'Support details',
            Facilitator__c = other.Id
        );

        Test.startTest();

        LogController.createLog(log);

        Test.stopTest();

        Log__c actual = [
            SELECT
                Client__c,
                ClientHours__c,
                ClientStress__c,
                Date__c,
                Details__c,
                Dog__c,
                Handler__c,
                OtherHours__c,
                PublicAccessHours__c,
                RequestSupportFromAtlas__c,
                RequestSupportFromTeam__c,
                Satisfaction__c,
                SessionType__c,
                Stress__c,
                Submitter__c,
                SupportDetails__c,
                Facilitator__c,
                RecordTypeId
            FROM Log__c
            WHERE Date__c = :yesterday
            LIMIT 1
        ];

        logsMatch(log, actual);
    }

    @isTest
    public static void createLog_ThrowsException_WhenMissingDate() {
        getContacts();
        Log__c log = new Log__c();

        Test.startTest();

        Boolean exceptionThrown = false;
        try {
            LogController.createLog(log);
        } catch (AuraHandledException exc) {
            exceptionThrown = true;
        }

        Test.stopTest();

        System.assert(exceptionThrown);
    }

    @isTest
    public static void deleteLog_DeletesLog() {
        getContacts();
        List<Log__c> logs = new List<Log__c>();
        logs.add(
            new Log__c(
                Date__c = Date.today().addDays(-2),
                Client__c = client.Id,
                Dog__c = dog.Id,
                OtherHours__c = 0,
                PublicAccessHours__c = 0,
                Submitter__c = submitter.Id
            )
        );
        logs.add(
            new Log__c(
                Date__c = Date.today().addDays(-1),
                Client__c = client.Id,
                Dog__c = dog.Id,
                OtherHours__c = 0,
                PublicAccessHours__c = 0,
                Submitter__c = submitter.Id
            )
        );
        logs.add(
            new Log__c(
                Date__c = Date.today(),
                Client__c = client.Id,
                Dog__c = dog.Id,
                OtherHours__c = 0,
                PublicAccessHours__c = 0,
                Submitter__c = submitter.Id
            )
        );
        insert logs;

        Test.startTest();

        LogController.deleteLog(logs[0].Id);

        Test.stopTest();

        List<Log__c> actual = [SELECT Id FROM Log__c];
        System.assertEquals(logs.size() - 1, actual.size());
        for (Log__c remaining : actual) {
            System.assertNotEquals(logs[0].Id, remaining.Id);
        }
    }

    @isTest
    public static void updateLog_UpdatesLog() {
        getContacts();
        List<Log__c> logs = new List<Log__c>();
        logs.add(
            new Log__c(
                Date__c = Date.today().addDays(-2),
                Client__c = client.Id,
                Dog__c = dog.Id,
                OtherHours__c = 0,
                PublicAccessHours__c = 0,
                Submitter__c = submitter.Id
            )
        );
        logs.add(
            new Log__c(
                Date__c = Date.today().addDays(-1),
                Client__c = client.Id,
                Dog__c = dog.Id,
                OtherHours__c = 0,
                PublicAccessHours__c = 0,
                Submitter__c = submitter.Id
            )
        );
        logs.add(
            new Log__c(
                Date__c = Date.today(),
                Client__c = client.Id,
                Dog__c = dog.Id,
                OtherHours__c = 0,
                PublicAccessHours__c = 0,
                Submitter__c = submitter.Id
            )
        );
        insert logs;

        Test.startTest();

        Log__c change = logs[0];
        change.Date__c = Date.today().addDays(-4);
        LogController.updateLog(change);

        Test.stopTest();

        Log__c actual = [SELECT Id, Date__c FROM Log__c WHERE Id = :change.Id];
        System.assertEquals(change.Date__c, actual.Date__c);
    }

    @isTest
    public static void updateLog_ThrowsException_WhenMissingDate() {
        getContacts();
        Log__c log = new Log__c(
            Date__c = Date.today().addDays(-2),
            Client__c = client.Id,
            Dog__c = dog.Id,
            OtherHours__c = 0,
            PublicAccessHours__c = 0,
            Submitter__c = submitter.Id
        );
        insert log;

        Test.startTest();
        log.Date__c = null;
        Boolean exceptionThrown = false;
        try {
            LogController.updateLog(log);
        } catch (AuraHandledException exc) {
            exceptionThrown = true;
        }

        Test.stopTest();

        System.assert(exceptionThrown);
    }
}
