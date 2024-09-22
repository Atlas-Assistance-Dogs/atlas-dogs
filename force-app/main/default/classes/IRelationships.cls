public interface IRelationships extends IApplicationSObjectDomain {
    Map<String, Boolean> validateUserSso(List<String> ssoId);
}