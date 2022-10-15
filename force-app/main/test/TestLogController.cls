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
        RelatedObjects relatedObjects = LogController.getRelatedLogs(contact.Id, 'Client', 6);
        Test.stopTest();
        System.assertEquals(0, relatedObjects.items.size());
    }

    @isTest
    public static void getRelatedLogs_ThrowsException_WhenNoContactId() {
        Test.startTest();

        Boolean exceptionThrown = false;
        try {
            RelatedObjects related = LogController.getRelatedLogs('dog.Id', 'Client', 6);
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

        RelatedObjects related = LogController.getRelatedLogs(client.Id, 'Client', 6);

        Test.stopTest();
        System.assertEquals(1, related.items.size());
        for (Integer idx = 0; idx < related.items.size(); idx++) {
            Log__c expectedLog = logs[0];
            LogInfo actual = (LogInfo)related.items[idx];
            logsMatch(expectedLog, actual.log);
        }
    }
}
