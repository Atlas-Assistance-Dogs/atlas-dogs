global class RemindClients implements Schedulable {
  private TeamService service;
  // default constructor
  public RemindClients() {
    service = new TeamService();
  }

  // used for test
  @TestVisible
  private RemindClients(TeamService service) {
    this.service = service;
  }

  global void execute(SchedulableContext SC) {
    service.remindClients();
  }
}
