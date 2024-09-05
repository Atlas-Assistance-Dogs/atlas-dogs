public with sharing class BackgroundCheckController {
    // This method is used by the related list component, and needs more than just the background check
    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getRelatedChecks(Id contactId, Integer max) {
        if (max == null) {
            max = 6;
        }
        try {
            RelatedObjects related = new RelatedObjects();
            List<BackgroundCheck__c> checks = [
                SELECT Name, Contact__c, Date__c, Notes__c, Status__c, Type__c
                FROM BackgroundCheck__c
                WHERE Contact__c = :contactId
                LIMIT :max
            ];
            related.total = [
                SELECT COUNT()
                FROM BackgroundCheck__c
                WHERE Contact__c = :contactId
            ];

            for (BackgroundCheck__c bgc : checks) {
                BackgroundCheck outCheck = new BackgroundCheck();
                outCheck.check = bgc;
                outCheck.noFile = true;
                RelatedObjects files = FileController.getAllRelatedFiles(
                    bgc.Id,
                    1
                );
                if (files != null && !files.items.isEmpty()) {
                    FileInfo info = (FileInfo) files.items[0];
                    outCheck.documentId = info.cv.ContentDocumentId;
                    outCheck.fileName = info.cv.Title;
                    outCheck.noFile = false;
                }
                related.items.add(outCheck);
            }
            return related;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void createReminderTask() {
        AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
        // check to see if this setting is missing
        if (settings.BackgroundCheckRenewalYears__c == null) {
            settings.BackgroundCheckRenewalYears__c = 1;
            upsert settings;
        }

        // find the cutoff for which background checks to remind
        Date threshold = Date.today()
            .addYears(-1 * (Integer) settings.BackgroundCheckRenewalYears__c)
            .addMonths(1);
        System.debug(threshold);

        // Get the group to assign the task to
        Group adminGroup = [
            SELECT Id
            FROM Group
            WHERE Name = 'Background Check Administrator' AND Type = 'Queue'
        ];

        // Make sure we only have one Background check per contact
        Set<Id> contactIds = new Set<Id>();
        // Check for any cantacts that need background checks
        Contact[] contacts = [
            SELECT Id, Name
            FROM Contact
            WHERE
                VolunteerAccess__c = 'Credit Check Required'
                OR VolunteerAccess__c = 'Background Check Required'
        ];

        for (Contact person : contacts) {
            contactIds.add(person.Id);
        }

        BackgroundCheck__c[] checks = [
            SELECT Id, Date__c, Contact__c, Contact__r.Name
            FROM BackgroundCheck__c
            WHERE
                Contact__c IN :contactIds
                AND Date__c > :threshold
                AND (Contact__r.VolunteerAccess__c = 'Credit Check Required'
                OR Contact__r.VolunteerAccess__c = 'Background Check Required')
            ORDER BY Date__c DESC // get the most recent first
        ];
        System.debug(checks);
        // Remove the contacts with recent-enough background checks from the list
        for (BackgroundCheck__c check : checks) {
            contactIds.remove(check.Contact__c);
        }

        // Create a list of Tasks
        Task[] tasks = new List<Task>();
        for (Id contactId : contactIds) {
            tasks.add(
                new Task(
                    OwnerId = adminGroup.Id,
                    Subject = 'Order background check',
                    Status = 'Open',
                    Priority = 'Normal',
                    WhoId = contactId,
                    ActivityDate = Date.today().addMonths(1)
                )
            );
        }

        insert tasks;
    }
}
