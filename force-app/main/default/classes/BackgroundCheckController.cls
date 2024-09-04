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

    public void createReminderTask() {
        AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
        // check to see if this setting is missing
        if (settings.BackgroundCheckRenewalYears__c == null) {
            AtlasSettings__c temp = new AtlasSettings__c();
            settings.BackgroundCheckRenewalYears__c = settings.BackgroundCheckRenewalYears__c;
            upsert settings;
        }
        // find the cutoff for which background checks to remind
        Date threshold = Date.today()
            .addYears(-1 * (Integer)settings.BackgroundCheckRenewalYears__c)
            .addMonths(1);
            
        // Get the group to assign the task to
        Group adminGroup = [SELECT Id FROM Group WHERE Name = 'Background Check Administrator' AND Type = 'Queue'];
        System.debug(adminGroup);
        BackgroundCheck__c[] checks = [
            SELECT Id, Contact__c, Contact__r.Name
            FROM BackgroundCheck__c
            WHERE Date__c < :threshold AND (
                Contact__r.VolunteerAccess__c = 'Credit Check Required'
                OR Contact__r.VolunteerAccess__c = 'Background Check Required'
            )
            ORDER BY Date__c DESC // get the most recent first
        ];
        // Make sure we only have one Background check per contact
        Set<Id> contactIds = new Set<Id>();
        // Create a list of Tasks
        Task[] tasks = new List<Task>();
        for (BackgroundCheck__c check : checks) {
            if (contactIds.contains(check.Contact__c)) {
                continue;
            }
            contactIds.add(check.Contact__c);
            tasks.add(new Task(
                OwnerId = adminGroup.Id,
                Subject = 'Order background check',
                Status = 'Open',
                Priority = 'Normal',
                WhoId = check.Contact__c,
                DueDate = check.Date__c.addYears(1)
            ));
        }   
        // Check for any cantacts that need background checks that don't have them
        Contact[] contacts = [
            SELECT Id, Name
            FROM Contact
            WHERE Id NOT IN :contactIds AND
                (VolunteerAccess__c = 'Credit Check Required'
                OR VolunteerAccess__c = 'Background Check Required')
        ];
        // create a list of the contact ids
        for (Contact person : contacts) {
            tasks.add(new Task(
                OwnerId = adminGroup.Id,
                Subject = 'Order background check',
                Description = 'Order background check',
                Priority = 'Normal',
                Type = 'Other',
                IsReminderSet = true,
                ReminderDateTime = System.now(),
                WhoId = person.Id
            ));
        }

        insert tasks;
    }
}
