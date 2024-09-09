public with sharing class TeamService {
    // Set the dog/client relationship.
    // This is meant to be called from the team update trigger.
    public static void setClientDogRelationShip(Team__c newTeam) {
        // See if there is an existing relationship between the dog and client
        List<DogRelationShip__c> relationShips = [
            SELECT Id, Type__c
            FROM DogRelationShip__c
            WHERE Contact__c = :newTeam.Client__c AND Dog__c = :newTeam.Dog__c
        ];

        if (relationShips.size() == 0) {
            DogRelationShip__c relationShip = new DogRelationShip__c(
                Contact__c = newTeam.Client__c,
                Dog__c = newTeam.Dog__c,
                Type__c = 'Client'
            );
            insert relationShip;
        } else {
            Boolean found = false;
            // add client to the type if not already there
            for (DogRelationShip__c relationShip : relationShips) {
                if (
                    relationShip.Type__c != null &&
                    relationShip.Type__c.contains('Client')
                ) {
                    found = true;
                    break;
                }
            }
            if (found) {
                return; // check next team
            }
            // otherwise, add Client to the first relationship (should be the only one)
            DogRelationShip__c relationShip = relationShips[0];
            if (String.isBlank(relationShip.Type__c)) {
                relationShip.Type__c = 'Client';
            } else {
                relationShip.Type__c = relationShip.Type__c + ';Client';
            }
            update relationShip;
        }
    }

    // Update client status.  This is meant to be called from the team update trigger.
    public static void updateClientStatus(Team__c team) {
        List<Contact> clients = [
            SELECT
                ClientStatus__c,
                ClientDog__c,
                ClientCertificationValidUntil__c,
                ClientFacilitatorAvailability__c,
                ClientInitialCertificationDate__c
            FROM Contact
            WHERE Id = :team.Client__c
        ];
        List<Dog__c> dogs = [SELECT Name FROM Dog__c WHERE Id = :team.Dog__c];

        if (!clients.isEmpty()) {
            Contact client = clients[0];
            client.ClientCertificationValidUntil__c = team.PatValidUntil__c;
            client.ClientStatus__c = team.Status__c;
            client.ClientInitialCertificationDate__c = team.InitialCertificationDate__c;
            client.ClientFacilitatorAvailability__c = team.FacilitatorAvailability__c;
            if (!dogs.isEmpty()) {
                client.ClientDog__c = dogs[0].Name;
            }
            update client;
        }
    }

    // Update client status.  This is meant to be called from the team update trigger.
    public static void updateDogStatus(Team__c team) {
        List<Dog__c> dogs = [
            SELECT Status__c
            FROM Dog__c
            WHERE Id = :team.Dog__c
        ];

        if (!dogs.isEmpty()) {
            Dog__c dog = dogs[0];
            dog.Status__c = team.Status__c;
            update dog;
        }
    }

    // Update PAT information
    public static void updatePatInformation(Set<Id> teamIds) {
        List<Team__c> teams = [
            SELECT Id, Client__c, PatValidUntil__c, PatCount__c
            FROM Team__c
            WHERE Id IN :teamIds
        ];

        for (Team__c team : teams) {
            List<PublicAccessTest__c> passingPats = [
                SELECT Id, ValidUntil__c
                FROM PublicAccessTest__c
                WHERE Status__c = 'Passed' AND Team__c = :team.Id
                ORDER BY ValidUntil__c DESC
            ];
            if (passingPats.isEmpty()) {
                team.PatValidUntil__c = null;
            } else if (team.PatValidUntil__c != passingPats[0].ValidUntil__c) {
                team.PatValidUntil__c = passingPats[0].ValidUntil__c;
            }
            team.PatCount__c = passingPats.size();
        }
        upsert teams;
    }
    // Set the dog/client relationship.
    // This is meant to be called from the team update trigger.
    public static void setClientFacilitatorRelationShip(Team__c newTeam) {
        
        // See if there is an existing relationship between the client and facilitator
        List<npe4__Relationship__c> relationShips = [
            SELECT Id, npe4__Type__c, npe4__Status__c, npe4__RelatedContact__c
            FROM npe4__Relationship__c
        ];

        // see if there is an existing relationship object to use
        for (npe4__Relationship__c relationShip : relationShips) {
            if (relationShip.npe4__Type__c == 'Team Faciliator') {
                if (relationShip.npe4__Status__c == 'Current') {
                    return;
                }
                // Set the status to current if not
                relationShip.npe4__Status__c = 'Current';
                update relationShip;
                return;
            }
        }
        if (newTeam.Facilitator__c == null) return; // nothing to do
        // if we made it to here, there isn't an existing relationship, so create a new one
        npe4__Relationship__c relationShip = new npe4__Relationship__c(
            npe4__Contact__c = newTeam.Client__c,
            npe4__RelatedContact__c = newTeam.Facilitator__c,
            npe4__Type__c = 'Team Faciliator',
            npe4__Status__c = 'Current'
        );
        insert relationShip;
    }

    public static void createReminders() {
        List<Team> teams = [SELECT Id, TrainingStartDate__c FROM Team__c WHERE Status__c = 'In Training'];
        // Find Client logs for the last week
        List<Log__c> clientLogs = [SELECT Team__c, Team__r.Client__c, Team__r.Facilitator__c, Team__r.Name, Team__r.Dog__c FROM Log__c WHERE
        RecordType = 'Client' AND
        Date__c > LAST_N_DAYS:7];
        // Find Team Facilitator logs for the last 2 weeks
        List<Log__c> facilitatorLogs = [SELECT Team__c, Team__r.Client__c, Team__r.Facilitator__c, Team__r.Name, Team__r.Dog__c FROM Log__c WHERE
        RecordType = 'Client' AND
        Date__c > LAST_N_DAYS:14];
    }

    // Remind the client in a Team to submit training logs
    public static void remindClient() {

    }
}
