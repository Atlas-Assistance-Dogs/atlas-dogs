global class Reminders implements Schedulable {
    public Reminders() {
    }

    global void execute(SchedulableContext SC) {
        Date month = Date.today().addMonths(1);
        Date twoWeeks = Date.today().addDays(-14);
        // Find out which assignments may need reminder tasks.
        // Note we cannot join with Tasks since that is not supported.
        List<ProgramAssignment__c> assignments = [
            SELECT id, Contact__c, ExpectedCompletion__c
            FROM ProgramAssignment__c
            WHERE
                Status__c = 'In progress'
                AND ((Program__c = 'Volunteer'
                AND ExpectedCompletion__c <= :twoWeeks)
                OR (Program__c != 'Volunteer'
                AND ExpectedCompletion__c <= :month))
        ];

        Group adminGroup = [
            SELECT id
            FROM Group
            WHERE Name = 'Program Administrator'
        ];
        // Create a reminder task if one hasn't been already created
        for (ProgramAssignment__c assignment : assignments) {
            Task createdTask = [
                SELECT id
                FROM TASK
                WHERE WhatId = :assignment.id
                LIMIT 1
            ];
            if (createdTask == null) {
                // Create a reminder task
                Task newTask = new Task(
                    OwnerId = adminGroup.id,
                    Description = 'Check on Program progress',
                    Priority = 'Normal',
                    Type = 'Call',
                    Subject = 'Other',
                    WhatId = assignment.id,
                    WhoId = assignment.Contact__r.id,
                    IsReminderSet = true,
                    ReminderDateTime = System.now() + 1
                );
                insert newTask;
            }
        }
    }
}
