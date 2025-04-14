global class RemindToGetCeus implements Schedulable {
  private final CertificationService service;

  // default constructor
  public RemindToGetCeus() {
    service = new CertificationService();
  }

  @TestVisible
  private RemindToGetCeus(CertificationService service) {
    this.service = service;
  }

  global void execute(SchedulableContext sc) {
    service.remindToGetCeus();
  }
}
