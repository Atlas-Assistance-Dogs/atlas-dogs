@isTest
public with sharing class TestUtilities {

    // Create a test user
    public static User createUser(string profileName) {
        // Create a unique UserName
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        User adminUser = new User(
            Alias = 'standt', Email='adminuser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUserName);
        insert adminUser;
        return adminUser;
    }

    public static void addUserToPermissionSet(Id userId, string setName) {

        // Avoid mixed DML using runAs
        System.runAs(new User(Id = UserInfo.getUserId())) {
            PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Name = :setName LIMIT 1];
            insert new PermissionSetAssignment(PermissionSetId = permSet.Id, AssigneeId = userId);
        }
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

    public static void insertCategoryRules() {
        List<CategoryRule__c> rules = new List<CategoryRule__c>();
        rules.add(new CategoryRule__c(Category__c = 'Dog', Object__c = 'Dog', Group__c = 'Team'));
        rules.add(new CategoryRule__c(Category__c = 'Client', Object__c = 'Team', Group__c = 'Team'));
        rules.add(new CategoryRule__c(Category__c = 'Dog', Object__c = 'Team', Group__c = 'Team'));
        rules.add(new CategoryRule__c(Category__c = 'Client', Object__c = 'Contact', Position__c = 'Client', Group__c = 'Team'));
        rules.add(new CategoryRule__c(Category__c = 'Volunteer', Object__c = 'Contact', Position__c = 'Volunteer', Group__c = 'Volunteer'));
        insert rules;
    }
}