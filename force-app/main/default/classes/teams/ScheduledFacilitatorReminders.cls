global class ScheduledFacilitatorReminders implements Schedulable {
  global void execute(SchedulableContext SC) {
    TeamService service = new TeamService();

    service.remindFacilitators();
  }
}
