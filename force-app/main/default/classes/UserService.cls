public with sharing class UserService {
    public static List<String> GetGroupNames(ID userId) {
        //Declaring a Set as we don't want Duplicate Group Ids
        Set<Id> results = new Set<Id>();

        ///Declaring a Map for Group with Role
        Map<Id, Id> grRoleMap = new Map<Id, Id>();

        //Populating the Map with RelatedID(i.e.UserRoledId) as Key
        for (Group gr : [
            SELECT Id, RelatedId, Name
            FROM Group
            WHERE RelatedId != NULL
        ]) {
            grRoleMap.put(gr.relatedId, gr.id);
        }

        //Groups directly associated to user
        Set<Id> groupWithUser = new Set<Id>();

        //Populating the Group with User with GroupId we are filtering only  for Group of Type Regular,Role and RoleAndSubordinates
        for (GroupMember gm : [
            SELECT groupId
            FROM GroupMember
            WHERE
                UserOrGroupId = :userId
                AND (Group.Type = 'Regular'
                OR Group.Type = 'Role'
                OR Group.Type = 'RoleAndSubordinates')
        ]) {
            groupWithUser.add(gm.groupId);
        }

        //Groups with Role
        for (User user : [SELECT UserRoleId FROM User WHERE id = :userId]) {
            //Checking if the current User Role is part of Map or not
            if (grRoleMap.containsKey(user.UserRoleId)) {
                results.add(grRoleMap.get(user.UserRoleId));
            }
        }
        //Combining both the Sets
        results.addAll(groupWithUser);

        //Traversing the whole list of Groups to check any other nested Group
        Map<Id, Id> grMap = new Map<Id, Id>();
        for (GroupMember gr : [
            SELECT id, UserOrGroupId, Groupid
            FROM GroupMember
            WHERE
                Group.Type = 'Regular'
                OR Group.Type = 'Role'
                OR Group.Type = 'RoleAndSubordinates'
        ]) {
            grMap.put(gr.UserOrGroupId, gr.Groupid);
        }
        for (Id groupId : results) {
            if (grMap.containsKey(groupId)) {
                results.add(grMap.get(groupId));
            }
        }

        List<Group> groups = [SELECT Id, Name FROM Group WHERE Id IN :results];
        List<String> groupNames = new List<String>();
        for (Group grp : groups) {
            groupNames.add(grp.Name);
        }
        return groupNames;
    }
}
