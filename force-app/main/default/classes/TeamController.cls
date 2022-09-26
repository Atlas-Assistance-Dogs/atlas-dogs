public with sharing class TeamController {
    @AuraEnabled(Cacheable=true)
    public static RelatedObjects getRelatedTeams(id recordId) {
        try {
            List<Team__c> teams = [
                SELECT
                    Client__c,
                    Client__r.Name,
                    Dog__c,
                    Dog__r.Name,
                    Handler__c,
                    Handler__r.Name,
                    Name,
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
            RelatedObjects related = new RelatedObjects();
            for (Team__c team : teams) {
                TeamRow row = new TeamRow();
                row.id = team.Id;
                row.name = team.Name;
                row.client = team.Client__c;
                row.clientName = team.Client__r.Name;
                row.handler = team.Handler__c;
                row.handlerName = team.Handler__r.Name;
                row.dog = team.Dog__c;
                row.dogName = team.Dog__r.Name;
                row.certification = team.PrimaryCertification__c;
                row.patCount = (Integer)team.PatCount__c;
                row.nextPat = team.PatValidUntil__c;
                related.items.add(row);
            }
            related.total = [SELECT COUNT() FROM Team__c WHERE Client__c = :recordId
                    OR Handler__c = :recordId
                    OR Dog__c = :recordId];
            return rows;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
