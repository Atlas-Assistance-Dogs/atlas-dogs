global class PostInstall implements InstallHandler {
    global void onInstall(InstallContext context) {
        if (context == null) {
            return;
        }
        if (context.previousVersion() == null) {
            return;
        }
        if (context.previousVersion().compareTo(new Version(1, 3)) <= 0) {
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
        if (context.previousVersion().compareTo(new Version(1, 4)) <= 0) {
            linkTeamDocuments();
            linkTeamLogs();
            moveSystemAccess();
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

    // Grab all the CV with Client category,
    // and link them to a team if possible.
    // The CDL trigger will fill in the fields
    private void linkTeamDocuments() {
        List<ContentVersion> cvs = [SELECT Id, ContentDocumentId, Category__c, Type__c FROM ContentVersion WHERE Category__c = 'Client'];
        List<Id> docIds = new List<Id>();
        for (ContentVersion cv : cvs) {
            docIds.add(cv.ContentDocumentId);
        }
        // I wanted to group by linkedEntityId, and get a dictionary of lists,
        // but SOQL apparently doesn't do that
        List<ContentDocumentLink> links = [
            SELECT ID, ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE ContentDocumentId IN :docIds
            ORDER BY LinkedEntityId];

        Map<Id, List<ContentDocumentLink>> groupedLinks = new Map<Id, List<ContentDocumentLink>>();

        // let's create the map here so we don't need to add logic to track when the linked entity changes below
        for (ContentDocumentLink link : links) {
            // see if this entity is a Contact, if not, skip it
            string objName = link.LinkedEntityId.getSObjectType().getDescribe().getName();
            if (objName != Contact.class.getName()) {
                continue;
            }

            List<ContentDocumentLink> entityDocs = groupedLinks.get(link.LinkedEntityId);
            if (entityDocs == null) {
                entityDocs = new List<ContentDocumentLink>();
                groupedLinks.put(link.LinkedEntityId, entityDocs);
            }
            entityDocs.add(link);
        }
        // Let's use one big list of CDLs for all the teams
        List<ContentDocumentLink> teamLinks = new List<ContentDocumentLink>();

        // Now, loop through the contacts, find associated teams (status is new to this version,
        // so we'll use the Team with PatValidUntil that matches ClientCertificationValidUntil if there
        // is more than one)
        for (Id contactId : groupedLinks.keySet()) {
            List<Team__c> teams = [SELECT Id, PatValidUntil__c FROM Team__c WHERE Client__c = :contactId];
            if (teams.size() == 0) {
                continue; // nothing more we can do
            }
            Team__c team = teams[0];
            if (teams.size() > 1) {
                // Get the ClientCertificationValidUntil value for this Contact.
                // We know this is a contact from the check above, so this better be a safe query
                Contact contact = [SELECT Id, ClientCertificationValidUntil__c FROM Contact WHERE Id = :contactId];
                for (Team__c tm : teams) {
                    if (tm.PatValidUntil__c == contact.ClientCertificationValidUntil__c) {
                        team = tm;
                        break;
                    }
                }
            }
            // Now we can link the documents to the team
            for (ContentDocumentLink clientLink : groupedLinks.get(contactId)) {
                teamLinks.add(new ContentDocumentLink(
                    ContentDocumentId = clientLink.ContentDocumentId,
                    LinkedEntityId = team.Id
                ));
            }
        }

        insert teamLinks;
    }

    private void linkTeamLogs() {
        // Get the list of teams
        List<Team__c> teams = [SELECT Id, Client__c, Dog__c, Handler__c FROM Team__c];

        for (Team__c team : teams) {
            // get the logs that match
            List<Log__c> logs = [SELECT Id, Team__c FROM Log__c WHERE Client__c = :team.Client__c AND Dog__c = :team.Dog__c];
            for (Log__c log : logs) {
                // set the team
                log.Team__c = team.Id;
            }
            update logs;
        }
    }

    private void moveSystemAccess() {
        List<Contact> contacts = [SELECT Id, SystemAccess__c, VolunteerAccess__c FROM Contact WHERE VolunteerAccess__c != null];
        for (Contact contact : contacts) {
            contact.SystemAccess__c = contact.VolunteerAccess__c;
            contact.VolunteerAccess__c = null;
        }
        update contacts;
    }
}
