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

    @isTest
    public static void installScript_SetsTeamInLogs() {
        Dog__c dog = new Dog__c(Name = 'Ace');
        insert dog;
        Contact myka = new Contact(FirstName = 'Julie', LastName = 'Monroe');
        insert myka;
        Contact pete = new Contact(FirstName = 'Pete', LastName = 'Latimer');
        insert pete;
        Team__c peteTeam = new Team__c(Client__c = pete.Id, Dog__c = dog.Id, Name = 'PeteLatimer_Ace');
        insert peteTeam;
        Team__c mykaTeam = new Team__c(Client__c = myka.Id, Dog__c = dog.Id, Name = 'MykaBerring_Ace');
        insert mykaTeam;
        Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Log__c.getRecordTypeInfosByName();
        Id CLIENT_ID = recordTypes.get('Client').getRecordTypeId();
        Id FACILITATOR_ID = recordTypes.get('Team Facilitator').getRecordTypeId();
        List<Log__c> logs = new List<Log__c>();
        logs.add(
            new Log__c(
                Client__c = myka.Id,
                ClientHours__c = 22,
                ClientStress__c = 'Only a little',
                Date__c = Date.today(),
                Details__c = 'My details',
                Dog__c = dog.Id,
                Handler__c = 'Ken',
                OtherHours__c = 5,
                PublicAccessHours__c = 10,
                RequestSupportFromAtlas__c = false,
                RequestSupportFromTeam__c = true,
                Satisfaction__c = 'No enjoyment',
                SessionType__c = 'In Person',
                Stress__c = 'Not at all',
                Submitter__c = myka.Id,
                SupportDetails__c = 'Support details',
                Facilitator__c = pete.Id,
                RecordTypeId = CLIENT_ID,
                Team__c = peteTeam.Id
            )
        );
        logs.add(
            new Log__c(
                Client__c = pete.Id,
                ClientHours__c = 22,
                ClientStress__c = 'Only a little',
                Date__c = Date.today(),
                Details__c = 'My details',
                Dog__c = dog.Id,
                Handler__c = 'Ken',
                OtherHours__c = 5,
                PublicAccessHours__c = 10,
                RequestSupportFromAtlas__c = false,
                RequestSupportFromTeam__c = true,
                Satisfaction__c = 'No enjoyment',
                SessionType__c = 'In Person',
                Stress__c = 'Not at all',
                Submitter__c = pete.Id,
                SupportDetails__c = 'Support details',
                Facilitator__c = myka.Id,
                RecordTypeId = FACILITATOR_ID,
                Team__c = mykaTeam.Id
            )
        );
        insert logs;
        PostInstall postinstall = new PostInstall();

        // Act
        Test.testInstall(postinstall, new Version(1,3), true);
        
        // Assert
        logs = [SELECT Id, Team__c FROM Log__c WHERE Client__c = :myka.Id];
        for (Log__c log : logs) {
            System.assertEquals(mykaTeam.Id, log.Team__c);
        }
        logs = [SELECT Id, Team__c FROM Log__c WHERE Client__c = :pete.Id];
        for (Log__c log : logs) {
            System.assertEquals(peteTeam.Id, log.Team__c);
        }
    }
}
