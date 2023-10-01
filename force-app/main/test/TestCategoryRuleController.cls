@isTest
public with sharing class TestCategoryRuleController {
    private static Contact debbie;
    private static Contact ken;
    private static Dog__c ace;
    private static Team__c team;
    private static Group volunteerGroup;
    private static Group teamGroup;
    private static User adminUser;

    // Create a test user
    private static User createAdminUser() {
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

    public static void createCategoryRules() {
        List<CategoryRule__c> rules = new List<CategoryRule__c> {
            new CategoryRule__c(
                Category__c = 'Dog',
                Object__c = 'Dog',
                Group__c = 'Team'
            ),
            new CategoryRule__c(
                Category__c = 'Client',
                Object__c = 'Team',
                Group__c = 'Team'
            ),
            new CategoryRule__c(
                Category__c = 'Dog',
                Object__c = 'Team',
                Group__c = 'Team'
            ),
            new CategoryRule__c(
                Category__c = 'ADSiM',
                Object__c = 'Contact',
                Group__c = 'All'
            ),
            new CategoryRule__c(
                Category__c = 'Standalone',
                Object__c = 'Contact',
                Group__c = 'All'
            ),
            new CategoryRule__c(
                Category__c = 'Board',
                Object__c = 'Contact',
                Position__c = 'Board Member',
                Group__c = 'All'
            ),
            new CategoryRule__c(
                Category__c = 'Client',
                Object__c = 'Contact',
                Position__c = 'Client',
                Group__c = 'Team'
            ),
            new CategoryRule__c(
                Category__c = 'Facilitator',
                Object__c = 'Contact',
                Position__c = 'Team Facilitator',
                Group__c = 'Team'
            ),
            new CategoryRule__c(
                Category__c = 'Facilitator',
                Object__c = 'Contact',
                Position__c = 'Team Facilitator Lead',
                Group__c = 'Team'
            ),
            new CategoryRule__c(
                Category__c = 'Puppy',
                Object__c = 'Contact',
                Position__c = 'Puppy Raiser',
                Group__c = 'All'
            ),
            new CategoryRule__c(
                Category__c = 'Staff',
                Object__c = 'Contact',
                Position__c = 'Staff',
                Group__c = 'All'
            ),
            new CategoryRule__c(
                Category__c = 'Trainer',
                Object__c = 'Contact',
                Position__c = 'Trainer',
                Group__c = 'All'
            ),
            new CategoryRule__c(
                Category__c = 'Volunteer',
                Object__c = 'Contact',
                Position__c = 'Volunteer',
                Group__c = 'Volunteer'
            )
        };
        insert rules;
    }

    private static void setup() {
        volunteerGroup = [SELECT Id, Name FROM Group WHERE Name='Volunteer' LIMIT 1];
        teamGroup = [SELECT Id, Name FROM Group WHERE Name='Team' LIMIT 1];

        adminUser = createAdminUser();
        insert adminUser;

        // Avoid mixed DML using runAs
        System.runAs(new User(Id = UserInfo.getUserId())) {
            List<GroupMember> gms = new List<GroupMember>();
            gms.add(new GroupMember(GroupId = volunteerGroup.Id, UserOrGroupId = adminUser.Id));
            gms.add(new GroupMember(GroupId = teamGroup.Id, UserOrGroupId = adminUser.Id));
            insert gms;
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'AtlasSuperUser'];
            insert new PermissionSetAssignment(AssigneeId = adminUser.id, PermissionSetId = ps.Id);
        }

        List<Contact> contacts = new List<Contact>();
        debbie = new Contact(FirstName = 'Debbie', LastName = 'Queen', Positions__c = 'Volunteer;Client');
        ken = new Contact(FirstName = 'Ken', LastName = 'King', Positions__c = 'Client');
        contacts.add(debbie);
        contacts.add(ken);
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

        List<CategoryRule__c> rules = new List<CategoryRule__c>();
        rules.add(new CategoryRule__c(Category__c = 'Dog', Object__c = 'Dog', Group__c = 'Team'));
        rules.add(new CategoryRule__c(Category__c = 'Client', Object__c = 'Team', Group__c = 'Team'));
        rules.add(new CategoryRule__c(Category__c = 'Dog', Object__c = 'Team', Group__c = 'Team'));
        rules.add(new CategoryRule__c(Category__c = 'Client', Object__c = 'Contact', Position__c = 'Client', Group__c = 'Team'));
        rules.add(new CategoryRule__c(Category__c = 'Volunteer', Object__c = 'Contact', Position__c = 'Volunteer', Group__c = 'Volunteer'));
        insert rules;
    }

    @isTest
    public static void getCategoriesForObject_ReturnsDog_WhenDogObject() {
        setup();
        System.runAs(new User(Id = adminUser.Id)) {
            // Act
            List<Map<String,String>> categories = CategoryRuleController.getCategoriesForObject(ace.Id);
            // Assert
            System.assertEquals(1, categories.size());
            System.assertEquals('Dog', categories[0].get('label'));
        }
    }

    @isTest
    public static void getCategoriesForObject_ReturnsClientDog_WhenTeamObject() {
        setup();
        System.runAs(new User(Id = adminUser.Id)) {
            // Act
            List<map<String,String>> categories = CategoryRuleController.getCategoriesForObject(team.Id);
            // Assert
            System.assertEquals(2, categories.size());
            System.assertEquals('Team Client', categories[0].get('label'));
            System.assertEquals('Dog', categories[1].get('label'));
        }
    }

    @isTest
    public static void getCategoriesForObject_ReturnsClient_WhenClient() {
        setup();
        System.runAs(new User(Id = adminUser.Id)) {
            // Act
            List<map<String,String>> categories = CategoryRuleController.getCategoriesForObject(ken.Id);
            // Assert
            System.assertEquals(1, categories.size());
            System.assertEquals('Team Client', categories[0].get('label'));
            System.assertEquals('Client', categories[0].get('value'));
        }
    }

    @isTest
    public static void getCategoriesForObject_ReturnsClientVolunteer_WhenClientVolunteer() {
        setup();
        System.runAs(new User(Id = adminUser.Id)) {
            // Act
            List<map<String,String>> categories = CategoryRuleController.getCategoriesForObject(debbie.Id);
            // Assert
            System.assertEquals(2, categories.size());
            System.assertEquals('Team Client', categories[0].get('label'));
            System.assertEquals('Volunteer', categories[1].get('label'));
            System.assertEquals('Client', categories[0].get('value'));
            System.assertEquals('Volunteer', categories[1].get('value'));
        }
    }

    // Create a test user
    private static User createVolunteerUser() {
        // Create a unique UserName
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Atlas Minimum Access'];
        User volunteerUser = new User(
            Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUserName);
        return volunteerUser;
    }
    // Create a group and user for Volunteer access
    private static User setupGroupUser() {
        User volunteerUser = createVolunteerUser();
        insert volunteerUser;

        // Apex Manual sharing needs to be established before the ownership changes
        // https://developer.salesforce.com/forums/?id=906F00000008xZJIAY

        // Avoid mixed DML using runAs
        System.runAs(new User(Id = UserInfo.getUserId())) {
            GroupMember gm = new GroupMember(GroupId = volunteerGroup.Id, UserOrGroupId = volunteerUser.Id);
            insert gm;
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'VolunteerUser'];
            insert new PermissionSetAssignment(AssigneeId = volunteerUser.Id, PermissionSetId = ps.Id);
        }
        return volunteerUser;
    }

    @isTest
    public static void getCategoriesForObject_RestrictsClientCategory_WhenUserNotInAllGroup() {
        setup();
        User volunteerUser = setupGroupUser();

        System.runAs(new User(Id = volunteerUser.Id)) {
            List<map<String,String>> categories = CategoryRuleController.getCategoriesForObject(debbie.Id);
            // Assert
            System.assertEquals(1, categories.size());
            System.assertEquals('Volunteer', categories[0].get('label'));
            System.assertEquals('Volunteer', categories[0].get('value'));
        }
    }
}