global class Reminders implements Schedulable {
  private final String groupName;

  // default constructor
  public Reminders() {
    groupName = 'Program Administrator';
  }

  // used for test
  public Reminders(String name) {
    groupName = name;
  }

  global void execute(SchedulableContext SC) {
    // Find out which assignments may need reminder tasks.
    // Note we cannot join with Tasks since that is not supported.
    // NOTE: We need to use literals when filtering dates, so break down by weeks and hit the
    // ones we expect to see most
    List<ProgramAssignment__c> assignments = [
      SELECT
        id,
        Contact__c,
        ExpectedCompletion__c,
        Program__r.Name,
        Program__r.Reminder__c
      FROM ProgramAssignment__c
      WHERE
        Status__c = 'In progress'
        AND Program__r.Reminder__c != 0
        AND ((Program__r.Reminder__c >= 30
        AND ExpectedCompletion__c <= NEXT_N_DAYS:30)
        OR (Program__r.Reminder__c >= 21
        AND ExpectedCompletion__c <= NEXT_N_DAYS:21)
        OR (Program__r.Reminder__c >= 14
        AND ExpectedCompletion__c <= NEXT_N_DAYS:14)
        OR (Program__r.Reminder__c >= 7
        AND ExpectedCompletion__c <= NEXT_N_DAYS:7)
        OR ExpectedCompletion__c = TODAY)
    ];

    Group adminGroup = [
      SELECT id
      FROM Group
      WHERE Name = :groupName
      LIMIT 1
    ];

    // Create a reminder task if one wasn't already created
    for (ProgramAssignment__c assignment : assignments) {
      if (
        Date.today().addDays((integer) assignment.Program__r.Reminder__c) <
        assignment.ExpectedCompletion__c
      ) {
        continue; // don't need to remind yet
      }
      List<Task> createdTasks = [
        SELECT id
        FROM TASK
        WHERE WhatId = :assignment.id
      ];
      if (createdTasks.size() == 0) {
        // Create a reminder task
        Task newTask = new Task(
          OwnerId = adminGroup.id,
          Description = 'Check on Program progress',
          Priority = 'Normal',
          Type = 'Call',
          Subject = 'Other',
          WhatId = assignment.id,
          WhoId = assignment.Contact__c,
          IsReminderSet = true,
          ReminderDateTime = System.now()
        );
        insert newTask;
      }
    }
  }
}
