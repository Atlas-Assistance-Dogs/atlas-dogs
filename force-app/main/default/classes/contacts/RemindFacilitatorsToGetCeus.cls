global class RemindFacilitatorsToGetCeus implements Schedulable {
  private final ContactService service;

  // default constructor
  public RemindFacilitatorsToGetCeus() {
    service = new ContactService();
  }

  @TestVisible
  private RemindFacilitatorsToGetCeus(ContactService service) {
    this.service = service;
  }

  global void execute(SchedulableContext SC) {
    service.remindFacilitatorsToGetCeus();
  }
}
