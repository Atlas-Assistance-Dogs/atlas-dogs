@isTest
public with sharing class TestCategoryRuleController {
    private static Contact debbie;
    private static Contact ken;
    private static Contact alexa;
    private static Dog__c ace;
    private static Team__c team;
    private static Group volunteerGroup;
    private static Group teamGroup;
    private static Group boardGroup;
    private static Group allGroup;
    private static User allUser;
    private static User teamUser;

    // Create a test user
    private static User createAllUser() {
        // Create a unique UserName
        String uniqueUserName =
            'standarduser' +
            DateTime.now().getTime() +
            '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
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
        return adminUser;
    }

    // Create a test team user
    private static User createTeamUser() {
        // Create a unique UserName
        String uniqueUserName =
            'standarduser' +
            DateTime.now().getTime() +
            '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User adminUser = new User(
            Alias = 'teamuser',
            Email = 'teamuser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = uniqueUserName
        );
        return adminUser;
    }

    private static void setup() {
        volunteerGroup = [
            SELECT Id, Name
            FROM Group
            WHERE Name = 'Volunteer'
            LIMIT 1
        ];
        teamGroup = [SELECT Id, Name FROM Group WHERE Name = 'Team' LIMIT 1];
        boardGroup = [SELECT Id, Name FROM Group WHERE Name = 'Board' LIMIT 1];
        allGroup = [SELECT Id, Name FROM Group WHERE Name = 'All' LIMIT 1];

        allUser = createAllUser();
        insert allUser;

        teamUser = createTeamUser();
        insert teamUser;

        // Avoid mixed DML using runAs
        System.runAs(new User(Id = UserInfo.getUserId())) {
            List<GroupMember> gms = new List<GroupMember>();
            gms.add(
                new GroupMember(
                    GroupId = allGroup.Id,
                    UserOrGroupId = allUser.Id
                )
            );
            gms.add(
                new GroupMember(
                    GroupId = volunteerGroup.Id,
                    UserOrGroupId = allGroup.Id
                )
            );
            gms.add(
                new GroupMember(
                    GroupId = boardGroup.Id,
                    UserOrGroupId = allGroup.Id
                )
            );
            gms.add(
                new GroupMember(
                    GroupId = teamGroup.Id,
                    UserOrGroupId = allGroup.Id
                )
            );
            gms.add(
                new GroupMember(
                    GroupId = teamGroup.Id,
                    UserOrGroupId = teamUser.Id
                )
            );
            insert gms;
            List<PermissionSet> permissionSets = [
                SELECT Id, Name
                FROM PermissionSet
                WHERE Name LIKE 'Atlas%'
            ];
            List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
            for (PermissionSet ps : permissionSets) {
                if (!ps.Name.contains('Super')) {
                    assignments.add(
                        new PermissionSetAssignment(
                            AssigneeId = allUser.id,
                            PermissionSetId = ps.Id
                        )
                    );
                }
                if (ps.Name.contains('Team') || ps.Name.contains('Base')) {
                    assignments.add(
                        new PermissionSetAssignment(
                            AssigneeId = teamUser.id,
                            PermissionSetId = ps.Id
                        )
                    );
                }
            }
            insert assignments;
        }

        List<Contact> contacts = new List<Contact>();
        debbie = new Contact(
            FirstName = 'Debbie',
            LastName = 'Queen',
            Positions__c = 'Volunteer;Client'
        );
        ken = new Contact(
            FirstName = 'Ken',
            LastName = 'King',
            Positions__c = 'Client'
        );
        alexa = new Contact(
            FirstName = 'Alexa',
            LastName = 'Hurst',
            Positions__c = 'Board Member'
        );
        contacts.add(debbie);
        contacts.add(ken);
        contacts.add(alexa);
        insert contacts;

        ace = new Dog__c(Name = 'Ace');
        insert ace;

        team = new Team__c(
            Client__c = ken.Id,
            Dog__c = ace.Id,
            Handler__c = debbie.Id,
            Name = 'Camelot',
            PatValidUntil__c = Date.today().addMonths(12),
            PatCount__c = 21,
            PrimaryCertification__c = 'Allergen Alert',
            SecondaryCertification__c = 'Autism'
        );
        insert team;

        TestUtilities.insertCategoryRules();
    }

    @isTest
    public static void getCategoriesForObject_ReturnsDog_WhenDogObject() {
        setup();
        System.runAs(new User(Id = allUser.Id)) {
            // Act
            List<Map<String, String>> categories = CategoryRuleController.getCategoriesForObject(
                ace.Id
            );
            // Assert
            System.assertEquals(1, categories.size());
            System.assertEquals('Dog', categories[0].get('label'));
        }
    }

    @isTest
    public static void getCategoriesForObject_ReturnsClientDog_WhenTeamObject() {
        setup();
        System.runAs(new User(Id = teamUser.Id)) {
            // Act
            List<map<String, String>> categories = CategoryRuleController.getCategoriesForObject(
                team.Id
            );
            // Assert
            System.assertEquals(2, categories.size());
            System.assertEquals('Team Client', categories[0].get('label'));
            System.assertEquals('Dog', categories[1].get('label'));
        }
    }

    @isTest
    public static void getCategoriesForObject_ReturnsClient_WhenClient() {
        setup();
        ken.OwnerId = allUser.Id;
        update ken;
        System.runAs(new User(Id = allUser.Id)) {
            // Act
            List<map<String, String>> categories = CategoryRuleController.getCategoriesForObject(
                ken.Id
            );
            // Assert
            System.assertEquals(2, categories.size());
            System.assertEquals('ADSiM', categories[0].get('value'));
            System.assertEquals('Team Client', categories[1].get('label'));
            System.assertEquals('Client', categories[1].get('value'));
        }
    }

    @isTest
    public static void getCategoriesForObject_ReturnsBoard_WhenBoardMember() {
        setup();
        System.runAs(new User(Id = allUser.Id)) {
            // Act
            List<map<String, String>> categories = CategoryRuleController.getCategoriesForObject(
                alexa.Id
            );
            // Assert
            System.assertEquals(2, categories.size());
            System.assertEquals('Board', categories[1].get('label'));
            System.assertEquals('Board', categories[1].get('value'));
        }
    }

    @isTest
    public static void getCategoriesForObject_ReturnsClientVolunteer_WhenClientVolunteer() {
        setup();
        System.runAs(new User(Id = allUser.Id)) {
            // Act
            List<map<String, String>> categories = CategoryRuleController.getCategoriesForObject(
                debbie.Id
            );
            // Assert
            System.assertEquals(3, categories.size());
            System.assertEquals('Team Client', categories[1].get('label'));
            System.assertEquals('Volunteer', categories[2].get('label'));
            System.assertEquals('Client', categories[1].get('value'));
            System.assertEquals('Volunteer', categories[2].get('value'));
        }
    }

    // Create a test user
    private static User createVolunteerUser() {
        // Create a unique UserName
        String uniqueUserName =
            'standarduser' +
            DateTime.now().getTime() +
            '@testorg.com';
        // This code runs as the system user
        Profile p = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Minimum Access - Salesforce'
        ];
        User volunteerUser = new User(
            Alias = 'standt',
            Email = 'standarduser@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = uniqueUserName
        );
        return volunteerUser;
    }
}
