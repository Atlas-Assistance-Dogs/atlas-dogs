global class ScheduledClientReminders implements Schedulable {
  global void execute(SchedulableContext SC) {
    TeamService service = new TeamService();

    service.remindClients();
  }
}
