@isTest
public with sharing class TestContinuingEducationUnitTrigger {
    @isTest
    static void insert_setsNameWhenFirst() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow'
        );
        insert joe;

        CEU__c ceu = new CEU__c(
            Authority__c = 'Atlas',
            DateCompleted__c = Date.today(),
            DateSubmitted__c = Date.today(),
            ProgramDate__c = Date.today(),
            ProgramHours__c = 2,
            ProgramTitle__c = 'Title',
            Quantity__c = 2,
            Role__c = 'Attendee',
            Status__c = 'Pending',
            Contact__c = joe.Id
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(ceu, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        CEU__c saved = [SELECT Name FROM CEU__c WHERE Contact__c=:joe.Id LIMIT 1];
        System.assert(result.getErrors().size() == 0);
        System.assertEquals('CEU-0001', saved.Name);
    }
}
