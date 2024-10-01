global class RemindFacilitators implements Schedulable {
    private final TeamService service;

    // default constructor
    public RemindFacilitators() {
        service = new TeamService();
    }

    // used for test
    @TestVisible
    private RemindFacilitators(TeamService service) {
        this.service = service;
    }

    global void execute(SchedulableContext SC) {
        service.remindFacilitators();
    }
}
