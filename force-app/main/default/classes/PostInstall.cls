global class PostInstall implements InstallHandler {
    global void onInstall(InstallContext context) {
        if (context == null) {
            return;
        }
        if (context.previousVersion() == null) {
            return;
        }
        if (context.previousVersion().compareTo(new Version(1, 4)) <= 0) {
            try {
                combineDogVaccineFields();
                linkTeamLogs();
                moveSystemAccess();
                linkTeamDocuments();                
            } catch (Exception e) {
                send(
                    context.installerId(),
                    'Installation Failure' + context.organizationId(),
                    ' e: ' + e.getMessage() + ' stack trace ' + e.getStackTraceString()
                );
            }
        }
        if (context.previousVersion().compareTo(new Version(1, 5)) <= 0) {
            setBackgroundCheckTypes();
        }
    }

    private Date later(Date latest, Date vaccine) {
        if (latest == null) {
            return vaccine;
        }
        if (vaccine > latest) {
            return vaccine;
        }
        return latest;
    }

    public void combineDogVaccineFields() {
        // combine dog vaccine fields
        List<Dog__c> dogs = [
            SELECT
                Name,
                VaccineDueDA2PP__c,
                VaccineDueDistemper__c,
                VaccineDueHepatitis__c,
                VaccineDueParainfluenza__c,
                VaccineDueParvovirus__c
            FROM Dog__c
        ];
        for (Dog__c dog : dogs) {
            Date latest = later(
                dog.VaccineDueDistemper__c,
                dog.VaccineDueHepatitis__c
            );
            latest = later(latest, dog.VaccineDueParainfluenza__c);
            latest = later(latest, dog.VaccineDueParvovirus__c);
            dog.VaccineDueDA2PP__c = latest;
        }
        update dogs;
    }

    // For each Team, tie the Client and Dog documents to it
    global static void linkTeamDocuments() {
        AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
        settings.LinkFilesToTeamMembers__c = false;
        upsert settings;

        List<Team__c> teams = [SELECT Id, Client__c, Dog__c FROM Team__c];
        List<ContentDocumentLink> links = new List<ContentDocumentLink>();
        List<Id> clientIds = new List<Id>();
        List<Id> dogIds = new List<Id>();
        List<Id> teamIds = new List<Id>();
        for (Team__c team : teams) {
            teamIds.add(team.Id);
            List<ContentVersion> clientDocs = getEntityDocs(team.Client__c, 'Client');
            for (ContentVersion cv : clientDocs) {
                links.add(new ContentDocumentLink(
                    ContentDocumentId = cv.ContentDocumentId,
                    LinkedEntityId = team.Id
                ));
            }

            List<ContentVersion> dogDocs = getEntityDocs(team.Dog__c, 'Dog');
            for (ContentVersion cv : dogDocs) {
                if (cv.Type__c == 'VacExams') {
                    continue;
                }
                links.add(new ContentDocumentLink(
                    ContentDocumentId = cv.ContentDocumentId,
                    LinkedEntityId = team.Id
                ));
            }
        }

        FileService.insertLinks(links, teamIds);
        settings.LinkFilesToTeamMembers__c = true;
        upsert settings;
    }

    public static List<ContentVersion> getEntityDocs(Id id, String category) {
        // find the documents linked to the clients
        List<ContentDocumentLink> cdls = [
            SELECT ID, ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :id
        ];
        List<Id> docIds = new List<Id>();
        for (ContentDocumentLink cdl: cdls) {
            docIds.add(cdl.ContentDocumentId);
        }
        List<ContentVersion> cvs = [SELECT Id, ContentDocumentId, Category__c, Type__c FROM ContentVersion WHERE ContentDocumentId IN :docIds AND Category__c = :category];

        return cvs;
    }

    public void linkTeamLogs() {
        // Get the list of teams
        List<Team__c> teams = [
            SELECT Id, Client__c, Dog__c, Handler__c
            FROM Team__c
        ];

        for (Team__c team : teams) {
            // get the logs that match
            List<Log__c> logs = [
                SELECT Id, Team__c
                FROM Log__c
                WHERE Client__c = :team.Client__c AND Dog__c = :team.Dog__c
            ];
            for (Log__c log : logs) {
                // set the team
                log.Team__c = team.Id;
            }
            update logs;
        }
    }

    public void moveSystemAccess() {
        List<Contact> contacts = [
            SELECT Id, SystemAccess__c, VolunteerAccess__c
            FROM Contact
            WHERE VolunteerAccess__c != NULL
        ];
        for (Contact contact : contacts) {
            contact.SystemAccess__c = contact.VolunteerAccess__c;
            contact.VolunteerAccess__c = null;
        }
        update contacts;
    }

    public static void send(Id userId, String subject, String htmlBody) {
        List<User> users = [SELECT Name, FirstName, LastName, UserName, Email FROM User WHERE Id = :userId ];
        User u = users.size() > 0 ? users[0] : new User(Id = userId);
        sendEmail(
            new List<String>{u.Email, 'deborahe@atlasdog.org'}, // <= replace with your default email
            subject,
            htmlBody,
            new Map<String, Blob>()
        );
    }

    public static Boolean sendEmail(List<String> recipients, String subject, String htmlBody, Map<String, Blob> attachments) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(recipients);
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        List<Messaging.EmailFileAttachment> attachmentsList = new List<Messaging.EmailFileAttachment>();        
        for (String fileName: attachments.keySet()) {
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName(fileName);
            attachment.setBody(attachments.get(fileName));
            attachmentsList.add(attachment);
        }
        mail.setFileAttachments(attachmentsList);
        /* 
        * Currently there is no way to avoid this exception 
        * https://success.salesforce.com/ideaView?id=08730000000cHBEAA2
        */
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
            return true;
        } catch (EmailException e) {
            //emailInvocationFailures++;
            return false;
        }
    }

    private void setBackgroundCheckTypes() {
        List<BackgroundCheck__c> checks = [SELECT Id, Type__c FROM BackgroundCheck__c];
        for (BackgroundCheck__c check : checks) {
            check.Type__c = 'Criminal';
        }
        update checks;
    }
}
