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
    static void getContactsNeedingBackgroundChecks_returnsEmpty_whenNoContacts() {
        ContactRepository repo = new ContactRepository();
        Contact[] result = repo.getContactsNeedingBackgroundChecks();
        System.assert(result.isEmpty());
    }
    @isTest
    static void getContactsNeedingBackgroundChecks_returnsEmpty_whenNoContactsWithVolunteerAccess() {
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com'
        );
        insert bluey;
        ContactRepository repo = new ContactRepository();
        Contact[] result = repo.getContactsNeedingBackgroundChecks();
        System.assert(result.isEmpty());
    }
    @isTest
    static void getContactsNeedingBackgroundChecks_returnsEmpty_whenNoContactsWithCheckRequired(){
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Active Projects- Academy'
        );
        insert bluey;
        ContactRepository repo = new ContactRepository();
        Contact[] result = repo.getContactsNeedingBackgroundChecks();
        System.assert(result.isEmpty());
    }
    @isTest
    static void getContactsNeedingBackgroundChecks_returnsEmpty_whenContactNeedsCriminal(){
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Background Check Required'
        );
        insert bluey;
        ContactRepository repo = new ContactRepository();
        Contact[] result = repo.getContactsNeedingBackgroundChecks();
        Contact puppy = result[0];
        System.assertEquals(bluey.Id, puppy.Id);
        System.assertEquals(bluey.VolunteerAccess__c, puppy.VolunteerAccess__c);
    }
    @isTest
    static void getContactsNeedingBackgroundChecks_returnsEmpty_whenContactNeedsCredit(){
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Credit Check Required'
        );
        insert bluey;
        ContactRepository repo = new ContactRepository();
        Contact[] result = repo.getContactsNeedingBackgroundChecks();
        Contact puppy = result[0];
        System.assertEquals(bluey.Id, puppy.Id);
        System.assertEquals(bluey.VolunteerAccess__c, puppy.VolunteerAccess__c);
    }
    @isTest
    static void getContactsNeedingBackgroundChecks_returnsEmpty_whenContactNeedsBoth(){
        Contact bluey = new Contact(
            FirstName = 'Bluey',
            LastName = 'Heeler',
            Email = 'bluey@test.com',
            VolunteerAccess__c = 'Background Check Required;Credit Check Required'
        );
        insert bluey;
        ContactRepository repo = new ContactRepository();
        Contact[] result = repo.getContactsNeedingBackgroundChecks();
        Contact puppy = result[0];
        System.assertEquals(bluey.Id, puppy.Id);
        System.assert(bluey.VolunteerAccess__c.contains('Background Check Required'));
        System.assert(bluey.VolunteerAccess__c.contains('Credit Check Required'));
    }
}