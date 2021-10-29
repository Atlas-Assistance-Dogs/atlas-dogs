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

    static testMethod void jobDoesNotCreateTasks_WhenNoAssignments() {
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule(
            'ScheduledApexTest',
            CRON_EXP,
            new Reminders()
        );
        // Verify the scheduled job has not run yet.
        List<Task> tasks = [SELECT Id FROM Task];
        System.assertEquals(0, tasks.size(), 'Tasks exist before job has run');
        // Stopping the test will run the job synchronously
        Test.stopTest();
        tasks = [SELECT Id FROM Task];
        System.assertEquals(0, tasks.size(), 'Tasks created when not expected');
    }

    static testMethod void jobDoesNotCreateTask_WhenNotDue() {
        createRecords();

        List<ProgramAssignment__c> assignments = new List<ProgramAssignment__c>();

        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addDays(12),
                Program__c = 'Volunteer',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addMonths(2),
                Program__c = 'Team Facilitator',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addMonths(3),
                Program__c = 'Trainer',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addMonths(3),
                Program__c = 'Client',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addMonths(4),
                Program__c = 'Teams Set in Motion Client',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addMonths(5),
                Program__c = 'Sweet Snoopers Trainer',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );

        insert assignments;
        // Get the IDs of the assignments we just inserted
        Map<Id, ProgramAssignment__c> assignmentMap = new Map<Id, ProgramAssignment__c>(
            assignments
        );
        List<Id> assignmentIds = new List<Id>(assignmentMap.keySet());
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule(
            'ScheduledApexTest',
            CRON_EXP,
            new Reminders()
        );
        // Verify the scheduled job has not run yet.
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId IN :assignmentIds];
        System.assertEquals(0, tasks.size(), 'Tasks exist before job has run');
        // Stopping the test will run the job synchronously
        Test.stopTest();
        tasks = [SELECT Id FROM Task WHERE WhatId IN :assignmentIds];
        System.assertEquals(0, tasks.size(), 'Tasks created when not expected');
    }

    static testMethod void jobCreatesTask_WhenVolunteer() {
        createRecords();

        ProgramAssignment__c assignment = new ProgramAssignment__c(
            AssignedDate__c = Date.today().addDays(-8),
            ExpectedCompletion__c = Date.today().addDays(7),
            Program__c = 'Volunteer',
            Status__c = 'In progress',
            Contact__c = joe.Id
        );
        insert assignment;
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

    private static List<Id> createDueAssignments() {
        List<ProgramAssignment__c> assignments = new List<ProgramAssignment__c>();

        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addDays(2),
                Program__c = 'Volunteer',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addDays(21),
                Program__c = 'Team Facilitator',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addDays(29),
                Program__c = 'Trainer',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addDays(30),
                Program__c = 'Client',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addDays(16),
                Program__c = 'Teams Set in Motion Client',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        assignments.add(
            new ProgramAssignment__c(
                AssignedDate__c = Date.today().addDays(-2),
                ExpectedCompletion__c = Date.today().addDays(22),
                Program__c = 'Sweet Snoopers Trainer',
                Status__c = 'In progress',
                Contact__c = joe.Id
            )
        );
        insert assignments;

        // Get the IDs of the assignments we just inserted
        Map<Id, ProgramAssignment__c> assignmentMap = new Map<Id, ProgramAssignment__c>(
            assignments
        );
        List<Id> assignmentIds = new List<Id>(assignmentMap.keySet());
        return assignmentIds;
    }

    static testMethod void jobCreatesTasks_WhenDoNotExist() {
        createRecords();
        List<Id> assignmentIds = createDueAssignments();

        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule(
            'ScheduledApexTest',
            CRON_EXP,
            new Reminders()
        );
        // Verify the scheduled job has not run yet.
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId IN :assignmentIds];
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
            WHERE WhatId IN :assignmentIds
        ];
        System.assertEquals(
            assignmentIds.size(),
            tasks.size(),
            'Tasks were not created'
        );
        for (Task remind : tasks) {
            System.assertEquals(joe.Id, remind.WhoId);
            System.assertEquals(adminGroup.Id, remind.OwnerId);
            System.assertEquals(
                'Check on Program progress',
                remind.Description
            );
            System.assertEquals('Normal', remind.Priority);
            System.assertEquals('Call', remind.Type);
            System.assertEquals('Other', remind.Subject);
            System.assert(remind.IsReminderSet);
            System.assertEquals(Date.today(), remind.ReminderDateTime.date());
        }
    }

    static testMethod void jobDoesNotCreatesTasks_WhenExist() {
        createRecords();
        List<Id> assignmentIds = createDueAssignments();

        // add tasks for these assignments
        List<Task> existing = new List<Task>();
        for (Id assId : assignmentIds) {
            existing.add(new Task(WhatId = assId));
        }
        insert existing;

        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule(
            'ScheduledApexTest',
            CRON_EXP,
            new Reminders()
        );
        // Verify the scheduled job has not run yet.
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId IN :assignmentIds];
        System.assertEquals(
            assignmentIds.size(),
            tasks.size(),
            'Tasks added before job has run'
        );
        // Stopping the test will run the job synchronously
        Test.stopTest();
        tasks = [SELECT Id FROM Task WHERE WhatId IN :assignmentIds];
        System.assertEquals(
            assignmentIds.size(),
            tasks.size(),
            'Tasks created when not expected'
        );
    }

    static testMethod void jobDoesNotCreateTasks_WhenNotInProgress() {
        createRecords();
        List<Id> assignmentIds = createDueAssignments();

        // Set each assignment to completed
        List<ProgramAssignment__c> assignments = [
            SELECT Id, Status__c
            FROM ProgramAssignment__c
        ];
        assignments[0].Status__c = '';

        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule(
            'ScheduledApexTest',
            CRON_EXP,
            new Reminders()
        );
        // Verify the scheduled job has not run yet.
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId IN :assignmentIds];
        System.assertEquals(0, tasks.size(), 'Tasks exist before job has run');
        // Stopping the test will run the job synchronously
        Test.stopTest();
    }
}