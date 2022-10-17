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

        ContinuingEducationUnit__c ceu = new ContinuingEducationUnit__c(
            Authority__c = 'Atlas',
            DateCompleted__c = Date.today(),
            DateSubmitted__c = Date.today(),
            ProgramDate__c = Date.today(),
            ProgramHours__c = 2,
            ProgramTitle__c = 'Title',
            Quantity__c = 2,
            Role__c = 'Attendee',
            Status__c = 'Pending',
            Trainer__c = joe.Id
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(ceu, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        ContinuingEducationUnit__c saved = [SELECT Name FROM ContinuingEducationUnit__c WHERE Trainer__c=:joe.Id LIMIT 1];
        System.assert(result.getErrors().size() == 0);
        System.assertEquals('CEU-0001', saved.Name);
    }

    @isTest
    static void insert_setsNameWhenSecond() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow'
        );
        insert joe;

        ContinuingEducationUnit__c ceu = new ContinuingEducationUnit__c(
            Authority__c = 'Atlas',
            DateCompleted__c = Date.today(),
            DateSubmitted__c = Date.today(),
            ProgramDate__c = Date.today(),
            ProgramHours__c = 2,
            ProgramTitle__c = 'Title',
            Quantity__c = 2,
            Role__c = 'Attendee',
            Status__c = 'Pending',
            Trainer__c = joe.Id
        );
        insert ceu;

        ceu = new ContinuingEducationUnit__c(
            Authority__c = 'Atlas',
            DateCompleted__c = Date.today(),
            DateSubmitted__c = Date.today(),
            ProgramDate__c = Date.today(),
            ProgramHours__c = 2,
            ProgramTitle__c = 'Title',
            Quantity__c = 2,
            Role__c = 'Attendee',
            Status__c = 'Approved',
            Trainer__c = joe.Id
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(ceu, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        ContinuingEducationUnit__c saved = [SELECT Name FROM ContinuingEducationUnit__c WHERE Status__c='Approved' LIMIT 1];
        System.assert(result.getErrors().size() == 0);
        System.assertEquals('CEU-0002', saved.Name);
    }

    @isTest
    static void insert_setsName_WhenFirstDoesntMatchPattern() {
        Contact joe = new Contact(
            Email = 'joe-blow@pump.com',
            FirstName = 'Joe',
            LastName = 'Blow'
        );
        insert joe;

        ContinuingEducationUnit__c ceu = new ContinuingEducationUnit__c(
            Authority__c = 'Atlas',
            DateCompleted__c = Date.today(),
            DateSubmitted__c = Date.today(),
            Name = 'Black Sheep',
            ProgramDate__c = Date.today(),
            ProgramHours__c = 2,
            ProgramTitle__c = 'Title',
            Quantity__c = 2,
            Role__c = 'Attendee',
            Status__c = 'Pending',
            Trainer__c = joe.Id
        );
        insert ceu;

        ceu = new ContinuingEducationUnit__c(
            Authority__c = 'Atlas',
            DateCompleted__c = Date.today(),
            DateSubmitted__c = Date.today(),
            ProgramDate__c = Date.today(),
            ProgramHours__c = 2,
            ProgramTitle__c = 'Title',
            Quantity__c = 2,
            Role__c = 'Attendee',
            Status__c = 'Approved',
            Trainer__c = joe.Id
        );

        // Act
        Test.startTest();
        Database.SaveResult result = Database.insert(ceu, false);
        Test.stopTest();

        // Assert
        System.assert(result.isSuccess());
        ContinuingEducationUnit__c saved = [SELECT Name FROM ContinuingEducationUnit__c WHERE Status__c='Approved' LIMIT 1];
        System.assert(result.getErrors().size() == 0);
        System.assertEquals('CEU-0001', saved.Name);
    }
}
