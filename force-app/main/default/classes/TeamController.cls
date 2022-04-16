public with sharing class TeamController {
    @AuraEnabled(Cacheable=true)
    public static List<Team__c> getRelatedTeams(id recordId) {
        try {
            List<Team__c> teams = [
                SELECT
                    Facilitator__c,
                    Handler__c,
                    NextPatDue__c,
                    PatCount__c,
                    PrimaryCertification__c,
                    SecondaryCertification__c,
                    Trainer__c
                FROM Team__c
                WHERE
                    Facilitator__c = :recordId
                    OR Handler__c = :recordId
                    OR Trainer__c = :recordId
            ];
            List<DogRelationship__c> relationships = [
                SELECT Team__c
                FROM DogRelationship__c
                WHERE
                    (Contact__c = :recordId
                    OR Dog__c = :recordId)
                    AND Team__c != NULL
            ];

            List<ID> relatedTeams = new List<ID>();

            for (DogRelationship__c relationship : relationships) {
                relatedTeams.add(relationship.Team__c);
            }

            teams.addall(
                [
                    SELECT
                        Facilitator__c,
                        Handler__c,
                        NextPatDue__c,
                        PatCount__c,
                        PrimaryCertification__c,
                        SecondaryCertification__c,
                        Trainer__c
                    FROM Team__c
                    WHERE Id IN :relatedTeams
                ]
            );

            return teams;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
