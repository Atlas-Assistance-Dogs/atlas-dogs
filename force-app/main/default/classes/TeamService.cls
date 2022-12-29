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

    private static Set<string> inactiveStatus = new Set<string> {'Decertified', 'Discontinued'};
    
    // Update client status.  This is meant to be called from the team update trigger.
    public static void updateClientStatus(Team__c team) {
        if (inactiveStatus.contains(team.Status__c)) {
            return;
        }

        List<Contact> clients = [SELECT ClientStatus__c, ClientCertificationValidUntil__c FROM Contact WHERE Id = :team.Client__c];

        if (!clients.isEmpty()) {
            Contact client = clients[0];
            client.ClientCertificationValidUntil__c = team.CertificationValidUntil__c;
            client.ClientStatus__c = team.Status__c;
        }
    }
}
