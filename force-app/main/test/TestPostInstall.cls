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
        Test.testInstall(postinstall, new Version(1, 0), true);
        List<Dog__c> dogs = [SELECT id, VaccineDueDA2PP__c FROM Dog__c];
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
        Test.testInstall(postinstall, new Version(1, 2), true);

        // Assert
        dogs = [SELECT id, Name, VaccineDueDA2PP__c FROM Dog__c];
        for (Dog__c dog : dogs) {
            if (dog.Name == 'Skipper') {
                System.assertEquals(null, dog.VaccineDueDA2PP__c);
            } else {
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
        Test.testInstall(postinstall, new Version(1, 3), true);

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

    @isTest
    public static void installScript_CopiesSystemAccess() {
        // Arrange
        List<Contact> contacts = new List<Contact>();
        contacts.add(
            new Contact(
                FirstName = 'Myka',
                LastName = 'Berring',
                VolunteerAccess__c = 'Operations- Master Docs - READ ONLY'
            )
        );
        contacts.add(
            new Contact(
                FirstName = 'Pete',
                LastName = 'Latimer',
                VolunteerAccess__c = 'Operations- Financial'
            )
        );
        contacts.add(
            new Contact(
                FirstName = 'Claudia',
                LastName = 'Donovan',
                VolunteerAccess__c = 'Operations- Client'
            )
        );
        contacts.add(new Contact(FirstName = 'Abigail', LastName = 'Doctor'));
        insert contacts;
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        for (Contact contact : contacts) {
            contactMap.put(contact.Id, contact);
        }
        PostInstall postinstall = new PostInstall();

        // Act
        Test.testInstall(postinstall, new Version(1, 3), true);

        // Assert
        contacts = [
            SELECT Id, VolunteerAccess__c, SystemAccess__c
            FROM Contact
        ];
        for (Contact actual : contacts) {
            Contact expected = contactMap.get(actual.Id);
            System.assertEquals(
                expected.VolunteerAccess__c,
                actual.SystemAccess__c
            );
            System.assertEquals(null, actual.VolunteerAccess__c);
        }
    }

    private class Team {
        public Team__c team;
        public Contact client;
        public Dog__c dog;
        public Contact handler;
        public Contact facilitator;
    }
    private static Team createTeam() {
        Contact lydia = new Contact(
            FirstName = 'Lydia',
            LastName = 'Simpson',
            ClientCertificationValidUntil__c = Date.today().addDays(100)
        );
        Contact ethan = new Contact(FirstName = 'Ethan', LastName = 'Parish');
        Contact cassidy = new Contact(
            FirstName = 'Cassidy',
            LastName = 'Rogers'
        );
        List<Contact> contacts = new List<Contact>{ lydia, ethan, cassidy };
        insert contacts;
        Dog__c zeus = new Dog__c(Name = 'Zeus');
        insert zeus;
        Team__c team = new Team__c(
            Name = 'Lydia_Zeus',
            Client__c = lydia.Id,
            Handler__c = ethan.Id,
            Dog__c = zeus.Id,
            PatValidUntil__c = lydia.ClientCertificationValidUntil__c
        );
        insert team;

        Team info = new Team();
        info.team = team;
        info.client = lydia;
        info.dog = zeus;
        info.handler = ethan;
        info.facilitator = cassidy;
        return info;
    }

    private static List<ContentVersion> createClientDogDocs(Id clientId, Id dogId) {
        List<String> types = new List<String>{
            'Application',
            'ApplicationVideo',
            'CGCForm',
            'CertAgreement',
            'LOMI',
            'PreApplication',
            'ProgAgreement',
            'Survey',
            'VAPW'
        };
        List<ContentVersion> cvs = new List<ContentVersion>();
        for (String type : types) {
            cvs.add(
                new ContentVersion(
                    Title = 'Test Category Type',
                    PathOnClient = 'TestDocument3.jpg',
                    Origin = 'H',
                    VersionData = Blob.valueOf('Document Body 3'),
                    Category__c = 'Client',
                    Type__c = type,
                    Date__c = Date.today()
                )
            );
        }
        cvs.add(
            new ContentVersion(
                Title = 'Test Category Type',
                PathOnClient = 'TestDocument3.jpg',
                Origin = 'H',
                VersionData = Blob.valueOf('Document Body 3'),
                Category__c = 'TeamDog',
                Type__c = 'HealthForm',
                Date__c = Date.today()
            )
        );
        cvs.add(
            new ContentVersion(
                Title = 'Test Category Type',
                PathOnClient = 'TestDocument3.jpg',
                Origin = 'H',
                VersionData = Blob.valueOf('Document Body 3'),
                Category__c = 'TeamDog',
                Type__c = 'Xray',
                Date__c = Date.today()
            )
        );
        insert cvs;

        List<Id> cvIds = new List<Id>();
        for (ContentVersion cv: cvs) {
            cvIds.add(cv.Id);
        }

        // insert will fill in the Id, but not the ContentDecumentId
        cvs = [
            SELECT Id, ContentDocumentId, Category__c, Type__c, Date__c
            FROM ContentVersion
            WHERE Id IN :cvIds
        ];

        List<ContentDocumentLink> cdls = new List<ContentDocumentLink>();
        for (ContentVersion cv: cvs) {
            Id entityId = clientId;
            if (cv.Category__c == 'TeamDog') {
                entityId = dogId;
            }
            cdls.add(new ContentDocumentLink(
                ContentDocumentId = cv.ContentDocumentId,
                LinkedEntityId = entityId
            ));
        }
        insert cdls;

        return cvs;
    }

    @isTest
    public static void installScript_LinksAllFilesToTeam() {
        // Arrange
        Team teamInfo = createTeam();
        Contact lydia = teamInfo.client;
        List<ContentVersion> clientDocs = createClientDogDocs(lydia.Id, teamInfo.dog.Id);
        ContentVersion volunteerApp = TestFileService.createLink(
            'Volunteer',
            'Application',
            Date.today(),
            lydia.Id
        );

        // Act
        PostInstall postinstall = new PostInstall();
        Test.testInstall(postinstall, new Version(1, 3), true);

        // Assert
        Team__c team = [
            SELECT Id, Client__c, Dog__c,
                ClientApplicationReceived__c, ClientApplicationVideoReceived__c, ClientCGCFormReceived__c, ClientCertAgreementReceived__c, ClientLOMIReceived__c,
                ClientPreApplicationReceived__c, ClientProgAgreementReceived__c, ClientSurveyReceived__c, ClientVAPWReceived__c,
                HealthFormReceived__c, XrayReceived__c
            FROM Team__c
            WHERE Id = :teamInfo.team.Id
        ];
        System.assertEquals(Date.today(), team.ClientApplicationReceived__c);
        System.assertEquals(Date.today(), team.ClientApplicationVideoReceived__c);
        System.assertEquals(Date.today(), team.ClientCGCFormReceived__c);
        System.assertEquals(Date.today(), team.ClientCertAgreementReceived__c);
        System.assertEquals(Date.today(), team.ClientLOMIReceived__c);
        System.assertEquals(Date.today(), team.ClientPreApplicationReceived__c);
        System.assertEquals(Date.today(), team.ClientProgAgreementReceived__c);
        System.assertEquals(Date.today(), team.ClientSurveyReceived__c);
        System.assertEquals(Date.today(), team.ClientVAPWReceived__c);
        System.assertEquals(Date.today(), team.HealthFormReceived__c);
        System.assertEquals(Date.today(), team.XrayReceived__c);

        List<ContentDocumentLink> cdls = [
            SELECT Id, ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :team.Id
        ];
        System.assertNotEquals(0, cdls.size());

        cdls = [
            SELECT Id, ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE
                ContentDocumentId = :volunteerApp.ContentDocumentId
                AND LinkedEntityId = :team.Id
        ];
        System.assertEquals(0, cdls.size());
    }

    @isTest
    public static void installScript_LinksClientFilesToAllTeams() {
        // Arrange
        Team teamInfo = createTeam();
        Contact lydia = teamInfo.client;
        Team__c oldTeam = new Team__c(
            Name = teamInfo.team.Name,
            Client__c = lydia.Id,
            Dog__c = teamInfo.dog.Id
        );
        insert oldTeam;
        ContentVersion clientApp = TestFileService.createLink(
            'Client',
            'Application',
            Date.today(),
            lydia.Id
        );

        // Act
        PostInstall postinstall = new PostInstall();
        Test.testInstall(postinstall, new Version(1, 3), true);

        // Assert
        Team__c team = [
            SELECT Id, ClientApplicationReceived__c
            FROM Team__c
            WHERE Id = :teamInfo.team.Id
        ];
        System.assertEquals(
            clientApp.Date__c,
            team.ClientApplicationReceived__c
        );

        List<ContentDocumentLink> cdls = [
            SELECT Id, ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE
                ContentDocumentId = :clientApp.ContentDocumentId
                AND LinkedEntityId = :team.Id
        ];
        System.assertNotEquals(0, cdls.size());

        cdls = [
            SELECT Id, ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE
                ContentDocumentId = :clientApp.ContentDocumentId
                AND LinkedEntityId = :oldTeam.Id
        ];
        System.assertEquals(1, cdls.size());
    }

    @isTest
    public static void installScript_LinksDogFilesToTeam() {
        // Arrange
        Team myTeam = createTeam();
        Dog__c zeus = myTeam.dog;
        ContentVersion annual = TestFileService.createLink('Dog', 'VacExams', Date.today(), zeus.Id);
        ContentVersion initial = TestFileService.createLink('TeamDog', 'HealthForm', Date.today(), zeus.Id);
        
        // Act
        PostInstall postinstall = new PostInstall();
        Test.testInstall(postinstall, new Version(1, 3), true);

        // Assert
        Team__c team = [SELECT Id, HealthFormReceived__c FROM Team__c WHERE Name = 'Lydia_Zeus'];
        System.assertEquals(initial.Date__c, team.HealthFormReceived__c);

        List<ContentDocumentLink> cdls = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :initial.ContentDocumentId AND LinkedEntityId = :team.Id];
        System.assertNotEquals(0, cdls.size());

        cdls = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :annual.ContentDocumentId AND LinkedEntityId = :team.Id];
        System.assertEquals(0, cdls.size());
    }

    @isTest
    public static void installScript_SetsBackgroundCheckTypes() {
        // Arrange
        Contact lydia = new Contact(
            FirstName = 'Lydia',
            LastName = 'Simpson',
            ClientCertificationValidUntil__c = Date.today().addDays(100)
        );
        Contact ethan = new Contact(FirstName = 'Ethan', LastName = 'Parish');
        Contact cassidy = new Contact(
            FirstName = 'Cassidy',
            LastName = 'Rogers'
        );
        List<Contact> contacts = new List<Contact>{ lydia, ethan, cassidy };
        insert contacts;

        List<BackgroundCheck__c> checks = new List<BackgroundCheck__c>();
        checks.add(new BackgroundCheck__c(Contact__c = lydia.Id, Date__c = Date.today().addMonths(-3), Type__c = null));
        checks.add(new BackgroundCheck__c(Contact__c = ethan.Id, Date__c = Date.today().addMonths(-2), Type__c = null));
        checks.add(new BackgroundCheck__c(Contact__c = cassidy.Id, Date__c = Date.today().addMonths(-1), Type__c = null));
        checks.add(new BackgroundCheck__c(Contact__c = lydia.Id, Date__c = Date.today().addMonths(1), Type__c = null));
        insert checks;

        // Act
        PostInstall postinstall = new PostInstall();
        Test.testInstall(postinstall, new Version(1, 4), true);

        // Assert
        checks = [SELECT Id, Type__c FROM BackgroundCheck__c];
        for (BackgroundCheck__c check : checks) {
            System.assertEquals('Criminal', check.Type__c);
        }
    }
}
