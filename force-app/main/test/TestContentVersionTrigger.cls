@isTest
public with sharing class TestContentVersionTrigger {
    @isTest
    static void insert_setsLastDate() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow'
        );
        insert joe;
        System.debug(joe.Id);

        ContentVersion cv = TestFileService.createLink('Client', 'Application', Date.today(), joe.Id);
        // change the date
        cv.Date__c = Date.today().addDays(1);
        System.debug(cv);

        // Act
        Test.startTest();
        Database.SaveResult result = Database.update(cv, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        Contact saved = [SELECT ClientApplicationReceived__c FROM Contact WHERE id=:joe.Id LIMIT 1];
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(cv.Date__c, saved.ClientApplicationReceived__c);
    }
}
