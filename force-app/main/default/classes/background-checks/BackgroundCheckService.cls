public with sharing class BackgroundCheckService {
  private BackgroundCheckRepository repo;
  private ContactRepository contactRepo;
  private TaskRepository taskRepo;
  public BackgroundCheckService() {
    this.repo = new BackgroundCheckRepository();
    this.contactRepo = new ContactRepository();
    this.taskRepo = new TaskRepository();
  }

  @TestVisible
  private BackgroundCheckService(
    BackgroundCheckRepository bgcrepo,
    ContactRepository contactRepo,
    TaskRepository taskRepo
  ) {
    this.repo = bgcrepo;
    this.contactRepo = contactRepo;
    this.taskRepo = taskRepo;
  }

  public void createReminderTask() {
    AtlasSettings__c settings = AtlasSettings__c.getOrgDefaults();
    // check to see if this setting is missing
    if (settings.BackgroundCheckRenewalYears__c == null) {
      settings.BackgroundCheckRenewalYears__c = 1;
      upsert settings;
    }

    // find the cutoff for which background checks to remind
    Date threshold = Date.today()
      .addYears(-1 * (Integer) settings.BackgroundCheckRenewalYears__c)
      .addMonths(1);

    // Get the group to assign the task to
    Group adminGroup = [
      SELECT Id
      FROM Group
      WHERE Name = 'Background Check Administrator' AND Type = 'Queue'
    ];

    // Make sure we only have one Background check per contact
    Set<Id> contactIds = new Set<Id>();
    Set<Id> creditIds = new Set<Id>();
    Set<Id> criminalIds = new Set<Id>();
    // Check for any contacts that need background checks
    Contact[] contacts = this.contactRepo.getContactsNeedingBackgroundChecks();

    for (Contact person : contacts) {
      contactIds.add(person.Id);
      if (person.VolunteerAccess__c.contains('Credit Check Required')) {
        creditIds.add(person.Id);
      }
      if (person.VolunteerAccess__c.contains('Background Check Required')) {
        criminalIds.add(person.Id);
      }
    }

    BackgroundCheck__c[] checks = repo.getMatchingChecksForContacts(
      contactIds,
      threshold
    );

    // Remove the contacts with recent-enough background checks from the list
    for (BackgroundCheck__c check : checks) {
      if (check.Type__c == 'Criminal') {
        criminalIds.remove(check.Contact__c);
      } else if (check.Type__c == 'Credit') {
        creditIds.remove(check.Contact__c);
      }
    }

    // Create a list of Tasks
    Task[] tasks = new List<Task>();
    // Create tasks to order background checks
    for (Id contactId : criminalIds) {
      tasks.add(
        new Task(
          OwnerId = adminGroup.Id,
          Subject = 'Order background check',
          Status = 'Open',
          Priority = 'Normal',
          WhoId = contactId,
          ActivityDate = Date.today().addMonths(1)
        )
      );
    }
    // Create tasks to order credit checks
    for (Id contactId : creditIds) {
      tasks.add(
        new Task(
          OwnerId = adminGroup.Id,
          Subject = 'Order credit check',
          Status = 'Open',
          Priority = 'Normal',
          WhoId = contactId,
          ActivityDate = Date.today().addMonths(1)
        )
      );
    }

    taskRepo.create(tasks);
  }
}
