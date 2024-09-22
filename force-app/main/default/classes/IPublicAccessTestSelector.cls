public interface IPublicAccessTestSelector extends IApplicationSObjectSelector {
    List<PublicAccessTest__c> selectById(Set<Id> idSet);
    PublicAccessTest__c selectById(Id idSet);
    List<PublicAccessTest__c> selectTeamPassing(Id teamId);
}
