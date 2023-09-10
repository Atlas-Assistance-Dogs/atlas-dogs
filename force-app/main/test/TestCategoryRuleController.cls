@isTest
public with sharing class TestCategoryRuleController {
    private static Contact debbie;
    private static Contact ken;
    private static Dog__c ace;
    private static Team__c team;

    private static void setup() {
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
        rules.add(new CategoryRule__c(Category__c = 'Dog', Object__c = 'Dog'));
        rules.add(new CategoryRule__c(Category__c = 'Client', Object__c = 'Team'));
        rules.add(new CategoryRule__c(Category__c = 'Dog', Object__c = 'Team'));
        rules.add(new CategoryRule__c(Category__c = 'Client', Object__c = 'Contact', Position__c = 'Client'));
        rules.add(new CategoryRule__c(Category__c = 'Volunteer', Object__c = 'Contact', Position__c = 'Volunteer'));
        insert rules;
    }

    @isTest
    public static void getCategoriesForObject_ReturnsDog_WhenDogObject() {
        setup();
        List<Map<String,String>> categories = CategoryRuleController.getCategoriesForObject(ace.Id);
        // Assert
        System.assertEquals(1, categories.size());
        System.assertEquals('Dog', categories[0].get('label'));
    }

    @isTest
    public static void getCategoriesForObject_ReturnsClientDog_WhenTeamObject() {
        setup();
        List<map<String,String>> categories = CategoryRuleController.getCategoriesForObject(team.Id);
        // Assert
        System.assertEquals(2, categories.size());
        System.assertEquals('Team Client', categories[0].get('label'));
        System.assertEquals('Dog', categories[1].get('label'));
    }
/*
    @isTest
    public static void getCategoriesForObject_ReturnsClient_WhenClient() {
        setup();
        List<map<String,String>> categories = CategoryRuleController.getCategoriesForObject(ken.Id);
        // Assert
        System.assertEquals(1, categories.size());
        System.assertEquals('Team Client', categories[0].get('label'));
        System.assertEquals('Client', categories[0].get('value'));
    }

    @isTest
    public static void getCategoriesForObject_ReturnsClientVolunteer_WhenClientVolunteer() {
        setup();
        List<map<String,String>> categories = CategoryRuleController.getCategoriesForObject(debbie.Id);
        // Assert
        System.assertEquals(2, categories.size());
        System.assertEquals('Team Client', categories[0].get('label'));
        System.assertEquals('Volunteer', categories[1].get('label'));
        System.assertEquals('Client', categories[0].get('value'));
        System.assertEquals('Volunteer', categories[1].get('value'));
    }

    // Create a test user
    private void createVolunteerUser() {
        // Create a unique UserName
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(
            Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUserName);

    }
    // Create a group and user for Volunteer access
    private void setupGroupUser() {
        User initialOpportunityOwner = \\ Calls method to get a test user instance
        insert initialOpportunityOwner;

        // Apex Manual sharing needs to be established before the ownership changes
        // https://developer.salesforce.com/forums/?id=906F00000008xZJIAY

        Group queryOpportunitiesGroup = new Group(Name='OppShareGroup', DeveloperName='OppShareGroup');
        insert queryOpportunitiesGroup;

        // Avoid mixed DML using runAs
        System.runAs(new User(Id = UserInfo.getUserId())) {
            GroupMember gm = new GroupMember(GroupId = queryOpportunitiesGroup.Id, UserOrGroupId = initialOpportunityOwner.Id);
            insert gm;
        }

    }
    @isTest
    public static void getCategoriesForObject_RestrictsClientCategory_WhenUserNotInAllGroup() {
        setup();
    }*/
}