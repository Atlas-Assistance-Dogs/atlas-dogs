@isTest
public with sharing class TestReminders {
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    private static Group adminGroup;
    private static Contact joe;

    static void createRecords() {
        //adminGroup = new Group(Name = 'Program Administrator', Type = 'Queue');
        //insert adminGroup;
        adminGroup = [
            SELECT id
            FROM Group
            WHERE Name = 'Program Administrator'
            LIMIT 1
        ];

        joe = new Contact(FirstName = 'Joe', LastName = 'Blow');
        insert joe;

        QueueSobject mappingObject = new QueueSobject(
            QueueId = adminGroup.Id,
            SobjectType = 'Task'
        );
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert mappingObject;
        }
    }

    static testMethod void testScheduledJob() {
        createRecords();

        ProgramAssignment__c assignment = new ProgramAssignment__c(
            AssignedDate__c = Date.today().addDays(-8),
            ExpectedCompletion__c = Date.today().addDays(7),
            Program__c = 'Volunteer',
            Status__c = 'In progress',
            Contact__c = joe.Id
        );
        insert assignment;
        // Get the ID of the assignment we just inserted
        /*Map<Id, ProgramAssignment__c> opptyMap = new Map<Id, ProgramAssignment__c>(opptys);
         List<Id> opptyIds = new List<Id>(opptyMap.keySet());*/
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule(
            'ScheduledApexTest',
            CRON_EXP,
            new Reminders()
        );
        // Verify the scheduled job has not run yet.
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :assignment.Id];
        System.assertEquals(0, tasks.size(), 'Tasks exist before job has run');
        // Stopping the test will run the job synchronously
        Test.stopTest();
        // Now that the scheduled job has executed,
        // check that our tasks were created
        tasks = [
            SELECT
                Id,
                WhoId,
                OwnerId,
                Description,
                Priority,
                Type,
                Subject,
                IsReminderSet,
                ReminderDateTime
            FROM Task
            WHERE WhatId = :assignment.Id
        ];
        System.assertEquals(1, tasks.size(), 'Task was not created');
        Task remind = tasks[0];
        System.assertEquals(joe.Id, remind.WhoId);
        System.assertEquals(adminGroup.Id, remind.OwnerId);
        System.assertEquals('Check on Program progress', remind.Description);
        System.assertEquals('Normal', remind.Priority);
        System.assertEquals('Call', remind.Type);
        System.assertEquals('Other', remind.Subject);
        System.assert(remind.IsReminderSet);
        System.assertEquals(Date.today(), remind.ReminderDateTime.date());
    }
}
