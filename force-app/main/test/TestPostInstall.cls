@isTest
public with sharing class TestPostInstall {
    @isTest
    public static void installScript_HandlesNullContext() {
        PostInstall postinstall = new PostInstall();
        Test.testInstall(postinstall, null);
    }

    @isTest
    public static void installScript_HandlesOriginalVersion() {
        PostInstall postinstall = new PostInstall();
        Test.testInstall(postinstall, new Version(1,0), true);
        List<Dog__c> dogs = [Select id, VaccineDueDA2PP__c from Dog__c];
        for (Dog__c dog : dogs) {
            System.assertNotEquals(null, dog.VaccineDueDA2PP__c);
        }
    }

    @isTest
    public static void installScript_Handles1_2Version() {
        PostInstall postinstall = new PostInstall();
        Date today = Date.today();
        Date latest = today.addDays(50);
        List<Dog__c> dogs = new List<Dog__c>();
        dogs.add(new Dog__c(
            Name = 'Patty',
            VaccineDueDistemper__c = latest.addDays(-10),
            VaccineDueHepatitis__c = latest,
            VaccineDueParainfluenza__c = today,
            VaccineDueParvovirus__c = latest
        ));
        dogs.add(new Dog__c(Name = 'Skipper'));
        dogs.add(new Dog__c(
            Name = 'Ace',
            VaccineDueDistemper__c = null,
            VaccineDueHepatitis__c = latest,
            VaccineDueParainfluenza__c = null,
            VaccineDueParvovirus__c = latest.addDays(-50)
        ));
        dogs.add(new Dog__c(
            Name = 'Hunter',
            VaccineDueDistemper__c = null,
            VaccineDueHepatitis__c = null,
            VaccineDueParainfluenza__c = null,
            VaccineDueParvovirus__c = latest
        ));
        dogs.add(new Dog__c(
            Name = 'Theo',
            VaccineDueDistemper__c = latest,
            VaccineDueHepatitis__c = today,
            VaccineDueParainfluenza__c = latest.addDays(-20),
            VaccineDueParvovirus__c = latest.addDays(-1)
        ));
        insert dogs;

        // Act
        Test.testInstall(postinstall, new Version(1,2), true);
        
        // Assert
        dogs = [Select id, Name, VaccineDueDA2PP__c from Dog__c];
        for (Dog__c dog : dogs) {
            if (dog.Name == 'Skipper') {
                System.assertEquals(null, dog.VaccineDueDA2PP__c);
            }
            else {
                System.assertEquals(latest, dog.VaccineDueDA2PP__c);
            }
        }
    }
}
