public inherited sharing class CategoryRuleService {
  private UserRepository userRepo = new UserRepository();
  private CategoryRuleRepository repo = new CategoryRuleRepository();
  public CategoryRuleService() {
    userRepo = new UserRepository();
    repo = new CategoryRuleRepository();
  }
  @TestVisible
  private CategoryRuleService(
    UserRepository uRepo,
    CategoryRuleRepository crRepo
  ) {
    userRepo = uRepo;
    repo = crRepo;
  }
  public List<String> getAllowedCategoriesForUser() {
    List<String> groupNames = userRepo.getGroupNames(UserInfo.getUserId());

    // get the categories that work for the object
    List<CategoryRule__c> rules = repo.getAll();
    List<String> categories = new List<String>();
    for (CategoryRule__c rule : rules) {
      if (
        String.isBlank(rule.GroupName__c) ||
        groupNames.contains(rule.GroupName__c)
      ) {
        categories.addAll(rule.Category__c.split(';'));
      }
    }
    return categories;
  }

  public Set<String> getAllowedCategoriesForObject(
    Id recordId,
    Boolean isUpload
  ) {
    if (isUpload == null)
      isUpload = false;
    string objLabel = recordId.getSObjectType().getDescribe().getLabel();

    List<String> groupNames = userRepo.getGroupNames(UserInfo.getUserId());

    // get the categories that work for the object from atlas1
    Set<String> allCategories = CategoryRuleController.getCategorySetForObject(
      recordId
    );

    Set<String> categories = new Set<String>();
    // only allow the categories that match the groups the user is in
    List<CategoryRule__c> rules = repo.getForGroupNames(
      objLabel,
      allCategories,
      groupNames
    );

    for (CategoryRule__c rule : rules) {
      if (
        ((isUpload && rule.ReadOnly__c != true) || !isUpload) &&
        rule.Category__c != null
      ) {
        categories.addAll(rule.Category__c.split(';'));
      }
    }

    return categories;
  }

  public Set<String> getCategorySetForObject(Id recordId) {
    string objLabel = recordId.getSObjectType().getDescribe().getLabel();

    // get the categories that work for the object
    List<CategoryRule__c> rules = repo.getCategoriesForObject(objLabel);
    Set<String> categories = new Set<String>();
    for (CategoryRule__c rule : rules) {
      categories.addAll(rule.Category__c.split(';'));
    }

    // If the object is a Contact, we also check positions
    List<String> positions = new List<String>();
    if (objLabel == Contact.class.getName()) {
      Contact person = [
        SELECT Id, Positions__c
        FROM Contact
        WHERE Id = :recordId
      ];
      if (person.Positions__c != null) {
        positions = person.Positions__c.split(';');
      }

      rules = repo.getCategoriesForObject('Contact', positions);
      for (CategoryRule__c rule : rules) {
        categories.addAll(rule.Category__c.split(';'));
      }
    }
    return categories;
  }

  public List<Option> getCategoryEntriesForObject(
    Id recordId,
    Boolean isUpload
  ) {
    // See what categories the user has access to
    Set<String> categories = getAllowedCategoriesForObject(recordId, isUpload);

    // Map in the types for each allowed category
    Map<string, string> categoryEntries = FileController.getEntryMap(
      CategoryRule__c.Category__c.getDescribe()
    );
    List<Option> entries = new List<Option>();
    for (string category : categories) {
      Option option = new Option(category, categoryEntries.get(category));
      entries.add(option);
    }
    entries.sort();
    return entries;
  }
}
