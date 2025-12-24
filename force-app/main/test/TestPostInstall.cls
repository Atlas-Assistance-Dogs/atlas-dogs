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
    List<Dog__c> dogs = [SELECT id, 
                                VaccineDueDA2PP__c
                         FROM Dog__c];
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
    dogs.add(new Dog__c(
      Name = 'Skipper'
    ));
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
    dogs = [SELECT id, 
                   Name, 
                   VaccineDueDA2PP__c
            FROM Dog__c];
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
    Dog__c dog = new Dog__c(
      Name = 'Ace'
    );
    insert dog;
    Contact myka = new Contact(
      FirstName = 'Julie', 
      LastName = 'Monroe'
    );
    insert myka;
    Contact pete = new Contact(
      FirstName = 'Pete', 
      LastName = 'Latimer'
    );
    insert pete;
    Team__c peteTeam = new Team__c(
      Client__c = pete.Id, 
      Dog__c = dog.Id, 
      Name = 'PeteLatimer_Ace'
    );
    insert peteTeam;
    Team__c mykaTeam = new Team__c(
      Client__c = myka.Id, 
      Dog__c = dog.Id, 
      Name = 'MykaBerring_Ace'
    );
    insert mykaTeam;
    Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Log__c.getRecordTypeInfosByName();
    Id CLIENT_ID = recordTypes.get('Client').getRecordTypeId();
    Id FACILITATOR_ID = recordTypes.get('Team Facilitator').getRecordTypeId();
    List<Log__c> logs = new List<Log__c>();
    logs.add(new Log__c(
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
    ));
    logs.add(new Log__c(
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
    ));
    insert logs;
    PostInstall postinstall = new PostInstall();

    // Act
    Test.testInstall(postinstall, new Version(1, 3), true);

    // Assert
    logs = [SELECT Id, 
                   Team__c
            FROM Log__c
            WHERE Client__c = :myka.Id];
    for (Log__c log : logs) {
      System.assertEquals(mykaTeam.Id, log.Team__c);
    }
    logs = [SELECT Id, 
                   Team__c
            FROM Log__c
            WHERE Client__c = :pete.Id];
    for (Log__c log : logs) {
      System.assertEquals(peteTeam.Id, log.Team__c);
    }
  }

  @isTest
  public static void installScript_CopiesSystemAccess() {
    // Arrange
    List<Contact> contacts = new List<Contact>();
    contacts.add(new Contact(
      FirstName = 'Myka', 
      LastName = 'Berring', 
      VolunteerAccess__c = 'Operations- Master Docs - READ ONLY'
    ));
    contacts.add(new Contact(
      FirstName = 'Pete', 
      LastName = 'Latimer', 
      VolunteerAccess__c = 'Operations- Financial'
    ));
    contacts.add(new Contact(
      FirstName = 'Claudia', 
      LastName = 'Donovan', 
      VolunteerAccess__c = 'Operations- Client'
    ));
    contacts.add(new Contact(
      FirstName = 'Abigail', 
      LastName = 'Doctor'
    ));
    insert contacts;
    Map<Id, Contact> contactMap = new Map<Id, Contact>();
    for (Contact contact : contacts) {
      contactMap.put(contact.Id, contact);
    }
    PostInstall postinstall = new PostInstall();

    // Act
    Test.testInstall(postinstall, new Version(1, 3), true);
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
    Contact ethan = new Contact(
      FirstName = 'Ethan', 
      LastName = 'Parish'
    );
    Contact cassidy = new Contact(
      FirstName = 'Cassidy', 
      LastName = 'Rogers'
    );
    List<Contact> contacts = new List<Contact>{ lydia, ethan, cassidy };
    insert contacts;
    Dog__c zeus = new Dog__c(
      Name = 'Zeus'
    );
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
    List<String> types = new List<String>{ 'Application', 'ApplicationVideo', 'CGCForm', 'CertAgreement', 'LOMI', 'PreApplication', 'ProgAgreement', 'Survey', 'VAPW' };
    List<ContentVersion> cvs = new List<ContentVersion>();
    for (String type : types) {
      cvs.add(new ContentVersion(
        Title = 'Test Category Type', 
        PathOnClient = 'TestDocument3.jpg', 
        Origin = 'H', 
        VersionData = Blob.valueOf('Document Body 3'), 
        Category__c = 'Client', 
        Type__c = type, 
        Date__c = Date.today()
      ));
    }
    cvs.add(new ContentVersion(
      Title = 'Test Category Type', 
      PathOnClient = 'TestDocument3.jpg', 
      Origin = 'H', 
      VersionData = Blob.valueOf('Document Body 3'), 
      Category__c = 'TeamDog', 
      Type__c = 'HealthForm', 
      Date__c = Date.today()
    ));
    cvs.add(new ContentVersion(
      Title = 'Test Category Type', 
      PathOnClient = 'TestDocument3.jpg', 
      Origin = 'H', 
      VersionData = Blob.valueOf('Document Body 3'), 
      Category__c = 'TeamDog', 
      Type__c = 'Xray', 
      Date__c = Date.today()
    ));
    insert cvs;

    List<Id> cvIds = new List<Id>();
    for (ContentVersion cv : cvs) {
      cvIds.add(cv.Id);
    }

    // insert will fill in the Id, but not the ContentDecumentId
    cvs = [SELECT Id, 
                  ContentDocumentId, 
                  Category__c, 
                  Type__c, 
                  Date__c
           FROM ContentVersion
           WHERE Id IN:cvIds];

    List<ContentDocumentLink> cdls = new List<ContentDocumentLink>();
    for (ContentVersion cv : cvs) {
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
    Team__c team = [SELECT Id, 
                           HealthFormReceived__c
                    FROM Team__c
                    WHERE Name = 'Lydia_Zeus'];
    System.assertEquals(initial.Date__c, team.HealthFormReceived__c);

    List<ContentDocumentLink> cdls = [SELECT Id, 
                                             ContentDocumentId, 
                                             LinkedEntityId
                                      FROM ContentDocumentLink
                                      WHERE ContentDocumentId = :initial.ContentDocumentId AND LinkedEntityId = :team.Id];
    System.assertNotEquals(0, cdls.size());

    cdls = [SELECT Id, 
                   ContentDocumentId, 
                   LinkedEntityId
            FROM ContentDocumentLink
            WHERE ContentDocumentId = :annual.ContentDocumentId AND LinkedEntityId = :team.Id];
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
    Contact ethan = new Contact(
      FirstName = 'Ethan', 
      LastName = 'Parish'
    );
    Contact cassidy = new Contact(
      FirstName = 'Cassidy', 
      LastName = 'Rogers'
    );
    List<Contact> contacts = new List<Contact>{ lydia, ethan, cassidy };
    insert contacts;

    List<BackgroundCheck__c> checks = new List<BackgroundCheck__c>();
    checks.add(new BackgroundCheck__c(
      Contact__c = lydia.Id, 
      Date__c = Date.today().addMonths(-3), 
      Type__c = null
    ));
    checks.add(new BackgroundCheck__c(
      Contact__c = ethan.Id, 
      Date__c = Date.today().addMonths(-2), 
      Type__c = null
    ));
    checks.add(new BackgroundCheck__c(
      Contact__c = cassidy.Id, 
      Date__c = Date.today().addMonths(-1), 
      Type__c = null
    ));
    checks.add(new BackgroundCheck__c(
      Contact__c = lydia.Id, 
      Date__c = Date.today().addMonths(1), 
      Type__c = null
    ));
    insert checks;

    // Act
    PostInstall postinstall = new PostInstall();
    Test.testInstall(postinstall, new Version(1, 4), true);

    // Assert
    checks = [SELECT Id, 
                     Type__c
              FROM BackgroundCheck__c];
    for (BackgroundCheck__c check : checks) {
      System.assertEquals('Criminal', check.Type__c);
    }
  }

  @isTest
  public static void installScript_changesPositionToTSiM() {
    // Arrange
    Contact lydia = new Contact(
      FirstName = 'Lydia', 
      LastName = 'Simpson', 
      Positions__c = 'Standalone', 
      StandaloneStatus__c = 'In Training', 
      StandaloneApplicationReceived__c = Date.today().addMonths(-3), 
      StandaloneProgAgreementReceived__c = Date.today().addMonths(-1)
    );
    Contact ethan = new Contact(
      FirstName = 'Ethan', 
      LastName = 'Parish', 
      Positions__c = 'Standalone;Volunteer', 
      StandaloneStatus__c = 'Completed', 
      StandaloneApplicationReceived__c = Date.today().addMonths(-13), 
      StandaloneProgAgreementReceived__c = Date.today().addMonths(-11)
    );
    Contact cassidy = new Contact(
      FirstName = 'Cassidy', 
      LastName = 'Rogers', 
      Positions__c = 'Standalone;Board Member', 
      StandaloneStatus__c = 'Inactive', 
      StandaloneApplicationReceived__c = Date.today().addDays(-3), 
      StandaloneProgAgreementReceived__c = Date.today().addDays(-1)
    );
    List<Contact> contacts = new List<Contact>{ lydia, ethan, cassidy };
    insert contacts;

    Program__c stuff = new Program__c(
      Name = 'Stuff', 
      Standalone__c = true
    );
    Program__c tsim = new Program__c(
      Name = 'Teams Set in Motion Client', 
      Standalone__c = true
    );
    Program__c other = new Program__c(
      Name = 'Other'
    );
    Program__c[] programs = new Program__c[]{ stuff, tsim, other };
    insert programs;

    ProgramAssignment__c[] assignments = new ProgramAssignment__c[]{ new ProgramAssignment__c(
      Contact__c = lydia.Id, 
      Program__c = tsim.Id
    ), new ProgramAssignment__c(
      Contact__c = ethan.Id, 
      Program__c = tsim.Id
    ), new ProgramAssignment__c(
      Contact__c = cassidy.Id, 
      Program__c = stuff.Id
    ), new ProgramAssignment__c(
      Contact__c = ethan.Id, 
      Program__c = other.Id
    ) };
    insert assignments;

    // add documents
    ContentVersion[] cvs = TestFileController.insertRecords();
    Boolean application = true;
    for (Integer idx = 0; idx < cvs.size(); idx++) {
      ContentVersion cv = cvs[idx];
      if (idx < 6) {
        cv.Category__c = 'Standalone';
      } else {
        cv.Category__c = 'ADSiM';
      }
      if (application) {
        cv.Type__c = 'Application';
      } else {
        cv.Type__c = 'ProgAgreement';
      }
      application = !application;
    }
    update cvs;

    // relate the files
    FileController.relateFile(cvs[0].ContentDocumentId, lydia.Id, Date.today());
    FileController.relateFile(cvs[1].ContentDocumentId, lydia.Id, Date.today());
    FileController.relateFile(cvs[2].ContentDocumentId, ethan.Id, Date.today());
    FileController.relateFile(cvs[3].ContentDocumentId, ethan.Id, Date.today());
    for (Integer i = 4; i < cvs.size(); i++) {
      FileController.relateFile(cvs[i].ContentDocumentId, cassidy.Id, Date.today());
    }

    // Act
    PostInstall postinstall = new PostInstall();
    Test.testInstall(postinstall, new Version(1, 14), true);

    // Assert
    assertTsimContact(lydia);
    assertTsimContact(ethan);
    assertNotTsimContact(cassidy);
    assertFilesUpdated(cvs);
  }

  static void assertTsimContact(Contact c) {
    Contact actual = [SELECT Positions__c, 
                             StandaloneApplicationReceived__c, 
                             StandaloneProgAgreementReceived__c, 
                             StandaloneStatus__c, 
                             TSiMStatus__c, 
                             TSMApplicationReceived__c, 
                             TSMProgAgreementReceived__c
                      FROM Contact
                      WHERE Id = :c.Id];
    System.Assert.isNull(actual.StandaloneStatus__c, 'Standalone status should be null');
    System.Assert.isNull(actual.StandaloneApplicationReceived__c, 'StandaloneApplicationReceived should be null');
    System.Assert.isNull(actual.StandaloneProgAgreementReceived__c, 'StandaloneProgAgreementReceived should be null');
    System.Assert.areEqual(c.StandaloneStatus__c, actual.TSiMStatus__c, 'TSiM status should match Standalone');
    // Don't check these because changing the file types updates the dates
    // System.Assert.areEqual(c.StandaloneApplicationReceived__c, actual.TSMApplicationReceived__c, 'TSiM application should match Standalone');
    // System.Assert.areEqual(c.StandaloneProgAgreementReceived__c, actual.TSMProgAgreementReceived__c, 'TSiM prog aggreement should match Standalone');
  }

  static void assertNotTsimContact(Contact c) {
    Contact actual = [SELECT Positions__c, 
                             StandaloneApplicationReceived__c, 
                             StandaloneProgAgreementReceived__c, 
                             StandaloneStatus__c, 
                             TSiMStatus__c, 
                             TSMApplicationReceived__c, 
                             TSMProgAgreementReceived__c
                      FROM Contact
                      WHERE Id = :c.Id];
    System.Assert.isNull(actual.TSiMStatus__c, 'TSiM status should be null');
    System.Assert.isNull(actual.TSMApplicationReceived__c, 'TSiMApplicationReceived should be null');
    System.Assert.isNull(actual.TSMProgAgreementReceived__c, 'TSiMProgAgreementReceived should be null');
    System.Assert.areEqual(c.StandaloneStatus__c, actual.StandaloneStatus__c, 'Standalone status should not change');
    System.Assert.areEqual(c.StandaloneApplicationReceived__c, actual.StandaloneApplicationReceived__c, 'TSiM application should not change');
    System.Assert.areEqual(c.StandaloneProgAgreementReceived__c, actual.StandaloneProgAgreementReceived__c, 'TSiM prog aggreement should not change');
  }

  static void assertFilesUpdated(ContentVersion[] cvs) {
    Set<Id> tsimIds = new Set<Id>();
    Set<Id> standaloneIds = new Set<Id>();
    Set<Id> allIds = new Set<Id>();
    for (Integer i = 0; i < cvs.size(); i++) {
      Id cvId = cvs[i].Id;
      if (i < 4) {
        tsimIds.add(cvId);
      } else if (i < 6) {
        standaloneIds.add(cvId);
      }
      allIds.add(cvId);
    }
    for (ContentVersion cv : [SELECT Category__c FROM ContentVersion WHERE Id IN :allIds]) {
      if (tsimIds.contains(cv.Id)) {
        System.Assert.areEqual('TSM', cv.Category__c, 'should be TSiM');
      } else if (standaloneIds.contains(cv.Id)) {
        System.Assert.areEqual('Standalone', cv.Category__c, 'should be standalone');
      } else {
        System.Assert.areEqual('ADSiM', cv.Category__c, 'should be ADSiM');
      }
    }
  }
}