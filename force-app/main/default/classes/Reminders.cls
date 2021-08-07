global class Reminders implements Schedulable {
    public Reminders() {
    }

    global void execute(SchedulableContext SC) {
        Date month = Date.today().addMonths(1);
        Date week = Date.today().addDays(7);
        // Find out which assignments may need reminder tasks.
        // Note we cannot join with Tasks since that is not supported.
        List<ProgramAssignment__c> assignments = [
            SELECT id, Contact__c, ExpectedCompletion__c
            FROM ProgramAssignment__c
            WHERE
                Status__c = 'In progress'
                AND ((Program__c = 'Volunteer'
                AND ExpectedCompletion__c <= :week)
                OR (Program__c != 'Volunteer'
                AND ExpectedCompletion__c <= :month))
        ];

        Group adminGroup = [
            SELECT id
            FROM Group
            WHERE Name = 'Program Administrator'
            LIMIT 1
        ];
        // Create a reminder task if one hasn't been already created
        for (ProgramAssignment__c assignment : assignments) {
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
