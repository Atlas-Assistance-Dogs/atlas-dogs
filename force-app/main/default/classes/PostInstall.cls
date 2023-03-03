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
                system.debug(dog);
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
