public interface ITeams extends IApplicationSObjectDomain {
    Map<String, Boolean> validateUserSso(List<Team__c> teams);
}
