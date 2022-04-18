public with sharing class TeamController {
    @AuraEnabled(Cacheable=true)
    public static List<Team__c> getRelatedTeams(id recordId) {
        try {
            List<Team__c> teams = [
                SELECT
                    Client__c,
                    Dog__c,
                    Handler__c,
                    PatValidUntil__c,
                    PatCount__c,
                    PrimaryCertification__c,
                    SecondaryCertification__c
                FROM Team__c
                WHERE
                    Client__c = :recordId
                    OR Handler__c = :recordId
                    OR Dog__c = :recordId
            ];

            return teams;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
