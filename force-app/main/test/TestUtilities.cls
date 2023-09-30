@isTest
public with sharing class TestUtilities {

    // Create a test user
    public static User createUser() {
        // Create a unique UserName
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User adminUser = new User(
            Alias = 'standt', Email='adminuser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUserName);
        return adminUser;
    }

    public static void addUserToGroups(User user, string[] groupNames) {
        List<Group> groups = [SELECT Id, Name FROM Group WHERE Name in :groupNames];

        // Avoid mixed DML using runAs
        System.runAs(new User(Id = UserInfo.getUserId())) {
            List<GroupMember> gms = new List<GroupMember>();
            for (Group grp : groups) {
                gms.add(new GroupMember(GroupId = grp.Id, UserOrGroupId = user.Id));
            }
            insert gms;
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'AtlasSuperUser'];
            insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id);
        }
    }
}