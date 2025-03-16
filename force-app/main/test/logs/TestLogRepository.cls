/**
 * This class contains unit tests for validating the behavior of LogRepository
 */
@isTest
private class TestLogRepository {
  public static ID CLIENT_ID;
  public static ID FACILITATOR_ID;

  @testSetup
  static void setup() {
    Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Log__c.getRecordTypeInfosByName();
    CLIENT_ID = recordTypes.get('Client').getRecordTypeId();
    FACILITATOR_ID = recordTypes.get('Team Facilitator').getRecordTypeId();
  }

  @isTest
  static void getRecent_returnsEmpty_whenNoClientLogs() {
    LogRepository repository = new LogRepository();

    Test.startTest();
    List<Log__c> logs = repository.getRecent('Client', 1);
    Test.stopTest();

    System.assert(logs.isEmpty(), 'No logs should be returned');
  }

  @isTest
  static void getRecent_returnsEmpty_whenNoFacilitatorLogs() {
    LogRepository repository = new LogRepository();

    Test.startTest();
    List<Log__c> logs = repository.getRecent('TeamFacilitator', 1);
    Test.stopTest();

    System.assert(logs.isEmpty(), 'No logs should be returned');
  }

  @isTest
  static void getRecent_returnsEmpty_whenNoFacilitatorLogsButClientLogs() {
    setup();
    Team__c team = TestTeam.create();
    Log__c log = new Log__c(
      Team__c = team.Id,
      OtherHours__c = 3,
      PublicAccessHours__c = 2,
      Submitter__c = team.Client__c,
      RecordTypeId = CLIENT_ID
    );
    insert log;
    LogRepository repository = new LogRepository();

    Test.startTest();
    List<Log__c> logs = repository.getRecent('TeamFacilitator', 1);
    Test.stopTest();

    System.assert(logs.isEmpty(), 'No logs should be returned');
  }

  @isTest
  static void getRecent_returnsEmpty_whenNoClientLogsButFacilitatorLogs() {
    setup();
    Team__c team = TestTeam.create();
    Log__c log = new Log__c(
      Team__c = team.Id,
      OtherHours__c = 3,
      PublicAccessHours__c = 2,
      Submitter__c = team.Client__c,
      RecordTypeId = FACILITATOR_ID
    );
    insert log;
    LogRepository repository = new LogRepository();

    Test.startTest();
    List<Log__c> logs = repository.getRecent('Client', 1);
    Test.stopTest();

    System.assert(logs.isEmpty(), 'No logs should be returned');
  }

  @isTest
  static void getRecent_returnsEmpty_whenNoClientLogsAfterDate() {
    setup();
    Team__c team = TestTeam.create();
    Log__c log = new Log__c(
      Team__c = team.Id,
      OtherHours__c = 3,
      PublicAccessHours__c = 2,
      Submitter__c = team.Client__c,
      RecordTypeId = CLIENT_ID,
      Date__c = Date.today().addDays(-2)
    );
    insert log;
    LogRepository repository = new LogRepository();

    Test.startTest();
    List<Log__c> logs = repository.getRecent('Client', 1);
    Test.stopTest();

    System.assert(logs.isEmpty(), 'No logs should be returned');
  }

  @isTest
  static void getRecent_returnsEmpty_whenNoFacilitatorLogsAfterDate() {
    setup();
    Team__c team = TestTeam.create();
    Log__c log = new Log__c(
      Team__c = team.Id,
      OtherHours__c = 3,
      PublicAccessHours__c = 2,
      Submitter__c = team.Client__c,
      RecordTypeId = FACILITATOR_ID,
      Date__c = Date.today().addDays(-2)
    );
    insert log;
    LogRepository repository = new LogRepository();

    Test.startTest();
    List<Log__c> logs = repository.getRecent('TeamFacilitator', 1);
    Test.stopTest();

    System.assert(logs.isEmpty(), 'No logs should be returned');
  }

  @isTest
  static void getRecent_returnsLogs_whenFacilitatorLog() {
    setup();
    Team__c team = TestTeam.create();
    Log__c log = new Log__c(
      Team__c = team.Id,
      OtherHours__c = 3,
      PublicAccessHours__c = 2,
      Submitter__c = team.Client__c,
      RecordTypeId = FACILITATOR_ID,
      Date__c = Date.today().addDays(-2)
    );
    insert log;
    LogRepository repository = new LogRepository();

    Test.startTest();
    List<Log__c> logs = repository.getRecent('TeamFacilitator', 3);
    Test.stopTest();

    System.assertEquals(1, logs.size(), 'Just the one log should be returned');
    Team__c actual = logs[0].Team__r;
    System.Assert.areEqual(
      team.Client__c,
      actual.Client__c,
      'Team should be returned'
    );
    System.Assert.areEqual(team.Name, actual.Name, 'Team should be returned');
    System.Assert.areEqual(
      team.Dog__c,
      actual.Dog__c,
      'Team should be returned'
    );
    System.assertEquals(
      team.Facilitator__c,
      actual.Facilitator__c,
      'Team should be returned'
    );
  }
}
