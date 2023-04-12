public with sharing class TeamService {
    // Set the dog/client relationship.
    // This is meant to be called from the team update trigger.
    public static void setClientDogRelationShip(Team__c newTeam) {
        // See if there is an existing relationship between the dog and client
        List<DogRelationShip__c> relationShips = [SELECT Id, Type__c FROM DogRelationShip__c
            WHERE Contact__c = :newTeam.Client__c AND Dog__c = :newTeam.Dog__c];

        if (relationShips.size() == 0) {
            DogRelationShip__c relationShip = new DogRelationShip__c(
                Contact__c = newTeam.Client__c,
                Dog__c = newTeam.Dog__c,
                Type__c = 'Client'
            );
            insert relationShip;
        }
        else {
            Boolean found = false;
            // add client to the type if not already there
            for (DogRelationShip__c relationShip : relationShips) {
                if (relationShip.Type__c.contains('Client')) {
                    found = true;
                    break;
                }
            }
            if (found) {
                return; // check next team
            }
            // otherwise, add Client to the first relationship (should be the only one)
            DogRelationShip__c relationShip = relationShips[0];
            relationShip.Type__c = relationShip.Type__c + ';Client';
            update relationShip;
        }
    }
        
    // Update client status.  This is meant to be called from the team update trigger.
    public static void updateClientStatus(Team__c team) {
        List<Contact> clients = [SELECT ClientStatus__c, ClientCertificationValidUntil__c FROM Contact WHERE Id = :team.Client__c];

        if (!clients.isEmpty()) {
            Contact client = clients[0];
            client.ClientCertificationValidUntil__c = team.PatValidUntil__c;
            client.ClientStatus__c = team.Status__c;
            update client;
        }
    }
    
    // Update client status.  This is meant to be called from the team update trigger.
    public static void updateDogStatus(Team__c team) {
        List<Dog__c> dogs = [SELECT Status__c FROM Dog__c WHERE Id = :team.Dog__c];

        if (!dogs.isEmpty()) {
            Dog__c dog = dogs[0];
            dog.Status__c = team.Status__c;
            update dog;
        }
    }

    // Update PAT information
    public static void updatePatInformation(Set<Id> teamIds) {
        List<Team__c> teams = [SELECT Id, Client__c, PatValidUntil__c, PatCount__c FROM Team__c WHERE Id IN :teamIds];

        for (Team__c team : teams) {
            List<PublicAccessTest__c> passingPats = [
                SELECT Id, ValidUntil__c
                FROM PublicAccessTest__c
                WHERE Status__c = 'Passed' AND Team__c = :team.Id
                ORDER BY ValidUntil__c DESC];
            if (passingPats.isEmpty()) {
                team.PatValidUntil__c = null;
            }
            else if (team.PatValidUntil__c != passingPats[0].ValidUntil__c) {
                team.PatValidUntil__c = passingPats[0].ValidUntil__c;
            }
            team.PatCount__c = passingPats.size();
        }
        upsert teams;
    }
}
