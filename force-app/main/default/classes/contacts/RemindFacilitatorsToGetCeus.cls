global class RemindFacilitatorsToGetCeus implements Schedulable {
  private final CertificationService service;

  // default constructor
  public RemindFacilitatorsToGetCeus() {
    service = new CertificationService();
  }

  @TestVisible
  private RemindFacilitatorsToGetCeus(CertificationService service) {
    this.service = service;
  }

  global void execute(SchedulableContext SC) {
    service.remindFacilitatorsToGetCeus();
  }
}
