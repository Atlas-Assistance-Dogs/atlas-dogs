trigger TeamTrigger on Team__c (after insert, after update) {
    for (Team__c newTeam : Trigger.new) {
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
                continue; // check next team
            }
            // otherwise, add Client to the first relationship (should be the only one)
            DogRelationShip__c relationShip = relationShips[0];
            relationShip.Type__c = relationShip.Type__c + ';Client';
            update relationShip;
        }
    }
}