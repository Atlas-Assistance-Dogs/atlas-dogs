public with sharing class UserService {
    public static List<String> GetGroupNames(ID userId) {
        //Declaring a Set as we don't want Duplicate Group Ids
        Set<Id> results = new Set<Id>();

        // add the groups that the user is the owner of
        // handy particularly in scratch orgs
        List<Group> ownedGroups = [SELECT Id, Name FROM Group WHERE OwnerId = :userId OR CreatedById = :userId];
        for (Group gr: ownedGroups) {
            results.add(gr.Id);
        }

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

        //Groups with Role
        for (User user : [SELECT UserRoleId FROM User WHERE id = :userId]) {
            //Checking if the current User Role is part of Map or not
            if (grRoleMap.containsKey(user.UserRoleId)) {
                results.add(grRoleMap.get(user.UserRoleId));
            }
        }

        //Get all the groups and put in a map so we can associate direct and indirectly added groups
        Map<Id, Id> grMap = new Map<Id, Id>();
        for (GroupMember gm : [
            SELECT id, UserOrGroupId, Groupid
            FROM GroupMember
            WHERE
                Group.Type = 'Regular'
                OR Group.Type = 'Role'
                OR Group.Type = 'RoleAndSubordinates'
        ]) {
            grMap.put(gm.UserOrGroupId, gm.Groupid);
            if (gm.UserOrGroupId == userId || results.contains(gm.UserOrGroupId)) {
                results.add(gm.GroupId);
            }
        }

        // Second check for related
        List<Id> moreGroups = new List<Id>();
        for (Id groupId : results) {
            if (grMap.containsKey(groupId)) {
                moreGroups.add(grMap.get(groupId));
            }
        }
        results.addAll(moreGroups);

        List<Group> groups = [SELECT Id, Name FROM Group WHERE Id IN :results];
        List<String> groupNames = new List<String>();
        for (Group grp : groups) {
            groupNames.add(grp.Name);
        }
        return groupNames;
    }
}
