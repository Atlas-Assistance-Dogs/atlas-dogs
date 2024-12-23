global class PostInstall implements InstallHandler {
  global void onInstall(InstallContext context) {
    if (context == null) {
      return;
    }
    if (context.previousVersion() == null) {
      return;
    }
    if (context.previousVersion().compareTo(new Version(1, 4)) <= 0) {
      try {
        combineDogVaccineFields();
        linkTeamLogs();
        linkTeamDocuments();
      } catch (Exception e) {
        send(
          context.installerId(),
          'Installation Failure' + context.organizationId(),
          ' e: ' + e.getMessage() + ' stack trace ' + e.getStackTraceString()
        );
      }
    }
    if (context.previousVersion().compareTo(new Version(1, 5)) <= 0) {
      setBackgroundCheckTypes();
    }
  }

  private Date later(Date latest, Date vaccine) {
    if (latest == null) {
      return vaccine;
    }
    if (vaccine > latest) {
      return vaccine;
    }
    return latest;
  }

  public void combineDogVaccineFields() {
    // combine dog vaccine fields
    List<Dog__c> dogs = [
      SELECT
        Name,
        VaccineDueDA2PP__c,
        VaccineDueDistemper__c,
        VaccineDueHepatitis__c,
        VaccineDueParainfluenza__c,
        VaccineDueParvovirus__c
      FROM Dog__c
    ];
    for (Dog__c dog : dogs) {
      Date latest = later(
        dog.VaccineDueDistemper__c,
        dog.VaccineDueHepatitis__c
      );
      latest = later(latest, dog.VaccineDueParainfluenza__c);
      latest = later(latest, dog.VaccineDueParvovirus__c);
      dog.VaccineDueDA2PP__c = latest;
    }
    update dogs;
  }

  // For each Team, tie the Client and Dog documents to it
  global static void linkTeamDocuments() {
    AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
    settings.LinkFilesToTeamMembers__c = false;
    upsert settings;

    List<Team__c> teams = [SELECT Id, Client__c, Dog__c FROM Team__c];
    List<ContentDocumentLink> links = new List<ContentDocumentLink>();
    List<Id> clientIds = new List<Id>();
    List<Id> dogIds = new List<Id>();
    List<Id> teamIds = new List<Id>();
    for (Team__c team : teams) {
      teamIds.add(team.Id);
      List<ContentVersion> clientDocs = getEntityDocs(team.Client__c, 'Client');
      for (ContentVersion cv : clientDocs) {
        links.add(
          new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId,
            LinkedEntityId = team.Id
          )
        );
      }

      List<ContentVersion> dogDocs = getEntityDocs(team.Dog__c, 'Dog');
      for (ContentVersion cv : dogDocs) {
        if (cv.Type__c == 'VacExams') {
          continue;
        }
        links.add(
          new ContentDocumentLink(
            ContentDocumentId = cv.ContentDocumentId,
            LinkedEntityId = team.Id
          )
        );
      }
    }

    FileService.insertLinks(links, teamIds);
    settings.LinkFilesToTeamMembers__c = true;
    upsert settings;
  }

  public static List<ContentVersion> getEntityDocs(Id id, String category) {
    // find the documents linked to the clients
    List<ContentDocumentLink> cdls = [
      SELECT ID, ContentDocumentId, LinkedEntityId
      FROM ContentDocumentLink
      WHERE LinkedEntityId = :id
    ];
    List<Id> docIds = new List<Id>();
    for (ContentDocumentLink cdl : cdls) {
      docIds.add(cdl.ContentDocumentId);
    }
    List<ContentVersion> cvs = [
      SELECT Id, ContentDocumentId, Category__c, Type__c
      FROM ContentVersion
      WHERE ContentDocumentId IN :docIds AND Category__c = :category
    ];

    return cvs;
  }

  public void linkTeamLogs() {
    // Get the list of teams
    List<Team__c> teams = [
      SELECT Id, Client__c, Dog__c, Handler__c
      FROM Team__c
    ];

    for (Team__c team : teams) {
      // get the logs that match
      List<Log__c> logs = [
        SELECT Id, Team__c
        FROM Log__c
        WHERE Client__c = :team.Client__c AND Dog__c = :team.Dog__c
      ];
      for (Log__c log : logs) {
        // set the team
        log.Team__c = team.Id;
      }
      update logs;
    }
  }

  public static void send(Id userId, String subject, String htmlBody) {
    List<User> users = [
      SELECT Name, FirstName, LastName, UserName, Email
      FROM User
      WHERE Id = :userId
    ];
    User u = users.size() > 0 ? users[0] : new User(Id = userId);
    sendEmail(
      new List<String>{ u.Email, 'deborahe@atlasdog.org' }, // <= replace with your default email
      subject,
      htmlBody,
      new Map<String, Blob>()
    );
  }

  public static Boolean sendEmail(
    List<String> recipients,
    String subject,
    String htmlBody,
    Map<String, Blob> attachments
  ) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(recipients);
    mail.setSubject(subject);
    mail.setHtmlBody(htmlBody);
    List<Messaging.EmailFileAttachment> attachmentsList = new List<Messaging.EmailFileAttachment>();
    for (String fileName : attachments.keySet()) {
      Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
      attachment.setFileName(fileName);
      attachment.setBody(attachments.get(fileName));
      attachmentsList.add(attachment);
    }
    mail.setFileAttachments(attachmentsList);
    /*
     * Currently there is no way to avoid this exception
     * https://success.salesforce.com/ideaView?id=08730000000cHBEAA2
     */
    try {
      Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
      return true;
    } catch (EmailException e) {
      //emailInvocationFailures++;
      return false;
    }
  }

  private void setBackgroundCheckTypes() {
    List<BackgroundCheck__c> checks = [
      SELECT Id, Type__c
      FROM BackgroundCheck__c
    ];
    for (BackgroundCheck__c check : checks) {
      check.Type__c = 'Criminal';
    }
    update checks;
  }

  global static void setSharingFields() {
    List<Contact> contacts = [
      SELECT
        IsBoardMember__c,
        IsClient__c,
        IsPuppyRaiser__c,
        IsStaff__c,
        IsStandalone__c,
        IsTeamFacilitator__c,
        IsTrainer__c,
        IsVolunteer__c,
        ShareBoard__c,
        SharePuppyRaiser__c,
        ShareStaff__c,
        ShareStandalonePrograms__c,
        ShareTeam__c,
        ShareTrainer__c,
        ShareVolunteer__c
      FROM Contact
      WHERE
        IsBoardMember__c = TRUE
        OR IsClient__c = TRUE
        OR IsPuppyRaiser__c = TRUE
        OR IsStaff__c = TRUE
        OR IsStandalone__c = TRUE
        OR IsTeamFacilitator__c = TRUE
        OR IsTrainer__c = TRUE
        OR IsVolunteer__c = TRUE
    ];

    Map<Id, Contact> contactMap = new Map<Id, Contact>();

    for (Contact person : contacts) {
      person.ShareBoard__c = person.IsBoardMember__c;
      person.SharePuppyRaiser__c = person.IsPuppyRaiser__c;
      person.ShareStaff__c = person.IsStaff__c;
      person.ShareStandalonePrograms__c = person.IsStandalone__c;
      person.ShareTeam__c = person.IsClient__c || person.IsTeamFacilitator__c;
      person.ShareTrainer__c = person.IsTrainer__c;
      person.ShareVolunteer__c = person.IsVolunteer__c;
      contactMap.put(person.Id, person);
    }

    // Get related contacts
    npe4__Relationship__c[] related = [
      SELECT
        Id,
        npe4__RelatedContact__c,
        npe4__RelatedContact__r.Positions__c,
        npe4__RelatedContact__r.ShareBoard__c,
        npe4__RelatedContact__r.SharePuppyRaiser__c,
        npe4__RelatedContact__r.ShareStaff__c,
        npe4__RelatedContact__r.ShareStandalonePrograms__c,
        npe4__RelatedContact__r.ShareTeam__c,
        npe4__RelatedContact__r.ShareTrainer__c,
        npe4__RelatedContact__r.ShareVolunteer__c,
        npe4__Contact__c
      FROM npe4__Relationship__c
      WHERE
        (npe4__Type__c LIKE '%Emergency Contact'
        OR npe4__Type__c = 'Guardian')
        AND npe4__Status__c = 'Current'
        AND npe4__Contact__c IN :contactMap.keySet()
    ];
    for (npe4__Relationship__c relation : related) {
      Contact shared = contactMap.get(relation.npe4__Contact__c);
      Contact share = contactMap.get(relation.npe4__RelatedContact__c);
      if (share == null) {
        share = relation.npe4__RelatedContact__r;
      }
      share.ShareBoard__c = share.ShareBoard__c || shared.ShareBoard__c;
      share.SharePuppyRaiser__c =
        share.SharePuppyRaiser__c || shared.SharePuppyRaiser__c;
      share.ShareStaff__c = share.ShareStaff__c || share.ShareStaff__c;
      share.ShareStandalonePrograms__c =
        share.ShareStandalonePrograms__c || shared.ShareStandalonePrograms__c;
      share.ShareTeam__c = share.ShareTeam__c || shared.ShareTeam__c;
      share.ShareTrainer__c = share.ShareTrainer__c || shared.ShareTrainer__c;
      share.ShareVolunteer__c =
        share.ShareVolunteer__c || shared.ShareVolunteer__c;
      if (!contactMap.containsKey(relation.npe4__RelatedContact__c)) {
        contactMap.put(relation.npe4__RelatedContact__c, share);
      }
    }
    update contactMap.values();
  }
}
