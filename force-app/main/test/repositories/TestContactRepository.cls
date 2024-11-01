/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestContactRepository {

    @isTest
    static void getActiveFacilitators_returnsEmptyList_whenNoContacts() {
        ContactRepository repo = new ContactRepository();
        Set<Id> facilitators = repo.getActiveFacilitators();

        System.assertEquals(new Set<Id>(), facilitators);
    }
    @isTest
    static void getActiveFacilitators_returnsEmptyList_whenNoFacilitators() {
        Contact client = new Contact(FirstName = 'Billy', LastName = 'Kid', Positions__c = 'Client');
        insert client;

        ContactRepository repo = new ContactRepository();
        Set<Id> facilitators = repo.getActiveFacilitators();

        System.assertEquals(new Set<Id>(), facilitators);
    }
    @isTest
    static void getActiveFacilitators_returnsEmptyList_whenFacilitatorNotActive() {
        Contact[] facs = new Contact[]{
            new Contact(FirstName = 'Jack', LastName = 'ONeil', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Inactive'),
            new Contact(FirstName = 'Sam', LastName = 'Carter', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Initial Inquiry'),
            new Contact(FirstName = 'Daniel', LastName = 'Jackson', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'In Training'),
            new Contact(FirstName = 'Tealc', LastName = 'Na', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'None'),
            new Contact(FirstName = 'Cameron', LastName = 'Mitchell', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Onboarding'),
            new Contact(FirstName = 'Janet', LastName = 'Carter', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Suspended'),
            new Contact(FirstName = 'Vala', LastName = 'Maldoran', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Discontinued')
        };
        insert facs;

        ContactRepository repo = new ContactRepository();
        Set<Id> facilitators = repo.getActiveFacilitators();

        System.assertEquals(new Set<Id>(), facilitators);
    }
    @isTest
    static void getActiveFacilitators_returnsOnlyActive_whenOtherNotActive() {
        Contact[] facs = new Contact[]{
            new Contact(FirstName = 'Jack', LastName = 'ONeil', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Inactive'),
            new Contact(FirstName = 'Sam', LastName = 'Carter', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Initial Inquiry'),
            new Contact(FirstName = 'Daniel', LastName = 'Jackson', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'In Training'),
            new Contact(FirstName = 'Tealc', LastName = 'Na', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Certified-Active'),
            new Contact(FirstName = 'Cameron', LastName = 'Mitchell', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Onboarding'),
            new Contact(FirstName = 'Janet', LastName = 'Carter', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Suspended'),
            new Contact(FirstName = 'Vala', LastName = 'Maldoran', Positions__c = 'Team Facilitator', FacilitatorStatus__c = 'Discontinued')
        };
        insert facs;

        ContactRepository repo = new ContactRepository();
        Set<Id> facilitators = repo.getActiveFacilitators();

        System.assertEquals(new Set<Id>{facs[3].id}, facilitators);
    }
   @isTest
    static void getActiveFacilitators_returnsAllActive_whenOtherPositions() {
        Contact[] facs = new Contact[]{
            new Contact(FirstName = 'Jack', LastName = 'ONeil', Positions__c = 'Team Facilitator;Volunteer', FacilitatorStatus__c = 'Inactive'),
            new Contact(FirstName = 'Sam', LastName = 'Carter', Positions__c = 'Team Facilitator;Client', FacilitatorStatus__c = 'Initial Inquiry'),
            new Contact(FirstName = 'Daniel', LastName = 'Jackson', Positions__c = 'Team Facilitator;Board Member', FacilitatorStatus__c = 'In Training'),
            new Contact(FirstName = 'Tealc', LastName = 'Na', Positions__c = 'Team Facilitator;Trainer', FacilitatorStatus__c = 'Certified-Active'),
            new Contact(FirstName = 'Cameron', LastName = 'Mitchell', Positions__c = 'Team Facilitator;Team Facilitator Lead', FacilitatorStatus__c = 'Onboarding'),
            new Contact(FirstName = 'Janet', LastName = 'Carter', Positions__c = 'Team Facilitator;Client;Board Member;Volunteer', FacilitatorStatus__c = 'Certified-Active'),
            new Contact(FirstName = 'Vala', LastName = 'Maldoran', Positions__c = 'Client', FacilitatorStatus__c = 'Discontinued')
        };
        insert facs;

        ContactRepository repo = new ContactRepository();
        Set<Id> facilitators = repo.getActiveFacilitators();

        System.assertEquals(new Set<Id>{facs[3].id, facs[5].id}, facilitators);
    }
}