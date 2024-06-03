@isTest
public with sharing class TestUtilities {
    // Create a test user
    public static User createUser(string profileName) {
        // Create a unique UserName
        String uniqueUserName =
            'standarduser' +
            DateTime.now().getTime() +
            '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        User adminUser = new User(
            Alias = 'standt',
            Email = 'adminuser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = uniqueUserName
        );
        insert adminUser;
        return adminUser;
    }

    public static void addUserToPermissionSet(Id userId, string setName) {
        // Avoid mixed DML using runAs
        System.runAs(new User(Id = UserInfo.getUserId())) {
            PermissionSet permSet = [
                SELECT Id
                FROM PermissionSet
                WHERE Name = :setName
                LIMIT 1
            ];
            insert new PermissionSetAssignment(
                PermissionSetId = permSet.Id,
                AssigneeId = userId
            );
        }
    }

    public static void addUserToGroups(User user, string[] groupNames) {
        List<Group> groups = [
            SELECT Id, Name
            FROM Group
            WHERE Name IN :groupNames
        ];

        // Avoid mixed DML using runAs
        System.runAs(new User(Id = UserInfo.getUserId())) {
            List<GroupMember> gms = new List<GroupMember>();
            for (Group grp : groups) {
                gms.add(
                    new GroupMember(GroupId = grp.Id, UserOrGroupId = user.Id)
                );
            }
            insert gms;
            PermissionSet ps = [
                SELECT Id
                FROM PermissionSet
                WHERE Name = 'AtlasSuperUser'
            ];
            insert new PermissionSetAssignment(
                AssigneeId = user.id,
                PermissionSetId = ps.Id
            );
        }
    }

    public static void insertCategoryRules() {
        List<CategoryRule__c> rules = new List<CategoryRule__c>();
        rules.add(
            new CategoryRule__c(
                Category__c = 'Dog',
                Object__c = 'Dog',
                GroupName__c = 'Team'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'Client',
                Object__c = 'Team',
                GroupName__c = 'Team'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'TeamDog',
                Object__c = 'Team',
                GroupName__c = 'Team'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'ADSiM',
                Object__c = 'Contact',
                GroupName__c = 'Team'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'Standalone',
                Object__c = 'Contact',
                Position__c = 'Standalone',
                GroupName__c = 'Standalone'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'Board',
                Object__c = 'Contact',
                Position__c = 'Board Member',
                GroupName__c = 'Board'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'Facilitator',
                Object__c = 'Contact',
                Position__c = 'Team Facilitator',
                GroupName__c = 'Team'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'Facilitator',
                Object__c = 'Contact',
                Position__c = 'Team Facilitator Lead',
                GroupName__c = 'Team'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'Puppy',
                Object__c = 'Contact',
                Position__c = 'Puppy Raiser',
                GroupName__c = 'All'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'Staff',
                Object__c = 'Contact',
                Position__c = 'Staff',
                GroupName__c = 'Staff'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'Trainer',
                Object__c = 'Contact',
                Position__c = 'Trainer',
                GroupName__c = 'Trainer'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'Volunteer',
                Object__c = 'Contact',
                Position__c = 'Volunteer',
                GroupName__c = 'Volunteer'
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'na',
                Object__c = 'Contact'
            )
        );
        // ReadOnly versions for Dog and Contact
        rules.add(
            new CategoryRule__c(
                Category__c = 'TeamDog',
                Object__c = 'Dog',
                GroupName__c = 'Team',
                ReadOnly__c = true
            )
        );
        rules.add(
            new CategoryRule__c(
                Category__c = 'Client',
                Object__c = 'Contact',
                Position__c = 'Client',
                GroupName__c = 'Team',
                ReadOnly__c = true
            )
        );
        insert rules;
    }

    public static void insertRelationShipLookup() {
        List<npe4__Relationship_Lookup__c> lookups = new List<npe4__Relationship_Lookup__c>{
            new npe4__Relationship_Lookup__c(
                Name = 'Primary Emergency Contact',
                npe4__Male__c = 'Contact',
                npe4__Female__c = 'Contact',
                npe4__Neutral__c = 'Contact'
            ),
            new npe4__Relationship_Lookup__c(
                Name = 'Secondary Emergency Contact',
                npe4__Male__c = 'Contact',
                npe4__Female__c = 'Contact',
                npe4__Neutral__c = 'Contact'
            ),
            new npe4__Relationship_Lookup__c(
                Name = 'Guardian',
                npe4__Male__c = 'Ward',
                npe4__Female__c = 'Ward',
                npe4__Neutral__c = 'Ward'
            )
        };
        insert lookups;
    }
}
